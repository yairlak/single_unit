function [settings, params] = load_settings_params(settings, params)
%% General
% settings.patient = '469';
settings.language = 'Hebrew'; % Language of phonemes presented in current run
settings.units = 0; % Set zero - choose all units.
settings.omit_no_response_phonemes = false;
settings.stimulus_onset = ' consonant onset';

%%
params.time_interval = '1:1500';
params.num_bins = 1;
% params.sliding_bin_size = 150;
params.sliding_bin_step = 1;
params.alpha_p_value = 0.01;
params.seed = 1;

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

end

