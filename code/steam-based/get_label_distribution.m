function label_distribution = get_label_distribution(labels)
    
    label_distribution = zeros(9, 1);

    for i = 1 : length(labels)
        index = labels(i) + 1
        label_distribution(index) = label_distribution(index) + 1;
    end

end
