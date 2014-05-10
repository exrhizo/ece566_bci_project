clear all
close all
load('/home/alex/projects/ece566_bci_project/data/sub1_comp.mat');
clear test_data

%Subtract Channel means to remove dc bias
train_data_means = mean(train_data);
train_data = train_data-train_data_means(ones(1,size(train_data, 1)),:);

num_train_points = floor(size(train_data, 1)*.2);
num_train_channels = size(train_data, 2);
num_test_points = size(train_data, 1) - num_train_points;

temp_a = train_data;
temp_b = train_dg;


train_data = temp_a(1:num_train_points, :);
train_dg = temp_b(1:100:num_train_points, :);
test_data = temp_a(num_train_points+1:end, :);
test_dg = temp_b(num_train_points+1:100:end, :);
clear temp_a temp_b

% welch_x = test_data(3500:4500,1);
% welch_y = test_dg(3500:4500,1);

% segmentLength = 100;
% noverlap = 25;
% pxx = pwelch(welch_x,segmentLength,noverlap);
% plot(10*log10(pxx))