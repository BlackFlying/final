function data = load_data()
    %% Load the data
    % output: data is a 27-dimension matrix, including the labels
    load('trueLabels.mat');
    features = csvread('pool.csv');
    % revise the labels
    trueLabels(trueLabels == 1) = 2;
    trueLabels(trueLabels == 0) = 1;
    
    data = [features trueLabels'];
end