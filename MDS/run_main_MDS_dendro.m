clear all; close all; clc

%%
patients = {'All'};
% patients = {'D011', '469', '472','All'};
% patients = {'All'};
for patient = 1:length(patients)
    settings.patient = patients{patient};
    main_MDS_dendro
    fprintf('Figures generated for patient %s\n', patients{patient})
%     firing_rates.(['patient_' patients{patient}]) = data.spike_count_binned_mean_all_phonemes/1.5;
%     save('../../Output/firing_rates.mat', 'firing_rates')
end