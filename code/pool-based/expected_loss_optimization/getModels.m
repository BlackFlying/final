function models = getModels(data, number_label)
    for i = 1 : number_label
        X = data{i}(:, 1: end - 1);
        Y = data{i}(:, end);
        models{i} = fitcsvm(X,Y);
    end 
end