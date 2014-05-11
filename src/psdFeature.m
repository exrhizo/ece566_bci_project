function features = psdFeature(data, bins, delays)
% psdFeature Creates a matrix of feature vectors based on a moving window 
%              power spectra desity. Uses Welch's method to create the PSD.
% 
% Currently the data is assumed to be sampled at 1kHz and this will create
% a feature for every 40 samples.
%
% INPUTS
% data    Matrix with each row an observation and each column a seperate channel.
% bins    Each row is a bin for summerizing the PSD, first column is start
%             second column is the end. In units of frequency.
% delays   Each element of this vector matches with a channel of the data
%             signal, and represents a delays in milliseconds.
%
% OUTPUTS
% features  A matrix of time varying feature vectors, each row represents
%               the features at a seperate time step. And the Channels are
%               split into one feature value for each bin.

samples_per_feature = 40;
window_size = (128-samples_per_feature)/2;
num_data_channels = size(data,2);
num_data_points = size(data,1);

time_step = 40; %ms


%bins = [1 60; 60 100; 100 200];
num_bins = size(bins,1);
num_sample_result = floor(num_data_points/samples_per_feature);
features = zeros(num_sample_result, num_data_channels*num_bins);
for ii = 1:num_sample_result
    window_start = (ii*samples_per_feature-window_size+1);
    window_end = (ii+1)*samples_per_feature+window_size;
    if window_start<1
        window_end = window_end - window_start + 1;
        window_start = 1;
    end
    if window_end > num_data_points
        window_start = window_start - (window_end - num_data_points);
        window_end = num_data_points;
    end

    for jj = 1:num_data_channels
        [spec, w] = pwelch(data(window_start:window_end,jj), [], [], [], 1000);
        idx_delay = ceil(delays(jj)/time_step);
        if idx_delay>=ii
            continue %don't start yet
        end
        for kk = 1:num_bins
            idx_s = find(w>=bins(kk,1),1);
            idx_e = find(w>=bins(kk,2),1);
            features(ii-idx_delay, num_bins*(jj-1)+kk) = sum(spec(idx_s:idx_e))/(w(idx_e)-w(idx_s));
            if num_sample_result == ii & idx_delay ~= 0
                %copy final state to fill in remaining
                features(ii-idx_delay+1:end, num_bins*(jj-1)+kk) = features(ii-idx_delay, num_bins*(jj-1)+kk);
            end
        end

    end

end