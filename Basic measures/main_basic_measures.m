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

%% Plot and save
generate_figures(data, settings, params)

