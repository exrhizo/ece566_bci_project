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

% disp('bins 2')
% bins = [1 30; 30 90; 90 120; 120 230];
% features = firFeature(train_data, bins, zeros(62,1));
% ecog_regression
% toc

% disp('bins 3')
% bins = [1 25; 25 50; 50 100; 100 230];
% features = firFeature(train_data, bins, zeros(62,1));
% ecog_regression
% toc