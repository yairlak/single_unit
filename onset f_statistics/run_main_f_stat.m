clear all; close all; clc
%%
bin_sizes = 100:50:100;
% for patient = {'D011', '466', '469', '472'}
for patient = {'All'}
% for patient = {'472'}
    settings.patient = patient{1};
    switch patient{1}
        case 'D011'
            units = 1:3;
        case '466'
            units = 1:5;
        case '472'
            units = 1:6;
        case '469'
            units = 1:3;
        case 'All'
            units = 1:13;
    end
        
    settings.units = units;
    for unit = units
        close all
        settings.units = unit;
        try
            all_results = []; all_results_h = [];
            for bin_size = bin_sizes
                fprintf('Unit %i(%i), Patient %s Bin size %i\n', unit, length(units), patient{1}, bin_size)
%                 settings = [];
                params.sliding_bin_size = bin_size;
                main_onset_f_stats_classification
                curr_results = [zeros(1, bin_size/2), results.f_stat_sliding, zeros(1, bin_size/2)];
                curr_results_h = [zeros(1, bin_size/2), results.h_sliding, zeros(1, bin_size/2)];
                all_results = [all_results; curr_results];
                all_results_h = [all_results_h; curr_results_h];
            end
        catch
            fprintf('error in patient %s, unit %i\n', patient{1}, unit)
            continue
        end
        times = 1:1501;
        step = 75;
        
        %% Plot
        
        % imagesc(all_results(1:length(bin_sizes), times))
        figure('visible', 'off')
        imagesc(all_results)
        set(gcf, 'color', [1 1 1])
        xlabel('Center of bin (after stimulus onset)', 'fontsize', 14)
        set(gca, 'xtick', step:step:length(times), 'xticklabel', times(step:step:length(times))- 500)
        set(gca, 'ytick', 1:length(bin_sizes), 'yticklabel', bin_sizes)
        ylabel('Bin size', 'fontsize', 14)
        title(sprintf('Patient %s unit %i', settings.patient, settings.units))
        colorbar
        settings_fields = {'patient', 'units'};
        params_fields = [];
        file_name = get_file_name_curr_run(settings, params, settings_fields, params_fields);
        file_name = ['f_stat_' file_name];
        saveas(gcf, fullfile('..', '..', 'Figures', file_name), 'png')
        
        figure('visible', 'off')
        imagesc(all_results.*all_results_h)
        set(gcf, 'color', [1 1 1])
        xlabel('Center of bin (after stimulus onset)', 'fontsize', 14)
        set(gca, 'xtick', step:step:length(times), 'xticklabel', times(step:step:length(times))- 500)
        set(gca, 'ytick', 1:length(bin_sizes), 'yticklabel', bin_sizes)
        ylabel('Bin size', 'fontsize', 14)
        title(sprintf('Patient %s unit %i', settings.patient, settings.units))
        colorbar
        file_name = ['h_' file_name];
        saveas(gcf, fullfile('..', '..', 'Figures', file_name), 'png')
        
        %% save for each unit (all bin_sizes together)
        if units == 0
            settings_fields = {'patient'};
            params_fields = [];
            file_name = get_file_name_curr_run(settings, params, settings_fields, params_fields);
            save(fullfile('../../Output/', [file_name '.mat']), 'all_results', 'all_results_h')
        else
            settings_fields = {'patient', 'units'};
            params_fields = [];
            file_name = get_file_name_curr_run(settings, params, settings_fields, params_fields);
            file_name = ['f_stat_' file_name];
            save(fullfile('../../Output/', [file_name '.mat']), 'all_results', 'all_results_h')
        end
    end
    
end
