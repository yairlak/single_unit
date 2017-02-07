clear all; close all; clc

%%
% start_bins = 300:50:900;
% bin_lengths = [50, 100, 200];
start_bins = 550;
bin_lengths = 300;

patients = {'D011', '466', '469', '472'};
patients = {'All'};
for patient = patients
    settings.patient = patient{1};
%     for labels_type = {'place of articulation', 'manner of articulation'}
    for labels_type = {'manner of articulation and vowels'}
        
%     for labels_type = {'sonorants_obstruents'}
%     for labels_type = {'labial', 'coronal', 'dorsal','guttural', 'fricative', 'plosive', 'affricate', 'nasal', 'approximant', 'voicing'}
%         for labels_type = {'phonemes'}
        settings.labels_type = labels_type{1};
        
        for i = 1:length(start_bins)
            start_bin = start_bins(i);
            for j = 1:length(bin_lengths)
                bin_length = bin_lengths(j);
                end_bin = start_bin + bin_length;
        %         settings = [];
                params.time_interval = sprintf('%i:%i', start_bin, end_bin);
%                 params.time_interval = 0;
                for seed = 1:50
                    params.seed = seed;
                    main_naive_bayes_classification
                end

            end
        end
    end
end