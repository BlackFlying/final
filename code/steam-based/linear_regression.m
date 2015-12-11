function loss = linear_regression(data, labels)

    [data_row, data_column] = size(data);
    loss = zeros(data_row, 1);
    
    % adding constant column to the data
    data = [data, ones(data_row, 1)];
    
    size(data' * data)
    size(inv(data' * data))
    
    size(inv(data' * data) * data')
    size(inv(data' * data) * data' * labels')
    
    weights = inv(data' * data) * data' * labels';
    
    for i = 1 : data_row
        hypothesis = data(i, :) * weights;
        error = labels(i) - hypothesis;
        loss(i, 1) = error;
    end
    
    plot(loss)
    
end