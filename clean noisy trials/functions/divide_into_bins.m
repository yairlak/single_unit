function data = divide_into_bins(data, settings, params)
% Divide raster into bins and generate post-stimulus time histgrams PSTHs
% INPUT:
%
% OUTPUT:
% rasters_binned - mean spike count for each bin and trial (num_trials * num_bins)
% spike_counts_binned - sum spike count for each bin and trial (num_trials * num_bins)
% PSTHs - mean across trials of raster_binned
%
rasters = data.rasters;
num_miliseconds = eval(sprintf('length(%s)', params.time_interval));
for p = 1:length(settings.phonemes)
    ph = settings.phonemes{p};
    for unit = 1:length(settings.units)
        curr_raster = eval(sprintf('rasters(%i).data.BlockSpikeTrains.%s(%s, %s)', unit, ph, settings.trial_interval, params.time_interval));     
        %% divide into bins
        size_raster = size(curr_raster, 1);
        bin_length = floor(num_miliseconds/params.num_bins);
        raster_binned = zeros(size_raster, params.num_bins);
        for bin = 1:params.num_bins
           st = 1 + (bin-1)*bin_length;
           ed = bin*bin_length;
           counts_binned(:, bin) = sum(curr_raster(:,st:ed), 2);
           raster_binned(:, bin) = mean(curr_raster(:,st:ed), 2);
        end
        data.spike_counts_binned(unit).(ph) = counts_binned;
        data.rasters_binned(unit).(ph) = raster_binned;
        data.PSTHs(unit).(ph) = mean(raster_binned);
    end
end

end