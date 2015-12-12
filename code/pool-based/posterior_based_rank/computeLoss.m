function loss = computeLoss(model, data)
    predictions = predict(model, data(:, 1:end-1));
    error_nums = sum(predictions ~= data(:,end));
    loss = error_nums/length(predictions);
end