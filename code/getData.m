% getData function: get number of random data from raw 
function data = getData(num, raw_data, true_labels, number_labels)
    
    raw_data = [raw_data true_labels'];
    data_sample = datasample(raw_data, num);
        
    labels = zeros(1, number_labels);
    
    label_sample = data_sample(: , end);
    
    for i = 1: length(label_sample)
        labels(label_sample(i)) = labels(label_sample(i)) + 1;
    end
    
    for i = 1 : number_labels        
        current_label_index = find(label_sample == i);
        current_label_data = data_sample(current_label_index,:); % positive data
        [false_data, false_data_index] = removerows(data_sample,'ind', current_label_index);
        false_data = datasample(false_data, labels(i));
        false_data(:,end) = 0; % make sure all false samples' label are 0
        current_label_training = [current_label_data;false_data];
        data{i} = current_label_training;
    end
    
end