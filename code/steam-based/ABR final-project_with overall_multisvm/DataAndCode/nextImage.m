function features = nextImage
data=csvread('pool.csv');
features=data(randi(size(data,1)),:);
end