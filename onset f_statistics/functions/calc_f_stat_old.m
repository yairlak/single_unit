function results = calc_f_stat(data, settings, params)
fname = sprintf('no_response_phonemes_%s.mat', settings.language);
load(fullfile(settings.path2data_phonemes, '..', fname));

%%
num_units = length(data.rasters);
all_units = struct;

for unit = 1:num_units
   curr_phonemes = fieldnames(data.rasters_binned(unit));
   if settings.omit_no_response_phonemes
        for i = 1:length(no_responses_phonemes)
              IX = strcmp(curr_phonemes, no_responses_phonemes{i});
              curr_phonemes(IX) = [];
        end
   end
   num_phonemes = length(curr_phonemes);
   
   for ph = 1:num_phonemes
       curr_ph = curr_phonemes{ph};
       binned_raster = data.rasters_binned(unit).(curr_ph);
       raster = data.rasters(unit).data.BlockSpikeTrains.(curr_ph);
       if isfield(all_units, curr_ph)
            all_units.binned_raster.(curr_ph) = all_units.binned_raster.(curr_ph) + binned_raster;
            all_units.raster.(curr_ph) = all_units.raster.(curr_ph) + raster;
       else
           all_units.binned_raster.(curr_ph) = binned_raster;
           all_units.raster.(curr_ph) = raster;
       end
       
   end
end

for ph = 1:num_phonemes
    curr_ph = curr_phonemes{ph};
    curr_raster = all_units.raster.(curr_ph);
    results.time_onsets = 1:params.sliding_bin_step:(size(curr_raster,2)-params.sliding_bin_size+1);
    cnt = 1;
    for t = results.time_onsets 
        curr_block = curr_raster(:,t:(t+params.sliding_bin_size-1));
        curr_block = mean(curr_block, 2);
        raster_sliding(:,cnt) = curr_block;
        cnt = cnt + 1;
    end
    all_units.raster_sliding.(curr_ph) = raster_sliding;
end


%% binned raster
   curr_phonemes = fieldnames(all_units.binned_raster);
   num_phonemes = length(curr_phonemes);
   
   total_within_phoneme_variability = 0;
   overall_mean_of_data = 0;
   number_of_observations = 0;
   for ph = 1:num_phonemes
       curr_ph = curr_phonemes{ph};
       binned_raster = all_units.binned_raster.(curr_ph);
       
       within_phoneme_variability = sum(bsxfun(@minus, binned_raster, mean(binned_raster)).^2);
       total_within_phoneme_variability = total_within_phoneme_variability + within_phoneme_variability;
       
       overall_mean_of_data = overall_mean_of_data + sum(binned_raster);
       number_of_observations = number_of_observations + size(binned_raster, 1);
   end
   total_within_phoneme_variability = total_within_phoneme_variability/(number_of_observations - num_phonemes);
   overall_mean_of_data = overall_mean_of_data/number_of_observations;
   
   %
   between_variability = 0;
   for ph = 1:num_phonemes
       curr_ph = curr_phonemes{ph};
       binned_raster = all_units.binned_raster.(curr_ph);
       
       n_i = size(binned_raster, 1);
       
       between_variability = between_variability + n_i * (mean(binned_raster) - overall_mean_of_data) .^ 2;
   end
   between_variability = between_variability/(num_phonemes - 1);
   
   %
   results.f_stat_binned = between_variability./total_within_phoneme_variability;
   
%% Sliding raster
   curr_phonemes = fieldnames(all_units.raster_sliding);
   num_phonemes = length(curr_phonemes);
   
   total_within_phoneme_variability = 0;
   overall_mean_of_data = 0;
   number_of_observations = 0;
   for ph = 1:num_phonemes
       curr_ph = curr_phonemes{ph};
       raster_sliding = all_units.raster_sliding.(curr_ph);
       
       within_phoneme_variability = sum(bsxfun(@minus, raster_sliding, mean(raster_sliding)).^2);
       total_within_phoneme_variability = total_within_phoneme_variability + within_phoneme_variability;
       
       overall_mean_of_data = overall_mean_of_data + sum(raster_sliding);
       number_of_observations = number_of_observations + size(raster_sliding, 1);
   end
   total_within_phoneme_variability = total_within_phoneme_variability/(number_of_observations - num_phonemes);
   overall_mean_of_data = overall_mean_of_data/number_of_observations;
   
   %
   between_variability = 0;
   for ph = 1:num_phonemes
       curr_ph = curr_phonemes{ph};
       raster_sliding = all_units.raster_sliding.(curr_ph);

       n_i = size(raster_sliding, 1);
       
       between_variability = between_variability + n_i * (mean(raster_sliding) - overall_mean_of_data) .^ 2;
   end
   between_variability = between_variability/(num_phonemes - 1);
   
   %
   results.f_stat_sliding = between_variability./total_within_phoneme_variability;

end