tic
disp('load')
ecog_load;
toc
disp('bins 1')
bins = [1 60; 60 100; 100 200];
features = psdFeature(train_data, bins, zeros(62,1));
ecog_regression
toc

disp('bins 2')
bins = [1 30; 30 90; 90 120; 120 230];
features = psdFeature(train_data, bins, zeros(62,1));
ecog_regression
toc

disp('bins 3')
bins = [1 25; 25 50; 50 100; 100 230];
features = psdFeature(train_data, bins, zeros(62,1));
ecog_regression
toc