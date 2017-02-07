function results = calc_f_stat_per_unit(data, settings, params)
num_units = length(data.rasters);

for unit = 1:num_units
   curr_phonemes = fieldnames(data.rasters_binned(unit));
   num_phonemes = length(curr_phonemes);
   
   total_within_phoneme_variability = 0;
   overall_mean_of_data = 0;
   number_of_observations = 0;
   for ph = 1:num_phonemes
       curr_ph = curr_phonemes{ph};
       binned_raster = data.rasters_binned(unit).(curr_ph);
       
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
       binned_raster = data.rasters_binned(unit).(curr_ph);
       
       n_i = size(binned_raster, 1);
       
       between_variability = between_variability + n_i * (mean(binned_raster) - overall_mean_of_data) .^ 2;
   end
   between_variability = between_variability/(num_phonemes - 1);
   
   %
   results.f_stat(unit, :) = between_variability./total_within_phoneme_variability;
end

end