clear all
close all
load('../data/sub1_comp.mat');
%load('../data/sub1_testlabels.mat');
clear test_data

% train_data = train_data(1:10000,:);
% train_dg = train_dg(1:10000,:);

%Subtract Channel means to remove dc bias
train_data_means = mean(train_data);
train_data = train_data-train_data_means(ones(1,size(train_data, 1)),:);

num_train_points = floor(size(train_data, 1)*.7);
num_train_channels = size(train_data, 2);
num_test_points = size(train_data, 1) - num_train_points;

temp_a = train_data;
temp_b = train_dg;


train_data = temp_a(1:num_train_points, :);
train_dg = temp_b(1:40:num_train_points, :);
test_data = temp_a(num_train_points+1:end, :);
test_dg = temp_b(num_train_points+1:40:end, :);
clear temp_a temp_b

