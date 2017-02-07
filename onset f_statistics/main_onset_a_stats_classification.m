% clear all; close all; clc
addpath('functions')
%% Load settings and parameters
[settings, params] = load_settings_params(settings, params);
rng(params.seed);

%% Load desired set of phonemes (conditions)
settings = load_phonemes(settings);

%% Load neural data
[data, settings] = load_raster_plots(settings, params);

%% Divide into bins and generate post-stimulus time histograms (PSTHs)
data = divide_into_bins(data, settings, params);

%% Calculate f statistics
results = calc_a_stat(data, settings, params);

%% Save all
settings_fields = {'patient', 'units'};
params_fields = {'sliding_bin_size', 'sliding_bin_step'};
file_name = get_file_name_curr_run(settings, params, settings_fields, params_fields);
file_name = ['a_stat_' settings.stimulus_onset file_name];
save(fullfile('../../Output/', [file_name '.mat']), 'settings', 'params', 'results')