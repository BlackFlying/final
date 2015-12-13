random_number = 1;
number_labels = 8;

total_number = 1000;

% get the raw_data, labels, testSet
raw_data = csvread('pool.csv');
load('trueLabels');
labels = revised_labels(trueLabels);
testSet = csvread('testSet.csv');
testSet = testSet(1 : 250, :);

% combine raw_data and labels to get raw_instances
raw_instances = [raw_data, labels'];

% create a new data: 1 * 9 cells
data = cell(1, number_labels + 1);

% create a new models: 1 * 8 cells
models = cell(1, number_labels);

number_call_oracle = 0;

training_number = 10;
% training the original model
for i = 1 : training_number
    next_image = nextImage(raw_data);
    next_image_label = oracle2(next_image);
    next_image_with_label = [next_image, next_image_label];

    % get new image with true label and update the data and models
    data = updateData(data, next_image_with_label, number_labels);
    models = getModels(data, number_labels);
    
    % get all the training data to the overall data set for the overall
    % classification
    data{number_labels + 1} = [data{number_labels + 1}; next_image_with_label];
end

testError = zeros(total_number, 1);
total_number_call_oracle = zeros(total_number, 1);

total_random_pick_number = zeros(total_number, 1);
total_overall_classify_number = zeros(total_number, 1);
total_directly_pick_number = zeros(total_number, 1);

for k = 1 : total_number
        
    % display(sprintf('Time %d is processing, oracle cost is %d',k, number_call_oracle))    
    % get next_image
    next_image = nextImage(raw_data);
    current_prediction = zeros(1, number_labels);
    for i = 1 : number_labels
        if isempty(models{i})
            % There is not binary classification model for this label now.
            current_prediction(1, i) = 0;
        else
            current_prediction(1, i) = predict(models{i}, next_image);
        end
    end

    % call not decide the next_image's label
    if size(find(current_prediction ~= 0), 2) ~= 1
        % call oracle2()
        next_image_label = oracle2(next_image);
        number_call_oracle = number_call_oracle + 1;
        next_image_with_label = [next_image, next_image_label];

        % get new image with true label and update the data and models
        data = updateData(data, next_image_with_label, number_labels);
        models = getModels(data, number_labels);
        
        % get all the training data to the overall data set for the overall
        % classification
        data{number_labels + 1} = [data{number_labels + 1}; next_image_with_label];
    else
        % can decide the next_image's label, do not need to call the oracle2()
    end
    testSet_predictions = zeros(size(testSet, 1), 1);
    randomly_pick_number = 0;
    
    % count the number_call_oracle for each round
    total_number_call_oracle(k, 1) = number_call_oracle;
    
    random_pick_number = 0;
    overall_classify_number = 0;
    directly_pick_number = 0;
    
    % make the predictions for the testSet data
    for i = 1 : size(testSet, 1)
        current_prediction = getPrediction(models, testSet(i, :));
        if length(current_prediction(current_prediction ~= 0)) == 0        
            testSet_predictions(i, 1) = randi(number_labels);
            randomly_pick_number = randomly_pick_number + 1;
                
            % using overall classification
            overall_model_prediction = multisvm(data{number_labels + 1}(:, 1 : end - 1), data{number_labels + 1}(:, end), testSet(i, :));
            testSet_predictions(i, 1) = overall_model_prediction;
            
            overall_classify_number = overall_classify_number + 1;
            
        elseif length(current_prediction(current_prediction ~= 0)) ~= 1
            % randomly choose one predicted label
            positive_results = current_prediction(current_prediction ~= 0);
            
            % using overall classification
            overall_model_prediction = multisvm(data{number_labels + 1}(:, 1 : end - 1), data{number_labels + 1}(:, end), testSet(i, :));
            
            if size(find(positive_results == overall_model_prediction), 2) ~= 0
                % pick the overall classification one.
                testSet_predictions(i, 1) = overall_model_prediction;
                overall_classify_number = overall_classify_number + 1;
            else
                % randomly pick one.
                testSet_predictions(i, 1) = datasample(positive_results, 1);
                random_pick_number = random_pick_number + 1;
            end  
        else
            % only one positive predictino
            testSet_predictions(i, 1) = find(current_prediction ~= 0);
            directly_pick_number = directly_pick_number + 1;
        end
    end
    testError(k) = getTestError(testSet_predictions); 
    % display(sprintf('testError is %d', testError(k))) 
    
    total_random_pick_number(k, 1) = random_pick_number;
    total_overall_classify_number(k, 1) = overall_classify_number;
    total_directly_pick_number(k, 1) = directly_pick_number;
    
    display(sprintf('Time %d, cost %d, random_pick_number is %d, overall_classify_number is %d, directly_pick_number is %d',k, number_call_oracle, random_pick_number, overall_classify_number, directly_pick_number))
end





