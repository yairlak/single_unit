function results = evaluate_naive_bayes_model(model, design_matrix, labels_test, settings, params)
%%
num_samples = size(design_matrix, 1);
[~, num_conditions] = size(model.mean_firing_rate_matrix);
results.correct = zeros(num_samples, 1);
confusion_matrix = zeros(max(labels_test));

%% Bayesian inference of the class(phoneme) from each sample
nan_samples = 0;
for sample = 1:num_samples 
   % Assume Poisson distribution for firing rates
   k = design_matrix(sample, :)'; % Take curr sample
   if any(isnan(k))
       results.correct(sample) = nan;
       nan_samples = nan_samples + 1;
       continue
   end
   lambdas = model.mean_firing_rate_matrix; 
   p_features_given_class = ( exp(-lambdas) .* (lambdas .^ (k * ones(1, num_conditions))))./factorial(k * ones(1, num_conditions));
   
   % Do the Bayesian flip - p(c_i|f1,f2..) = prod[p(f_j|c_i)]*p(c_i)
   % Take the log to prevent overflow.
   log_p_class_given_features = sum(log(p_features_given_class)) + log(model.priors);
   
   % Find most likely class (phoneme)
   if sum(exp(log_p_class_given_features)) ~= 0
        confusion_matrix(labels_test(sample), :) = confusion_matrix(labels_test(sample), :) + exp(log_p_class_given_features)/sum(exp(log_p_class_given_features));
   
        [~, IX] = max(log_p_class_given_features);
        if IX == labels_test(sample)
            results.correct(sample) = 1;
        end
   end
end
[number_of_labels, ~] = hist(labels_test, max(labels_test));
results.confusion_matrix = confusion_matrix./(number_of_labels'*ones(1,length(number_of_labels)));
results.accuracy = nansum(results.correct)/(num_samples-nan_samples);
results.chance_level = 1/num_conditions;
end