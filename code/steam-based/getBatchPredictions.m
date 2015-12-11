function predictions = getBatchPredictions(models, data)
    predctions = zeros(size(data,1), length(models));
    
    for i = 1 : length(models)
        predictions(:, i) = predict(models{i}, data); % transpose may be needed here
    end
end