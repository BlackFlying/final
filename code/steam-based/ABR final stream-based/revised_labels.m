function labels = revised_labels(labels)
    labels(labels == 1) = 2;
    labels(labels == 0) = 1;
end