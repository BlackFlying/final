function loss = computeLoss(model, data);
%% Compute the loss based on current model
    predictions = predict(model, data(:, 1:end-1));
    error_nums = length(predictions ~= data(:,end));
    loss = error_nums/length(predictions);
end