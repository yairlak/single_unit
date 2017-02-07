clear all; close all; clc
%%
bin_sizes = 50:50:1000;
for patient = {'All'}
    settings.patient = patient{1};
    all_results = []; all_results_h = [];
    for bin_size = bin_sizes
        fprintf('Patient %s Bin size %i\n', patient{1}, bin_size)
        params.sliding_bin_size = bin_size;
        main_onset_a_stats_classification
        all_d = [results.a_stat(:).d];
        curr_results = [zeros(1, bin_size/2), all_d, zeros(1, bin_size/2)];
        all_results = [all_results; curr_results];
    end
    times = 1:1501;
    step = 75;
               
    %% save for each unit (all bin_sizes together)
    settings_fields = {'patient'};
    params_fields = [];
    file_name = get_file_name_curr_run(settings, params, settings_fields, params_fields);
    save(fullfile('../../Output/', [file_name settings.stimulus_onset '.mat']), 'all_results')
    
end

%% Plot
figure('visible', 'off')
imagesc(all_results)
axis xy
set(gcf, 'color', [1 1 1])
xlabel('Center of bin (after stimulus onset)', 'fontsize', 14)
set(gca, 'xtick', step:step:length(times), 'xticklabel', times(step:step:length(times))- 500)
set(gca, 'ytick', 1:length(bin_sizes), 'yticklabel', bin_sizes)
ylabel('Bin size', 'fontsize', 14)
title(sprintf('Patient %s', settings.patient))
colorbar
settings_fields = {'patient', 'units'};
params_fields = [];
file_name = get_file_name_curr_run(settings, params, settings_fields, params_fields);
file_name = ['a_statistic_' settings.stimulus_onset file_name];
saveas(gcf, fullfile('..', '..', 'Figures', file_name), 'png')

%% DENDROGRAM MANOVA
settings.patient = 'All';
settings.units = 1:15;
params.sliding_bin_size = 200;
params.sliding_bin_step = 1;
settings_fields = {'patient', 'units'};
params_fields = {'sliding_bin_size', 'sliding_bin_step'};
file_name = get_file_name_curr_run(settings, params, settings_fields, params_fields);
file_name = ['a_stat_' file_name];
load(fullfile('../../Output/', [file_name '.mat']), 'settings', 'params', 'results')
% 
% manovacluster(results.a_stat(799).stats, 'complete')
% set(gca, 'xtick', 1:length(settings.phonemes), 'xticklabel', settings.phonemes)

%% Plot A-statistic for specific bin
% settings.patient = 'All';
% params = [];
% settings_fields = {'patient'};
% params_fields = [];
% file_name = get_file_name_curr_run(settings, params, settings_fields, params_fields);
% load(fullfile('../../Output/', [file_name '.mat']), 'all_results', 'all_results_h')
% t = 101:1401;
% for i = 1:length(results.a_stat)
%     p_s(i) = results.a_stat(i).p(5);
% end
% figure; plot(t, p_s)