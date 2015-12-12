num = 50;
number_labels = 8;

% load the 'pool.csv' to get the raw_data
raw_data = load('pool.csv');

% labels = load('trueLabels.mat');
load('trueLabels.mat');
labels = revised_labels(trueLabels);

% get some random data from pool.csv and divide them into 8 cells according
% to their label
data = getData(num, raw_data, labels, number_labels);

% train 8 individual models according to 8 cells data
models = getModels(data, number_labels);

loss = zeros(250 - num,1);

oracle_cost = 0;

for i = 1 : length(raw_data)
    display(sprintf('data %d is processing, oracle cost is %d',i, oracle_cost))
    new_observation = raw_data(i, :);
    
    % for each new observation, use 8 individual model to predict the label
    predictions = getEachPredictions(models, new_observation);
    
    % using the overall multi-labels svm model to make the overall prediction
    overall_model_prediction = multisvm(data{number_labels + 1}(:, 1 : end - 1), data{number_labels + 1}(:, end), new_observation);
    
    if length(predictions(predictions ~=0)) ~= 1
        % have already used run out of budget
        if(oracle_cost >= 250 - num)
            break;
        end
        
        % call oracle
        true_label = labels(i);
        oracle_cost = oracle_cost + 1;
        
        new_observation = [new_observation, true_label];
        
        % update the 8 data cells
        data = updateData(data, new_observation, number_labels);
        
        % update the 8 data models
        models = getModels(data, number_labels);
        
        loss(oracle_cost) = computeLoss(raw_data, labels, models, overall_model_prediction);
    end
end

