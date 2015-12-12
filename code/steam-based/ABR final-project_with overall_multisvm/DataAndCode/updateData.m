function data = updateData(data, new_observation, number_labels)
    new_observation_label = new_observation(:,end);
    data{new_observation_label} = [data{new_observation_label}; new_observation];
    
    % add the new_observation with true label to the overall data
    data{number_labels + 1} = [data{number_labels + 1}; new_observation];
    
    false_observation = new_observation;
    false_observation(end) = 0;
    for i = 1:number_labels
        if i == new_observation_label
            continue;
        else
            data{i} = [data{i}; false_observation];
        end 
    end
end