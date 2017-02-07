clear all; close all; clc

%%
[settings, params] = load_settings_params();
file_names = dir(fullfile(settings.path2data_phonemes, '*.mat'));
num_potential_units = length(file_names);
if settings.units == 0
    settings.units = 1:num_potential_units;
end
settings = load_phonemes(settings);

%%
p_cnt = 0;
patients = {'D011', '466', '469', '472'};
patients = {'All'};
for patient = patients
    settings.patient = patient{1};
    p_cnt = p_cnt + 1;
    l_cnt = 0;
    for labels_type = {'Place of articulation', 'Manner of articulation'}
        settings.labels_type = labels_type{1};
        l_cnt = l_cnt + 1;
        for seed = 1:50
            fprintf('Seed %i\n',seed)
            params.seed = seed;
            settings_fields = {'patient', 'labels_type'};
            params_fields = {'seed'};
            file_name = get_file_name_curr_run(settings, params, settings_fields, params_fields);
            file_name = ['NB_' file_name];

            load(fullfile(settings.path2output, file_name), 'results')
            acc(seed) = results.accuracy;
            confusion_matrix(:,:,seed) = results.confusion_matrix;
            chance_level = results.chance_level;
            clear 'results'
        end
        acc_mean(p_cnt, l_cnt) = mean(acc);
        err_mean(p_cnt, l_cnt) = std(acc);
        if l_cnt == 1
            acc_old = acc;
        end
    end
    [ttest_values(p_cnt,1), ttest_values(p_cnt,2)] = ttest(acc, acc_old);
    acc_old = [];
end

figure; set(gcf, 'color', [1 1 1])
barweb(acc_mean, err_mean,[], patients)
ylabel('Accuracy (%)', 'fontsize', 14)
legend({'place', 'Manner'}, 'fontsize', 14)
saveas(gcf, '../../Figures/compare_manner_place.png', 'png')