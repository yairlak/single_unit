% clear all; close all; clc
addpath('functions')
%% Load settings and parameters
[settings, params] = load_settings_params(settings, params); rng(params.seed);

%% Load desired set of phonemes (conditions)
settings = load_phonemes(settings);

%% Load neural data
[data, settings] = load_raster_plots(settings, params);

%% Divide into bins and generate post-stimulus time histograms (PSTHs)
data = divide_into_bins(data, settings, params);

%% Split to train/test data
[data_train, data_test, data_test_design_matrix, labels_test] = split_naive_bayes_data(data, settings, params);

%% Train Naive-Bayes model
model = train_naive_bayes_model(data_train, settings, params);

%% Take phoneme priors for Bayesian inference
model = get_bayesian_priors(model, settings, params);

%% Evaluate model (accuracy, significance)
results = evaluate_naive_bayes_model(model, data_test_design_matrix, labels_test, settings, params);

%% Save model and results
settings_fields = {'patient', 'labels_type'};
params_fields = {'seed'};
file_name = get_file_name_curr_run(settings, params, settings_fields, params_fields);
file_name = ['NB_' file_name];
save(fullfile(settings.path2output, file_name), 'model', 'results')
fprintf('Saved into %s\n', fullfile(settings.path2output, file_name))