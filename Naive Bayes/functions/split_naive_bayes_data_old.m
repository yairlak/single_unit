function [data_train, data_test, data_test_design_matrix, labels_test] = split_naive_bayes_data(data, settings, params)

for unit = settings.units
    conditions = fieldnames(data.spike_counts_binned);
    for cnd = 1:length(conditions)
        % Take current samples (of unit and condition)
        curr_cnd = conditions{cnd};
        samples = data.spike_counts_binned(unit).(curr_cnd);
        % Set indices for train/test splitting
        num_samples = size(samples, 1);
        IX = randperm(num_samples);
        num_test_samples = round(num_samples/settings.CV_folds);
        IX_test = IX(1:num_test_samples);
        IX_train = setdiff(IX, IX_test, 'stable');
        % Extract train/test data
        data_train(unit).(curr_cnd) = samples(IX_train,:);
        data_test(unit).(curr_cnd) = samples(IX_test,:);
    end
end

labels_test = []; data_test_design_matrix = [];
for cnd = 1:length(conditions)
    curr_cnd = conditions{cnd};
    curr_samples = [data_test.(curr_cnd)];
    num_samples = size(curr_samples, 1);
    labels_test = [labels_test; cnd * ones(num_samples, 1)];
    data_test_design_matrix = [data_test_design_matrix; curr_samples];
end

end