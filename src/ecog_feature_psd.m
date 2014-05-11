samples_per_feature = 40;
window_size = (128-samples_per_feature)/2;

spectrum = zeros(num_train_channels, 129);
bins = [1 60; 60 100; 100 200];
num_bins = size(bins,1);
num_feature_vectors = floor(num_train_points/samples_per_feature);
features = zeros(num_feature_vectors, num_train_channels*num_bins);
for ii = 1:num_feature_vectors-1
    window_start = (ii*samples_per_feature-window_size+1);
    window_end = (ii+1)*samples_per_feature+window_size;
    if window_start<1
        window_end = window_end - window_start + 1;
        window_start = 1;
    end
    if window_end > num_train_points
        window_start = window_start - (window_end - num_train_points);
        window_end = num_train_points;
    end

    %[window_start window_end window_end-window_start+1]
    for jj = 1:num_train_channels
        %[spectrum(jj,:), w] = periodogram(train_data(window_start:window_end,jj), hamming(window_end-window_start+1), [], 1000);
        [spec, w] = pwelch(train_data(window_start:window_end,jj), [], [], [], 1000);
        %[spectrum(jj,:), w] = pwelch(train_data(window_start:window_end,jj), [], [], [], 1000);
        for kk = 1:num_bins
            idx_s = find(w>=bins(kk,1),1);
            idx_e = find(w>=bins(kk,2),1);
            features(ii, num_bins*(jj-1)+kk) =  sum(spec(idx_s:idx_e))/(w(idx_e)-w(idx_s));
        end
    end
    % surf(10*log10(spectrum))
    % xlabel('Frequency (Hz)');
    % xticklabels = w(1:10:end);
    % xticks = linspace(1, size(spectrum, 2), numel(xticklabels));
    % set(gca, 'XTick', xticks, 'XTickLabel', xticklabels)
    % ylabel('Channels');
    % zlabel('dB');

    % figure
    %plot(spec)
    % plot(w)
    %pause(.01)
end

%train data reduced by
%numel(features)/numel(train_data)