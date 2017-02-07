function results = clean_noisy_trials(data, settings, params)
delete(fullfile(settings.path2data_phonemes, '*.mat'))
fid = fopen(sprintf('../../Output/log_cleaned_trials%s.txt', settings.stimulus_onset), 'a');
num_units = length(settings.units);
phonemes = fieldnames(data.rasters_binned);
num_phonemes = length(phonemes);
num_rows = floor(sqrt(num_phonemes));
num_cols = ceil(num_phonemes/num_rows);

for u = 1:num_units
    all_spike_counts_binned = [];
    for ph = 1:num_phonemes
        curr_ph = phonemes{ph};
        spike_counts = data.rasters(u).data.BlockSpikeTrains.(curr_ph);
%         spike_counts = spike_counts(:,[1:500 1100:1500]);
        spike_counts = sum(spike_counts,2);
        all_spike_counts_binned = [all_spike_counts_binned; mean(spike_counts) + (std(spike_counts))];
    end
    
    thresh(u) = max(all_spike_counts_binned);%mean(all_spike_counts_binned(:)) + 3 * std(all_spike_counts_binned(:));
    thresh(u) = mean(all_spike_counts_binned(:)) + 4 * std(all_spike_counts_binned(:));
    thresh(u) = 8;
end

for u = 1:num_units
    f = figure('Visible', 'off', 'color', [1 1 1]);
    omit_trials_mat = zeros(num_units, num_phonemes, 12);
    for ph = 1:num_phonemes
        curr_ph = phonemes{ph};
        subplot(num_rows, num_cols, ph)
        spike_counts = data.spike_counts_binned(u).(curr_ph);
        spike_counts_cleaned = data.rasters(u).data.BlockSpikeTrains.(curr_ph);
        plot(spike_counts', 'LineWidth', 1);
        xlabel('Time bin (50ms')
        ylabel('Spike counts (n)')
        title(curr_ph)
        
%         spike_counts = data.rasters(u).data.BlockSpikeTrains.(curr_ph);
%         spike_counts = spike_counts(:,[1:500 1100:1500]);
        passed_thresh = any(spike_counts>thresh(u),2);
        if any(passed_thresh)
            omitted_trials = find(passed_thresh);
            for tr = 1:length(omitted_trials)
                log_str = sprintf('%s, %s, %s, %s\n', settings.patient ,data.file_names{u}, curr_ph, num2str(omitted_trials(tr)));
                fprintf(log_str);
                fprintf(fid, log_str);
            end
        end
        results.noisy_trials(u).(curr_ph) = passed_thresh;
        omit_trials_mat(u,ph,:) = passed_thresh;
        spike_counts_cleaned(passed_thresh, :) = NaN;
        BlockSpikeTrains.(curr_ph) = spike_counts_cleaned;
    end
    settings_fields = {'patient'};
    params_fields = [];
    file_name = get_file_name_curr_run(settings, params, settings_fields, params_fields);
    file_name = ['noisy_trials_unit_' settings.stimulus_onset num2str(settings.units(u)) '_' file_name, '.png'];

    saveas(f, fullfile('..','..','Figures',file_name), 'png')
    save(fullfile(settings.path2data_phonemes, ['cleaned_' data.file_names{u}]), 'BlockSpikeTrains')
    
end

results.omit_trials_mat = omit_trials_mat;
results.omit_trials_mat_collapsed = sum(omit_trials_mat, 3) > 0;
fclose(fid);
end