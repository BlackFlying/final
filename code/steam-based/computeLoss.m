function loss = computeLoss(data, labels, models)
    final_predictions = zeros(size(data,1),1);

    each_round_prediction = getBatchPredictions(models, data);
    for i = 1 : size(each_round_prediction,1)
        each_prediction = each_round_prediction(i,:);
        positive_result_num = length(each_prediction(each_prediction ~= 0));
        if positive_result_num ==1 % if there is only one choice, perfect
            final_predictions(i) = each_prediction(each_prediction ~= 0);
        elseif positive_result_num == 0 % if there is no choice
            final_predictions(i) = 0;
        else % if there are more than one choice
            positive_results = each_prediction(each_prediction ~= 0);
            % multiple positive results selection strategy
            final_predictions(i) = positive_results(1); % randomly selected
        end
    end
    % MAE mean absolute error
    predict_minus_label = final_predictions - labels';
    error_nums = length(predict_minus_label(predict_minus_label ~= 0));
    loss = error_nums/length(labels);

end