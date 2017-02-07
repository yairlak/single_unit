function [data, settings] = load_raster_plots(settings, params)
%%
file_names = dir(fullfile(settings.path2data_phonemes, '*.mat'));
num_potential_units = length(file_names);

if settings.units == 0
    settings.units = 1:num_potential_units;
end

for unit = 1:length(settings.units)
    temp = load(fullfile(settings.path2data_phonemes, file_names(settings.units(unit)).name));
    rasters(unit).data.BlockSpikeTrains = temp.BlockSpikeTrains;
end
data.rasters = rasters;
end