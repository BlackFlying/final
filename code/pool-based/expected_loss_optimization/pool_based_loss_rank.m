%% Pool based active learning for image classification, up to 512 oracle call
% load data
data = load_data;

% constant definition
INITIAL_SIZE = 50;
ORACLE = 512;
SELECT_SIZE = ORACLE - INITIAL_SIZE;
NUM_LABELS = 8;

% initialize variables
loss = zeros(SELECT_SIZE, 1);
predictions = zeros(size(data,1), NUM_LABELS);

% initialize models
raw_data = load_data;
[data, selected_index] = getData(INITIAL_SIZE, raw_data, NUM_LABELS);
[rest_data,~] = removerows(raw_data, 'ind', selected_index);
models = getModels(data, NUM_LABELS);

% start selection
for i = 1 : SELECT_SIZE
    display(sprintf('running %d round', i));
    predictions = getAllPredictions(models, rest_data);
    % select data based on predictions
    % if more than one selected data, select one randomly
    [selected_observations, rest_data] = getObservations(predictions, rest_data);
    % update data with selected observation
    data = updateData(data, selected_observations, NUM_LABELS);
    % retrain model
    models = getModels(data, NUM_LABELS);
    % compute loss
    loss(i) = computeLoss(models, raw_data);
end
plot(loss);