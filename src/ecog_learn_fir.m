% Compare different feature selection methods
% with FIR filter for features.
tic
disp('load')
ecog_load;
toc
disp('FIR with original selection')
bins = [1 60; 60 100; 100 200];
features = firFeature(train_data, bins, []);
ecog_regression
toc

disp('FIR with individual feature selection')
bins = [1 60; 60 100; 100 200];
features = firFeature(train_data, bins, []);
ecog_regression_2
toc