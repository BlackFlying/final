function features = nextImage(raw_data)
    features=raw_data(randi(size(raw_data,1)),:);
end