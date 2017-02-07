function [data_train, data_test, data_test_design_matrix, labels_test] = split_naive_bayes_data(data, settings, params)

%%
for unit = settings.units    
    for cnd = 1:length(settings.conditions)
        % Take current samples (of unit and condition)
        curr_cnd = settings.conditions{cnd};
        samples = [];
        switch settings.labels_type 
            case 'phonemes'
                samples = [samples; data.spike_counts_binned(unit).(curr_cnd)];
            otherwise
                natural_classes = load_natural_classes(settings);
                switch settings.language
                    case 'Hebrew'
                        natural_classes.nasals = natural_classes.nasals_Heb;
                end
                phonemes = natural_classes.(curr_cnd);
                for ph = 1:length(phonemes)
                    curr_ph = phonemes{ph};
                    field_names = fieldnames(data.spike_counts_binned(unit));
                    if any(strcmp(field_names, curr_ph))
                        samples = [samples; data.spike_counts_binned(unit).(curr_ph)];
                    end
                end
            
        end
        all_samples{cnd} = samples;
        size_sample_sets(cnd) = size(samples, 1);
    end
    num_test_samples = round(min(size_sample_sets/settings.CV_folds));
    % Set indices for train/test split
    for cnd = 1:length(settings.conditions)
        curr_cnd = settings.conditions{cnd};
        samples = all_samples{cnd};
        num_samples = size_sample_sets(cnd);
        IX = randperm(num_samples);

        IX_test = IX(1:num_test_samples);
        IX_train = setdiff(IX, IX_test, 'stable');
        % Extract train/test data
        data_train(unit).(curr_cnd) = samples(IX_train,:);
        data_test(unit).(curr_cnd) = samples(IX_test,:);    
    end
end


labels_test = []; data_test_design_matrix = [];
for cnd = 1:length(settings.conditions)
    curr_cnd = settings.conditions{cnd};
    curr_samples = [data_test.(curr_cnd)];
    num_samples = size(curr_samples, 1);
    labels_test = [labels_test; cnd * ones(num_samples, 1)];
    data_test_design_matrix = [data_test_design_matrix; curr_samples];
end

end