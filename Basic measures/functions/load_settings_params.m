function [settings, params] = load_settings_params(settings, params)
%% General
% settings.patient = 'D011';
settings.language = 'Hebrew'; % Language of phonemes presented in current run
settings.units = 0; % Set zero - choose all units.
settings.omit_no_response_phonemes = false;

%%
settings.optimal_bin_per_neuron = false;
settings.limit_optimal_bin_search_values = false;
if settings.limit_optimal_bin_search_values
    settings.lookin_timeWindow = 500:1500;
    settings.lookin_binSize = params.sliding_bin_size/50; % Assuming bin_sizes = 50:50:500
end
%%
params.time_interval = 0; % set to zero if you want to take optimal bins per neurons for mat files
params.time_interval = '799:998';
params.num_bins = 1;
params.seed = 1;

%% Naive Bayes
% settings.prior_type = 'phoneme frequency';
settings.prior_type = 'uniform';
settings.prior_type = 'frequency in experiment';

%% Labels (phonemes/manner/place)
% settings.labels_type = 'place of articulation'; % See below
settings.labels_type = 'phonemes'; % See below
% 'manner of articulation': conditions = {'plosives', 'fricatives', 'nasals', 'liquids'};
% 'place of articulation': conditions = {'labials', 'coronals', 'dorsals', 'glottals'};
% 'phonemes' conditions: = define later
switch settings.labels_type
    case 'place of articulation'
        settings.conditions = {'labials', 'coronals', 'dorsals', 'glottals'};
    case 'manner of articulation'
        settings.conditions = {'plosives', 'fricatives', 'nasals', 'approximants'};
end

%%
switch settings.language
    case 'English'
        settings.trial_interval = '[1:8]';
        settings.a_vowel = 'a';
    case 'Hebrew'
        settings.trial_interval = '[1:12]';
        settings.a_vowel = 'aa';
end

%% paths
if strcmp(settings.patient, 'D011') % Israeli patient    
    settings.path2data_phonemes = sprintf('../../Data/ICHILOV Data/Patient D011/%s', settings.language);
else % UCLA patients
    settings.path2data_phonemes = sprintf('../../Data/UCLA Data/Patient %s/%s', settings.patient, settings.language);
end
settings.path2mainData = fullfile('..', '..', 'Data');
settings.path2output = fullfile('..', '..', 'Output');
settings.path2figures = fullfile('..', '..', 'Figures');

%% Method
% settings.seed_split_CV = 1;
settings.CV = 0; % number of samples in test from each label.
settings.CV_folds = 5;
settings.method = 'SVM';
% SVM settings
% settings.SVM_type = 2; % see values for 's' at the bottom of this page
% settings.SVM_kernel_type = 0; % see values for 't' at the bottom of this page
% HMM settings
settings.cov_type = 'spherical';
settings.max_iter_HMM = 5;

%% phonemes
% settings.phonemes = {'aa', 'e', 'o', 'u', 'i', 'la', 'ra', 'ma', 'na', 'pa', 'ta', 'ka', 'ba', 'da', 'ga'};
% settings.labels = [1 1 1 1 1 2 2 3 3 4 4 4 4 4 4];
% settings.neurons = [1:3];
% settings.trials = '[1:4, 9:12]'; % Speakers: Aviad(1:4), Limor(1:4), Yair(1:4)
% settings.time_interval = '400:1200'; % Best that this time window is divisable without residue by settings.num_bins
% settings.num_bins = 4;  % Best that settings.time_interval is divisable without residue by num_bins

% phonemes = {'aa', 'e', 'o', 'u', 'i', 'pa', 'ta', 'ka', 'fa', 'sa', 'ba', 'da', 'ga', 'za', 'zja', 'dja', 'tsa', 'cha', 'sha', 'va', 'ma', 'na', 'ya', 'la', 'ra', 'ha', 'xa'};

%% params

end

