function data = divide_into_bins(data, settings, params)
% Divide raster into bins and generate post-stimulus time histgrams PSTHs
% INPUT:
%
% OUTPUT:
% rasters_binned - mean spike count for each bin and trial (num_trials * num_bins)
% spike_counts_binned - sum spike count for each bin and trial (num_trials * num_bins)
% PSTHs - mean across trials of raster_binned
%
%% Load optimal time bins from file
if params.time_interval == 0
    for unit = settings.units
        % look for max only in this sub window
        lookin_timeWindow = 500:1500;
        bin_sizes = 100:50:100;
        lookin_binSize = 1:1; %50:50:500;
        % Load fstat data
        settings_fields = {'patient'};
        params_fields = [];
        file_name = get_file_name_curr_run(settings, params, settings_fields, params_fields);
        if settings.optimal_bin_per_neuron
            file_name = sprintf('f_stat_%s_units=%i.mat', file_name, unit);
        end
        temp = load(fullfile('../../Output/', file_name));
        optimal_bin(unit).all_results = temp.all_results;
        optimal_bin(unit).all_results_h = temp.all_results_h;
        % Find Max
        sub_mat = optimal_bin(unit).all_results_h(lookin_binSize, lookin_timeWindow).*optimal_bin(unit).all_results(lookin_binSize, lookin_timeWindow);
        [optimal_bin(unit).max_value, optimal_bin(unit).IX_max_value] = max(sub_mat(:));
        [optimal_bin(unit).row_max_value, optimal_bin(unit).col_max_value] = ind2sub(size(sub_mat), optimal_bin(unit).IX_max_value);
        optimal_bin(unit).optimal_bin_size = bin_sizes(optimal_bin(unit).row_max_value);
        optimal_bin(unit).optimal_time_center = optimal_bin(unit).col_max_value + min(lookin_timeWindow);
        optimal_bin(unit).start_time = round(optimal_bin(unit).optimal_time_center - optimal_bin(unit).optimal_bin_size/2);
        optimal_bin(unit).end_time = round(optimal_bin(unit).optimal_time_center + optimal_bin(unit).optimal_bin_size/2)-1;
    end     
    data.optimal_bin = optimal_bin;
end

%%
rasters = data.rasters;
for p = 1:length(settings.phonemes)
    ph = settings.phonemes{p};
    for unit = settings.units
        time_interval = params.time_interval;
        if params.time_interval == 0
            time_interval = sprintf('[%i:%i]', optimal_bin(unit).start_time, optimal_bin(unit).end_time);
        end
        num_miliseconds = eval(sprintf('length(%s)', time_interval));
        curr_raster = eval(sprintf('rasters(%i).data.BlockSpikeTrains.%s(%s, %s)', unit, ph, settings.trial_interval, time_interval));     
        %% divide into bins
        size_raster = size(curr_raster, 1);
        bin_length = floor(num_miliseconds/params.num_bins);
        raster_binned = zeros(size_raster, params.num_bins);
        for bin = 1:params.num_bins
           st = 1 + (bin-1)*bin_length;
           ed = bin*bin_length;
           counts_binned(:, bin) = sum(curr_raster(:,st:ed), 2);
           raster_binned(:, bin) = mean(curr_raster(:,st:ed), 2);
        end
        data.spike_counts_binned(unit).(ph) = counts_binned;
        data.rasters_binned(unit).(ph) = raster_binned;
        data.PSTHs(unit).(ph) = mean(raster_binned);
    end
end

for i = 1:length(data.spike_counts_binned)
    ph_names = fieldnames(data.spike_counts_binned(i));
    all_trial_counts = [];
    for ph = ph_names'
        all_trial_counts = [all_trial_counts; data.spike_counts_binned(i).(ph{1})];
    end
    data.spike_count_binned_mean_all_phonemes(i) = mean(all_trial_counts);
    data.spike_count_binned_std_all_phonemes(i) = std(all_trial_counts);
end

for i = 1:length(data.spike_counts_binned)
    ph_names = fieldnames(data.spike_counts_binned(i));
    for ph = ph_names'
        data.spike_counts_binned_z_scored(i).(ph{1}) = (data.spike_counts_binned(i).(ph{1})-data.spike_count_binned_mean_all_phonemes(i))/data.spike_count_binned_std_all_phonemes(i);
        data.PSTH_counts_binned_z_scored(i).(ph{1})= mean(data.spike_counts_binned_z_scored(i).(ph{1}));
    end
end
end