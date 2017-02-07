function data = divide_into_bins(data, settings, params)
% Divide raster into bins and generate post-stimulus time histgrams PSTHs
% INPUT:
%
% OUTPUT:
% rasters_binned - mean spike count for each bin and trial (num_trials * num_bins)
% spike_counts_binned - sum spike count for each bin and trial (num_trials * num_bins)
% PSTHs - mean across trials of raster_binned
%

%%
natural_classes = load_natural_classes(settings);

%% Load optimal time bins from file
if params.time_interval == 0
    for unit = settings.units
        % look for max only in this sub window
        bin_sizes = 50:50:500;
        if settings.limit_optimal_bin_search_values
            lookin_timeWindow = settings.lookin_timeWindow;
            lookin_binSize = settings.lookin_binSize;
        else
            lookin_timeWindow = 1:1500;
            lookin_binSize = 1:length(bin_sizes); %50:50:500;
        end
        
        % Load fstat data
        settings_fields = {'patient'};
        params_fields = [];
        file_name = get_file_name_curr_run(settings, params, settings_fields, params_fields);
        if settings.optimal_bin_per_neuron
            file_name = sprintf('%s_units=%i.mat', file_name, unit);
        end
        
        temp = load(fullfile('../../Output/', file_name));
        optimal_bin(unit).all_results = temp.all_results;
        optimal_bin(unit).all_results_h = temp.all_results_h;
        % Find Max
        sub_mat = optimal_bin(unit).all_results(lookin_binSize, lookin_timeWindow).*optimal_bin(unit).all_results(lookin_binSize, lookin_timeWindow);
        [optimal_bin(unit).max_value, optimal_bin(unit).IX_max_value] = max(sub_mat(:));
        [optimal_bin(unit).row_max_value, optimal_bin(unit).col_max_value] = ind2sub(size(sub_mat), optimal_bin(unit).IX_max_value);
        optimal_bin(unit).row_max_value = lookin_binSize(optimal_bin(unit).row_max_value);
        optimal_bin(unit).col_max_value = lookin_timeWindow(optimal_bin(unit).col_max_value);
        optimal_bin(unit).optimal_bin_size = bin_sizes(optimal_bin(unit).row_max_value);
        optimal_bin(unit).optimal_time_center = optimal_bin(unit).col_max_value;
        optimal_bin(unit).start_time = round(optimal_bin(unit).optimal_time_center - optimal_bin(unit).optimal_bin_size/2);
        optimal_bin(unit).end_time = round(optimal_bin(unit).optimal_time_center + optimal_bin(unit).optimal_bin_size/2)-1;
    end     
    data.optimal_bin = optimal_bin;
end

%%
for unit = settings.units
    %% Initialization
    for class = {'plosives', 'fricatives', 'nasals_Heb', 'approximants'}
        data.spike_counts_binned_per_class(unit).(class{1}) = [];
    end
end
rasters = data.rasters;
% num_miliseconds = eval(sprintf('length(%s)', params.time_interval));
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
           counts_binned(:, bin) = nansum(curr_raster(:,st:ed), 2);
           raster_binned(:, bin) = nanmean(curr_raster(:,st:ed), 2);
        end
        data.spike_counts_binned(unit).(ph) = counts_binned;
        data.rasters_binned(unit).(ph) = raster_binned;
        data.PSTHs(unit).(ph) = nanmean(raster_binned);
        
        %% Plosives/fricatives/nasals/approximants
        for class = {'plosives', 'fricatives', 'nasals_Heb', 'approximants'}
            if any(strcmp(ph,natural_classes.(class{1})))
                data.spike_counts_binned_per_class(unit).(class{1}) = [data.spike_counts_binned_per_class(unit).(class{1}); data.spike_counts_binned(unit).(ph)];
            end
        end
        
    end
%     for class = {'plosives', 'fricatives', 'nasals', 'approximants'}      
%         data.spike_counts_binned_per_class = mean();
%     end
end

end