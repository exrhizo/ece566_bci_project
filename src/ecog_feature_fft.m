samples_per_feature = 40;
window_size = 492;
window_size = 1004

spectrum = zeros(num_train_channels, (samples_per_feature+2*window_size)/2+1);
%bins = {1:}
num_feature_vectors = floor(num_train_points/samples_per_feature);
%features = zeros(num_feature_vectors, size(bins,1));
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


    % if ii ~= 0
    %     window_start = (ii*samples_per_feature-window_size+1);
    %     if ii ~= num_feature_vectors-1
    %         window_end = (ii+1)*samples_per_feature+window_size;
    %     else
    %         window_end = min((ii+1)*samples_per_feature+window_size, num_train_points);
    %         window_start = window_end - samples_per_feature - 2*window_size;
    %     end
    % else
    %     window_start = 1;
    %     window_end = samples_per_feature + 2*window_size;
    % end
    [window_start window_end window_end-window_start+1]
    for jj = 1:num_train_channels
        [spectrum(jj,:), w] = periodogram(train_data(window_start:window_end,jj), hamming(window_end-window_start+1), [], 1000);
        %spec= periodogram(train_data(window_start:window_end,jj), hamming(window_end-window_start+1));
    end
    surf(10*log10(spectrum))
    figure
    plot(w)
    xlabel('Frequency (Hz)');
    ylabel('Channels');
    zlabel('dB');
    return
    pause(.01)
end