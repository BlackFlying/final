function [selected_observations, rest_data] = getObservations(predictions, data)
    positive_predictions = predictions ~= 0;
    sum_predictions = sum(positive_predictions,2);
    max_num = max(sum_predictions);
    removed_index = find(sum_predictions == max_num);
    [rest_data,~] = removerows(data, 'ind', removed_index);
    selected_data = data(removed_index,:);
    % if more than one observations selected, random select one
    if size(selected_data,1) > 1  
        [selected_observations, selected_index] = datasample(selected_data, 1);
        [unselected_data,~] = removerows(selected_data, 'ind', selected_index);
        rest_data = [rest_data; unselected_data];
    elseif size(selected_data,1) == 1
        selected_observations = selected_data;
    else
        display(sprintf('errors happend here'))
    end
end
