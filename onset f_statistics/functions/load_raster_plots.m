function [data, settings] = load_raster_plots(settings, params)
%%
file_names = dir(fullfile(settings.path2data_phonemes, '*.mat'));
num_potential_units = length(file_names);

if settings.units == 0
    settings.units = 1:num_potential_units;
end

for unit = 1:length(settings.units)
    rasters(unit).data = load(fullfile(settings.path2data_phonemes, file_names(settings.units(unit)).name));
end
data.rasters = rasters;
end