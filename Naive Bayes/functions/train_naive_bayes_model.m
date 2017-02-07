function model = train_naive_bayes_model(train_data, settings, params)
% Train a Naive Bayes classifier on firing-rate data
% INPUT
% train_data - struct of num_units size. Each field is a condition (a
% phonemes) and each field contains num_samples*num_features matrix.
%
% OUTPUT
% model - struct with learned probabilities. Field - 
%       mean_firing_rate_matrix - num_units * num_conditions matrix. Each
%       component represents the maximum liklihood estimation of the firing
%       rate in the time window (simply, the mean across trials), assuming
%       Poisson distribution.

conditions = fieldnames(train_data);
for cnd = 1:length(conditions)
    curr_cnd = conditions{cnd};
    samples_of_all_units = [train_data.(curr_cnd)];
    mean_firing_rate_matrix(:, cnd) = nanmean(samples_of_all_units, 1);
end
model.mean_firing_rate_matrix = mean_firing_rate_matrix;

%%
model.settings = settings;
model.params = params;

end