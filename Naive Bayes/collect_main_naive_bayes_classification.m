clear all; close all; clc

patients = {'D011', '466', '469', '472'};
patients = {'All'};
for patient = patients
    settings.patient = patient{1};
%      labels_types = {'place of articulation', 'manner of articulation'};
     labels_types = {'manner of articulation and vowels'};
%     labels_types = {'labial', 'coronal', 'dorsal','guttural', 'fricative', 'plosive', 'affricate', 'nasal', 'approximant', 'voicing'};
    for lt = 1:length(labels_types)
        labels_type = labels_types{lt};
%         for labels_type = {'phonemes'}
        settings.labels_type = labels_type;
        %%
        [settings, params] = load_settings_params(settings);
        file_names = dir(fullfile(settings.path2data_phonemes, '*.mat'));
        num_potential_units = length(file_names);
        if settings.units == 0
            settings.units = 1:num_potential_units;
        end
        settings = load_phonemes(settings);

        start_bins = 550;
        bin_lengths = 300;

        for i = 1:length(start_bins)
            start_bin = start_bins(i);
            for j = 1:length(bin_lengths)
                bin_length = bin_lengths(j);
                end_bin = start_bin + bin_length;
                %         settings = [];
                params.time_interval = sprintf('%i:%i', start_bin, end_bin);

                for seed = 1:50
                    fprintf('%i %i %i\n',i,j,seed)
                    params.seed = seed;
                    settings_fields = {'patient', 'labels_type'};
                    params_fields = {'seed'};
                    file_name = get_file_name_curr_run(settings, params, settings_fields, params_fields);
                    file_name = ['NB_' file_name];

                    load(fullfile(settings.path2output, file_name), 'results')
                    acc(i,j,seed) = results.accuracy;
                    confusion_matrix(:,:,i,j,seed) = results.confusion_matrix;
                    chance_level = results.chance_level;
                    clear 'results'
                end
            end
        end

        %%
        % IX_perm.manner = [1, 3, 6, 12, 16, 8, 5, 18, 15, 21, 14, 7, 19, 4, 2, 22, 17, 10, 11, 13, 9, 20];
        % IX_perm.manner = intersect(IX_perm.manner, settings.phonemes_serial_number, 'stable');
        if strcmp(settings.labels_type, 'phonemes')
            settings_fields = {'patient'};
            params_fields = [];
            file_name = get_file_name_curr_run(settings, params, settings_fields, params_fields);
            file_name = ['outperm_' file_name];
            load(fullfile('../../Output', file_name), 'outperm')
        end

        %%
        figure('visible', 'off'); set(gcf, 'color', [1 1 1])
        mat = squeeze(mean(confusion_matrix,5));
        for i = 1:size(confusion_matrix, 1)
            for j = 1:size(confusion_matrix, 2)
                curr_x = confusion_matrix(i,j,1,1,:);
                [h_mat(i,j), p_mat(i,j)] = ttest(curr_x-chance_level);
            end
        end
%         above_chance = mat > chance_level;
%         above_chance = above_chance .* h_mat;

        % mat = mat(IX_perm.manner, IX_perm.manner);
        if strcmp(settings.labels_type, 'phonemes')
            mat = mat(outperm, outperm);
            settings.conditions = settings.conditions(outperm);
        end
        imagesc(mat)
        axis xy
        set(gca, 'ytick', 1:length(settings.conditions), 'yticklabel', settings.conditions)
        set(gca, 'xtick', 1:length(settings.conditions), 'xticklabel', settings.conditions)
        xlabel('Condition', 'fontsize', 14)
        ylabel('Condition', 'fontsize', 14)
        title(sprintf('%s %s', settings.patient, settings.labels_type))
        colorbar
        caxis([0 0.5])

        settings_fields = {'patient', 'labels_type'};
        params_fields = [];
        file_name = get_file_name_curr_run(settings, params, settings_fields, params_fields);
        file_name = ['Confusion_matrix_', file_name];

        saveas(gcf, fullfile(settings.path2figures, file_name), 'png')
        
        %%
%         accur.(labels_type) = squeeze(acc);
%         accuracy(lt) = mean(accur.(labels_type));
%         std_accuracy(lt) = std(accur.(labels_type))/sqrt(length(accur.(labels_type)));
%         [h_test(lt), p_test(lt)] = ttest(accur.(labels_type) - 0.5);
    end
    
%     [~, IX] = sort(accuracy, 'descend');
%     figure('color', [1 1 1]);
%     h = barweb(accuracy(IX)', std_accuracy(IX)',[],labels_types(IX)');
%     rotateXLabels1(gca, 20)
%     ylabel('Classification accuracy')
%     ylim([0.5 0.7])
%     h_bars = get(gca, 'Children');
%     set(h.bars, 'facecolor', 'r');
end

%%
% figure
% imagesc(mean(acc, 3))
% title(sprintf('Naive Bayes classification %s %s', settings.patient, settings.prior_type),'fontsize',14)
% set(gca, 'ytick', 1:length(start_bins), 'yticklabel', num2cell(start_bins))
% set(gca, 'xtick', 1:length(bin_lengths), 'xticklabel', num2cell(bin_lengths))
% xlabel('Bin length', 'fontsize', 14)
% ylabel('Bin start', 'fontsize', 14)
% save(sprintf('NB acc %s %s', settings.patient, settings.prior_type),'acc')

%%
% for seed = 1:10
%     params.seed = seed;
%     file_name = get_file_name_curr_run(settings, params);
%     load(fullfile(settings.path2output, file_name), 'results')
%     acc(seed) = results.accuracy;
%     chance_level = results.chance_level;
%     clear 'results'
% end

%%
% mean(acc)
% chance_level
% std(acc)
% %%
% % D011 uniform
% acc_all(1, 1) = 0.0795;
% % D011 freq
% acc_all(1, 2) = 0.0409;
% % 466 uniform
% acc_all(2, 1) = 0.0773;
% % 466 freq
% acc_all(2, 2) = 0.0841;
% 
% %%
% figure;set(gcf, 'color', [1 1 1])
% barweb(acc_all, zeros(2), [], {'Patient D011', 'Patient 466'})
% legend({'Uniform priors', 'Phoneme-frequency priors'}, 'location', 'NorthEastOutside')
% line([0,4], [chance_level, chance_level], 'LineStyle', '--', 'color', 'k')