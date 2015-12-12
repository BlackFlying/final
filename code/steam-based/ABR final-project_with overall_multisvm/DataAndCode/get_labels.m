function labels = get_labels()
    filename = 'trueLabels.mat';
    load(filename);
    labels = trueLabels; 
end
