function models = getModels(data, number_label)
    for i = 1 : number_label
        [data_row, data_column] = size(data{2});
        X = data{i}(:, 1: data_column - 1);
        Y = data{i}(:, data_column);
        models{i} = fitcsvm(X,Y);
    end 
end