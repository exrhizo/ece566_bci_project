%The main difference between this and the previous
% version is that this one allows features to be used
% seperately
format long
time_step = 40; %ms
num_sample_result = size(features, 1);
num_features = size(features, 2);
num_bins = size(bins,1);
warning('off', 'stats:regress:RankDefDesignMat')
for ii = [1 2 4]
    top_regressions = zeros(16, 4);
    disp([' Digit: ' num2str(ii)])
    for delay = [160 200 240 280 320 360 400 440 480 520]
        idx_delay = ceil(delay/time_step);
        constant_col = ones(num_sample_result-idx_delay+1,1);
        for jj = 1:num_features
            %This will give warning about rank about ten times for 11 delays * 186 features
            [b, ~, ~, ~, stats] = regress(train_dg(1:end-idx_delay+1,ii), horzcat(features(idx_delay:end, jj), constant_col));
            top_regressions = sortrows(top_regressions, 1);
            if stats(1)>top_regressions(1,1)
                flag = 0;
                for kk = 1:size(top_regressions,1)
                    if top_regressions(kk,4) == jj
                        flag = 1;
                        if stats(1)>top_regressions(kk,1)
                            top_regressions(kk,:) = [stats(1) delay ceil(jj/3) jj];
                        end
                        break;
                    end
                end
                if ~flag
                    top_regressions(1,:) = [stats(1) delay ceil(jj/3) jj];
                end
                %disp(['r^2 ' num2str(stats(1)) ' Channel: ' num2str(jj) ' Digit: ' num2str(ii) ' Delay: ' num2str(delay)])
            end
        end
    end
    top_regressions = sortrows(top_regressions, 4);
    selected_features = top_regressions(:,4);
    num_selected_features = size(selected_features,1);
    delays = top_regressions(:,2)';
    idx_delays = delays./time_step;
    final_train_features = ones(num_sample_result, num_selected_features+1);
    for jj = 1:num_selected_features
        idx_delay = idx_delays(jj);
        final_train_features(1:end-idx_delay, jj) = features(idx_delay+1:end, selected_features(jj));
        final_train_features(end-idx_delay:end, jj) = features(end, selected_features(jj));
    end
    [b, ~, ~, ~, stats] = regress(train_dg(:,ii), final_train_features);
    disp(['R^2 ' num2str(stats(1))])
    b

    % final_train_features_2 = ones(size(final_train_features));
    % final_train_features_2(1:num_train_points/40,1:end-1) = psdFeature(train_data(:, selected_channels), bins, delays);

    expected_dg = final_train_features*b;
    figure
    x = 0:40:(size(train_dg,1)-1)*40;
    plot(x, train_dg(:,ii), 'k')
    hold all
    plot(x, expected_dg, 'r')
    xlabel('Time (msec)');
    ylabel('Finger Position with modeled training data');
    str = sprintf('Training Data. Digit %d', ii);
    title(str)
    legend('Actual position', 'Model position')
    correlation = corr(expected_dg, train_dg(:, ii));
    disp(['Training data correlation: ' num2str(correlation)])

    test_features = ones(floor(num_test_points/40), num_selected_features+1);
    delays = zeros(num_features, 1);
    for jj = 1:num_features
        idx = find(jj==top_regressions(:,4));
        if idx
            delays(jj) = top_regressions(idx,2);
        else
            delays(jj) = num_test_points;
        end
    end
    temp = firFeature(test_data, bins, delays);
    test_features(:, 1:num_selected_features) = temp(:, selected_features);
    expected_dg = test_features*b;

    figure
    x = 0:40:num_test_points-40;
    plot(x, test_dg(:,ii), 'k')
    hold all
    plot(x, expected_dg, 'r')
    xlabel('Time (msec)');
    ylabel('Finger Position with modeled test data');
    str = sprintf('Test Data. Digit %d', ii);
    title(str)
    legend('Actual position', 'Model position')
    correlation = corr(expected_dg, test_dg(:, ii));
    disp(['Testing data correlation: ' num2str(correlation)])
end

%corr(mean(test_dg(:, 1)).*ones(size(test_dg,1),1), test_dg(:, 1))
%correlation with a flat line is basically 0