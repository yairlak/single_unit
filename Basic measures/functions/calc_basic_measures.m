function results = calc_basic_measures(data, settings, params)
%% Sliding-window representation of raster plots
num_units = length(data.rasters);
all_units = struct;

for unit = 1:num_units
   curr_phonemes = fieldnames(data.rasters_binned(unit));
   num_phonemes = length(curr_phonemes);
   for ph = 1:num_phonemes
    curr_ph = curr_phonemes{ph};
    curr_raster = data.rasters(unit).data.BlockSpikeTrains.(curr_ph);
    results.time_onsets = 1:params.sliding_bin_step:(size(curr_raster,2)-params.sliding_bin_size+1);
    cnt = 1;
        for t = results.time_onsets 
            curr_block = curr_raster(:,t:(t+params.sliding_bin_size-1));
            curr_block = mean(curr_block, 2);
            raster_sliding(:,cnt) = curr_block;
            cnt = cnt + 1;
        end
        results.raster_sliding(unit).(curr_ph) = raster_sliding;
        results.PSTH_sliding(unit).(curr_ph) = mean(raster_sliding);
        results.PSTH_STD_sliding(unit).(curr_ph) = std(raster_sliding);
   end
    
end

end