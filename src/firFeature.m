function features = firFeature(data, bins, delays)
% psdFeature Creates a matrix of feature vectors based on the power of the
%                    signal after using an equiripple bandpass filter.
% 
% Currently the data is assumed to be sampled at 1kHz and this will create
% a feature for every 40 samples.
%
% INPUTS
% data    Matrix with each row an observation and each column a seperate channel.
% bins    Each row is a bin for summerizing the PSD, first column is start
%             second column is the end. In units of frequency.
% delays   Each element of this vector matches with a feature of the data
%             signal, and represents a delays in milliseconds.
%
% OUTPUTS
% features  A matrix of time varying feature vectors, each row represents
%               the features at a seperate time step. And the Channels are
%               split into one feature value for each bin.

samples_per_feature = 40;
time_step = 40; %ms
filter_transition = 10;
num_data_channels = size(data,2);
num_data_points = size(data,1);


%bins = [1 60; 60 100; 100 200];
num_bins = size(bins,1);
num_features = num_data_channels*num_bins;
num_sample_result = floor(num_data_points/samples_per_feature);
features = zeros(num_sample_result, num_features);

if numel(delays) < num_features
    delays = zeros(num_data_channels*num_bins, 1);
end

for ii = 1:num_bins
    f_pass1 = bins(ii, 1);
    f_pass2 = bins(ii, 2);
    if f_pass1-filter_transition < 1
        filter_d = fdesign.lowpass('Fp,Fst,Ap,Ast', f_pass2, f_pass2+filter_transition, 6, 60, 1000);
    else
        filter_d = fdesign.bandpass('Fst1,Fp1,Fp2,Fst2,Ast1,Ap,Ast2', f_pass1-filter_transition, f_pass1, f_pass2, f_pass2+filter_transition,60,6,60,1000);
    end
    bin_filter = design(filter_d, 'equiripple');
    filtered_data = filter(bin_filter, data).^2;
    for jj = 1:num_data_channels
        feature_idx = (jj-1)*num_bins+ii;
        if delays(feature_idx)/time_step >= num_sample_result
            continue
        end
        idx_delay = ceil(delays(feature_idx)/time_step);
        for kk = 1:num_sample_result
            if idx_delay>=kk
                continue %don't start yet
            end
            features(kk-idx_delay, feature_idx) = sum(filtered_data((kk-1)*samples_per_feature+1:kk*samples_per_feature,jj));
            if num_sample_result == kk & idx_delay ~= 0
                %copy final state to fill in remaining
                features(kk-idx_delay+1:end, feature_idx) = features(kk-idx_delay, feature_idx);
            end
        end
    end
end