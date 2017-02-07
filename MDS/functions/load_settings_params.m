function [settings, params] = load_settings_params(settings, params)
%% General
% settings.patient = '472';
settings.language = 'Hebrew';
settings.units = 0; % Set zero - choose all units.
settings.metric = 'euclidean';
settings.omit_no_response_phonemes = false;
settings.p_thresh = 0.05;
params.num_bins = 3;
params.seed = 1;
settings.stimulus_onset = ' consonant onset';

%%
settings.optimal_bin_per_neuron = false;
params.time_interval = '550:850'; % set to zero if you want to take optimal bins per neurons for mat files
% params.time_interval = 0;
% if params.time_interval == 0
%     params.sliding_bin_size = 150;
% end
% params.time_interval = '1:1500';

%% Naive Bayes
settings.prior_type = 'phoneme frequency';
% settings.prior_type = 'uniform';

%% What to plot
settings.generate_figures_MDS_3D = false;
settings.generate_figures_MDS = false;

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
    settings.path2data_phonemes = sprintf('../../Data/ICHILOV Data%s/Patient %s/%s', settings.stimulus_onset, settings.patient, settings.language);
else % UCLA patients
    settings.path2data_phonemes = sprintf('../../Data/UCLA Data%s/Patient %s/%s', settings.stimulus_onset, settings.patient, settings.language);
end
settings.path2mainData = fullfile('..', '..', 'Data');
settings.path2output = fullfile('..', '..', 'Output');

%% Method
% settings.seed_split_CV = 1;
settings.CV = 0; % number of samples in test from each label.
settings.CV_folds = 5;
settings.method = 'SVM';

end

