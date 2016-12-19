clear all; close all; clc
%%
for patient = {'D011', '466', '469', '472'}
    settings.patient = patient{1}; 
    params = [];
    main_clean_noise
    fprintf('%s: %i trials omitted\n', patient{1}, sum(sum(results.omit_trials_mat_collapsed)))
end
