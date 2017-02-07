function results = calc_a_stat(data, settings, params)
%% Collect all relevant data
num_units = length(data.rasters);
all_units = struct;
curr_phonemes = fieldnames(data.rasters_binned(1));
num_phonemes = length(curr_phonemes);
   
for ph = 1:num_phonemes
    curr_ph = curr_phonemes{ph};
    for unit = 1:num_units
       raster = data.rasters(unit).data.BlockSpikeTrains.(curr_ph);
       raster_all_units(:,unit,:) = raster;
    end
    all_units.raster_all_units.(curr_ph) = raster_all_units;       
end

for ph = 1:num_phonemes
    curr_ph = curr_phonemes{ph};
    curr_raster = all_units.raster_all_units.(curr_ph);
    results.time_onsets = 1:params.sliding_bin_step:(size(curr_raster,3)-params.sliding_bin_size+1);
    cnt = 1;
    for t = results.time_onsets 
        curr_block = curr_raster(:,:,t:(t+params.sliding_bin_size-1));
        curr_block = nanmean(curr_block, 3);
        raster_sliding(:,:,cnt) = curr_block;
        cnt = cnt + 1;
    end
    all_units.raster_sliding.(curr_ph) = raster_sliding;
end
   
%% Sliding-window representation of raster plots
for t = 1:size(all_units.raster_sliding.('aa'), 3)
    X = []; group = [];
    for ph = 1:num_phonemes
        curr_ph = curr_phonemes{ph};
        X = [X; all_units.raster_sliding.(curr_ph)(:,:,t)];
        group = [group; ones(12, 1)*ph];
    end
    X_all_times(:,:,t) = X;
    group_all_times(:,t) = group;
end

for t = 1:size(all_units.raster_sliding.('aa'), 3)
    try
        [results.a_stat(t).d,results.a_stat(t).p,results.a_stat(t).stats] = manova1(X_all_times(:,:,t), group_all_times(:,t));
    catch
        results.a_stat(t).d = nan;
        results.a_stat(t).p = nan;
        results.a_stat(t).stats = [];
    end
end

%    curr_phonemes = fieldnames(all_units.raster_sliding);
%    num_phonemes = length(curr_phonemes);
%    
%    total_within_phoneme_variability = 0;
%    overall_mean_of_data = 0;
%    number_of_observations = 0;
%    for ph = 1:num_phonemes
%        curr_ph = curr_phonemes{ph};
%        raster_sliding = all_units.raster_sliding.(curr_ph);
%        
%        within_phoneme_variability = nansum(bsxfun(@minus, raster_sliding, nanmean(raster_sliding)).^2);
%        total_within_phoneme_variability = total_within_phoneme_variability + within_phoneme_variability;
%        
%        overall_mean_of_data = overall_mean_of_data + nansum(raster_sliding);
%        number_of_observations = number_of_observations + size(raster_sliding, 1);
%    end
%    total_within_phoneme_variability = total_within_phoneme_variability/(number_of_observations - num_phonemes);
%    overall_mean_of_data = overall_mean_of_data/number_of_observations;
%    
%    %
%    between_variability = 0;
%    for ph = 1:num_phonemes
%        curr_ph = curr_phonemes{ph};
%        raster_sliding = all_units.raster_sliding.(curr_ph);
% 
%        n_i = size(raster_sliding, 1);
%        
%        between_variability = between_variability + n_i * (nanmean(raster_sliding) - overall_mean_of_data) .^ 2;
%    end
%    between_variability = between_variability/(num_phonemes - 1);
   
   %
%    v1 = (num_phonemes - 1);
%    v2 = (number_of_observations - num_phonemes);
%    results.f_stat_sliding = between_variability./total_within_phoneme_variability;
%    results.p_sliding = 1-fcdf(results.f_stat_sliding, v1, v2);
%    results.h_sliding = results.p_sliding < params.alpha_p_value;
end