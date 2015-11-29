function predictions = getEachPredictions(models, data_point)
    predictions = zeros(1, length(models));
    
    for i = 1 : length(models)
        predictions(i) = predict(models{i}, data_point);
    end
end