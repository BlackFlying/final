function loss = pool_based_random()
%% random learner for pool based 
    % load data
    data = load_data;

    % constant definition
    INITIAL_SIZE = 50;
    ORACLE = 512;
    SELECT_SIZE = ORACLE - INITIAL_SIZE;

    % inital variable
    loss = zeros(SELECT_SIZE, 1);

    % extract initial training data
    [training_data, training_index] = datasample(data, INITIAL_SIZE);
    [rest_data, ~] = removerows(data, 'ind', training_index);
    % inital classifier
    model = fitcnb(training_data(:,1:end-1), training_data(:,end));
    for i = 1:SELECT_SIZE
        % make predictions
        display(sprintf('random round %d is running', i))

        [random_observation, random_index] = datasample(rest_data, 1);
        [rest_data, ~] = removerows(rest_data, 'ind', random_index);

        % merge new observation with training data
        training_data = [training_data; random_observation];

        % retrain the model
        model = fitcnb(training_data(:,1:end-1), training_data(:,end));

        % calculate the loss
        loss(i) = computeLoss(model, data);
    end
end