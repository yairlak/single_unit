function generate_figures(data, settings, params)
num_units = length(data.rasters_binned);

% Per phoneme
for unit = 1:num_units
    if params.time_interval == 0
        legend_str{unit} = sprintf('Unit #%i\nBin (%i:%ims)', unit, data.optimal_bin(unit).start_time-500, data.optimal_bin(unit).end_time-500);
    else
        legend_str{unit} = sprintf('Unit #%i\nBin (%sms)', unit, settings.trial_interval);
    end
    curr_phonemes = fieldnames(data.spike_counts_binned(unit));
    num_phonemes = length(curr_phonemes);
    
    for ph = 1:num_phonemes
        curr_class = curr_phonemes{ph};
        mean_spike_counts(ph, unit) = nanmean(data.spike_counts_binned(unit).(curr_class));
        std_spike_counts(ph, unit) = nanstd(data.spike_counts_binned(unit).(curr_class));
    end
    
end
h = figure('visible','off');
set(h, 'color', [1 1 1])
barweb(mean_spike_counts, std_spike_counts,1.5,curr_phonemes);
title(sprintf('Patient %s, bin-size %i', settings.patient, params.sliding_bin_size))
legend(legend_str, 'location', 'NorthEastOutside', 'fontsize', 12)
ylabel('Spike count', 'fontsize', 14)
ylim([0 max(max(mean_spike_counts))+max(max(mean_spike_counts))])
set(h, 'units','normalized','outerposition',[0 0 1 1])
set(h, 'PaperPositionMode','auto') 

% Save
settings_fields = {'patient', 'units'};
params_fields = {'sliding_bin_size'};
file_name = get_file_name_curr_run(settings, params, settings_fields, params_fields);
file_name = ['mean_std_spike_count_' file_name];
saveas(gcf, fullfile(settings.path2figures, [file_name '.png']), 'png')

%% Per (phoneme) class
mean_spike_counts = []; std_spike_counts = [];
for unit = 1:num_units
    if params.time_interval == 0
        legend_str{unit} = sprintf('Unit #%i\nBin (%i:%ims)', unit, data.optimal_bin(unit).start_time-500, data.optimal_bin(unit).end_time-500);
    else
        legend_str{unit} = sprintf('Unit #%i\nBin (%sms)', unit, settings.trial_interval);
    end
    
    
    classes = {'plosives', 'fricatives', 'nasals_Heb', 'approximants'};
    for class = 1:length(classes)
        curr_class = classes{class};
        mean_spike_counts(class, unit) = nanmean(data.spike_counts_binned_per_class(unit).(curr_class));
        std_spike_counts(class, unit) = nanstd(data.spike_counts_binned_per_class(unit).(curr_class));
        sem_spike_counts(class, unit) = nanstd(data.spike_counts_binned_per_class(unit).(curr_class))/sum(~isnan(data.spike_counts_binned_per_class(unit).(curr_class)));
    end
    
end
h = figure('visible','off');
set(h, 'color', [1 1 1])
barweb(mean_spike_counts, sem_spike_counts,1,classes);
title(sprintf('Patient %s, bin-size %i', settings.patient, params.sliding_bin_size))
legend(legend_str, 'location', 'NorthEastOutside', 'fontsize', 12)
ylabel('Spike count', 'fontsize', 14)
% ylim([0 max(max(mean_spike_counts))+max(max(mean_spike_counts))])
set(h, 'units','normalized','outerposition',[0 0 1 1])
set(h, 'PaperPositionMode','auto') 

%% Save
settings_fields = {'patient', 'units'};
params_fields = {'sliding_bin_size'};
file_name = get_file_name_curr_run(settings, params, settings_fields, params_fields);
file_name = ['mean_std_spike_count_per_class_' file_name];
saveas(gcf, fullfile(settings.path2figures, [file_name '.png']), 'png')


end