clear all; close all; clc

%%
% for patient = {'All'}
for patient = {'D011', '466', '469', '472', 'All'}
    for bin_size = [200];
        params.sliding_bin_size = bin_size;
        settings.units = 0;
        settings.patient = patient{1};
        main_basic_measures
        fprintf('Figures generated for patient %s bin-size %i\n', patient{1}, bin_size)
    end
end