function predictions = getPrediction(models, new_obeservation)
    predctions = zeros(1, length(models));
    
    for i = 1 : length(models)
        if (isempty(models{i}))
            predictions(1, i) = 0;
        else
            predictions(1, i) = predict(models{i}, new_obeservation); % transpose may be needed here
        end
        
    end
end