function [settings, params] = load_settings_params(settings, params)
%% General
% settings.patient = 'D011';
settings.language = 'Hebrew'; % Language of phonemes presented in current run
settings.units = 0; % Set zero - choose all units.
settings.omit_no_response_phonemes = false;
settings.optimal_bin_per_neuron = false;

% params.time_interval = 0; % set to zero if you want to take optimal bins per neurons for mat files
% params.time_interval = '799:998';
params.num_bins = 3;
% params.seed = 1;

%% Naive Bayes
% settings.prior_type = 'phoneme frequency';
% settings.prior_type = 'uniform';
settings.prior_type = 'frequency in experiment';

%% Labels (phonemes/manner/place)
% settings.labels_type = 'place of articulation'; % See below
% settings.labels_type = 'phonemes'; % See below
% 'manner of articulation': conditions = {'plosives', 'fricatives', 'nasals', 'liquids'};
% 'place of articulation': conditions = {'labials', 'coronals', 'dorsals', 'glottals'};
% 'phonemes' conditions: = define later
switch settings.labels_type
    case 'place of articulation'
        settings.conditions = {'labials', 'coronals', 'dorsals', 'gutturals'};
    case 'manner of articulation'
        settings.conditions = {'plosives', 'fricatives', 'nasals', 'approximants_Heb'};
    case 'manner of articulation and vowels'
        settings.conditions = {'plosives', 'fricatives', 'nasals', 'approximants_Heb', 'vowels'};
    case 'sonorants_obstruents'
        settings.conditions = {'sonorants', 'obstruents'};
    case 'labial'
        settings.conditions = {'labials', 'non_labials'};
    case 'coronal'
        settings.conditions = {'coronals', 'non_coronals'};
    case 'dorsal'
        settings.conditions = {'dorsals', 'non_dorsals'};
    case 'guttural'
        settings.conditions = {'gutturals', 'non_gutturals'};
        
    case 'plosive'
        settings.conditions = {'plosives', 'non_plosives'};
    case 'fricative'
        settings.conditions = {'fricatives', 'non_fricatives'};
    case 'affricate'
        settings.conditions = {'affricates', 'non_affricates'};
    case 'nasal'
        settings.conditions = {'nasals_Heb', 'non_nasals'};
    case 'approximant'
        settings.conditions = {'approximants_Heb', 'non_approximants'};
               
    case 'voicing'
        settings.conditions = {'voiced', 'unvoiced'};
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

end

