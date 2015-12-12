function predictions = getAllPredictions(models, data)
    predictions = zeros(size(data,1), length(models));
    
    for i = 1 : length(models)
        predictions(:, i) = predict(models{i}, data(:, 1:end-1))'; % transpose may be needed here
    end
end