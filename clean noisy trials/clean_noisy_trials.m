function results = clean_noisy_trials(data, settings, params)
thresh = 50; % [Hz] Rate threshold for a noisy trial
num_units = length(settings.units);
phonemes = fieldnames(data.rasters_binned);
num_phonemes = length(phonemes);
num_rows = floor(sqrt(num_phonemes));
num_cols = ceil(num_phonemes/num_rows);

for u = 1:num_units
    f = figure('Visible', 'off', 'color', [1 1 1]);
    omit_trials_mat = zeros(num_units, num_phonemes, 12);
    for ph = 1:num_phonemes
        curr_ph = phonemes{ph};
        subplot(num_rows, num_cols, ph)
        firing_rates = data.spike_counts_binned(u).(curr_ph)*20;
        plot(firing_rates', 'LineWidth', 1);
        xlabel('Time bin (50ms')
        ylabel('Firing rate (Hz)')
        title(curr_ph)
        
        passed_thresh = sum(firing_rates > thresh, 2)>0;
        results.noisy_trials(u).(curr_ph) = passed_thresh;
        omit_trials_mat(u,ph,:) = passed_thresh;
    end
    settings_fields = {'patient'};
    params_fields = [];
    file_name = get_file_name_curr_run(settings, params, settings_fields, params_fields);
    file_name = ['noisy_trials_unit_' num2str(settings.units(u)) '_' file_name, '.png'];

    saveas(f, fullfile('..','..','Figures',file_name), 'png')
end

results.omit_trials_mat = omit_trials_mat;
results.omit_trials_mat_collapsed = sum(omit_trials_mat, 3) > 0;
end