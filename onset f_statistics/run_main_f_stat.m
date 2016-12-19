clear all; close all; clc
%%
params.sliding_bin_size = 150;

%%
for patient = {'D011', '466', '469', '472', 'All'}
% for patient = {'All'}
    f = figure('visible', 'off', 'color', [1 1 1]);
    settings.patient = patient{1};
    [settings, params] = load_settings_params(settings, params);
    file_names = dir(fullfile(settings.path2data_phonemes, '*.mat'));
    all_results = [];
    units = 1:length(file_names);
    for unit = units
        fprintf('Unit %i(%i), Patient %s \n', unit, length(units), patient{1})
        settings.units = unit;
        main_onset_f_stats_classification
        curr_results = results.f_stat_sliding.*results.h_sliding;
        curr_results(curr_results==0) = NaN;
        hold on; plot(results.time_onsets, curr_results, 'color', [(unit-1)/length(units), 1 - (unit-1)/length(units), 0], 'linewidth', 2)
        all_results = [all_results; curr_results];
        
        % save for each unit (all bin_sizes together)
        if units == 0
            settings_fields = {'patient'};
            params_fields = {'sliding_bin_size'};
            file_name = get_file_name_curr_run(settings, params, settings_fields, params_fields);
            save(fullfile('../../Output/', [file_name '.mat']), 'all_results')
        else
            settings_fields = {'patient', 'units'};
            params_fields = {'sliding_bin_size'};
            file_name = get_file_name_curr_run(settings, params, settings_fields, params_fields);
            file_name = ['f_stat_' file_name];
            save(fullfile('../../Output/', [file_name '.mat']), 'curr_results')
        end
        legend_str{unit}= ['Unit ' num2str(unit)];
    end
    
        
    %% Plot
    hold on; plot(results.time_onsets, mean(all_results), 'linewidth', 3, 'color', 'k')
    legend_str{end+1} = 'NaN-mean';
    legend(legend_str)
    legend_str = [];
    times = 1:1501;
    step = 100;   
    xlabel('Center of bin (after stimulus onset)', 'fontsize', 14)
    set(gca, 'xtick', step:step:length(times), 'xticklabel', times(step:step:length(times))- 500)
    ylabel('F-statistics', 'fontsize', 14)
    title(sprintf('Patient %s, Bin size %i',patient{1},params.sliding_bin_size), 'fontsize', 14)
    settings_fields = {'patient', 'units'};
    params_fields = {'sliding_bin_size'};
    file_name = get_file_name_curr_run(settings, params, settings_fields, params_fields);
    file_name = ['f_stat_' file_name];
    saveas(gcf, fullfile('..', '..', 'Figures', file_name), 'png')
        
end
