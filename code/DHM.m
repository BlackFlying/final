num = 100;
number_labels = 8;

% labels = load('trueLabels.mat');
load('trueLabels.mat');
labels = revised_labels(trueLabels);

data = getData(num, raw_data, labels, number_labels);
models = getModels(data, number_labels);

loss = zeros(512 - num,1);

oracle_cost = 0;

for i = 1 : length(raw_data)
    display(sprintf('data %d is processing, oracle cost is %d',i, oracle_cost))
    new_observation = raw_data(i, :);
    predictions = getEachPredictions(models, new_observation);
    
    if length(predictions(predictions ~=0)) ~= 1
        
        if(oracle_cost >= 512 - num)
            break;
        end
        
        % call oracle
        true_label = labels(i);
        oracle_cost = oracle_cost + 1;
        
        new_observation = [new_observation, true_label];
        data = updateData(data, new_observation, number_labels);
        % update the model
        models = getModels(data, number_labels);
        
        loss(oracle_cost) = computeLoss(raw_data, labels, models);
    end
end

