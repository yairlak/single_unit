function results = generate_MDS_dendrograms(data, settings, params)
settings_fields = {'patient'};
params_fields = [];
file_name = get_file_name_curr_run(settings, params, settings_fields, params_fields);

%%
ph_counter = 1;
for p = 1:length(settings.phonemes)
    ph = settings.phonemes{p};    
%     mat_phonemes(ph_counter, :) = [data.PSTHs.(ph)];
    mat_phonemes(ph_counter, :) = [data.PSTH_counts_binned_z_scored.(ph)];
    ph_counter = ph_counter + 1;
end

%% PCA
[coeff, score, latent] = pca(mat_phonemes);
PC1 = coeff(:, 1);
PC2 = coeff(:, 2);
PC3 = coeff(:, 3);

mat_projection = mat_phonemes * [PC1, PC2, PC3];
% fig_pca = figure('visible', 'off');
fig_pca = figure();
% scatter(mat_projection(:, 1), mat_projection(:, 2), 1e-2)
scatter3(mat_projection(:, 1), mat_projection(:, 2), mat_projection(:, 3), 1e-2)
natural_classes = load_natural_classes(settings);
curr_nat_classes = {'sonorants', 'obstruents'};
class_colors = {[0 1 0], [0 0 1]};
for nat_class = 1:length(curr_nat_classes)
    curr_class = natural_classes.(curr_nat_classes{nat_class});
    IX = ismember(settings.phonemes', curr_class);
%     text(mat_projection(IX, 1), mat_projection(IX, 2), settings.phonemes(IX), 'fontsize', 16, 'color', class_colors{nat_class})
    text(mat_projection(IX, 1), mat_projection(IX, 2), mat_projection(IX, 3), settings.phonemes(IX), 'fontsize', 16, 'color', class_colors{nat_class})
end
% text(mat_projection(:, 1), mat_projection(:, 2), settings.phonemes, 'fontsize', 16)

set(fig_pca, 'Color', [1 1 1])
% axis off
title('PCA')
fig_file_name = ['PCA_', settings.stimulus_onset, file_name, '.png'];
saveas(fig_pca, fullfile('..', '..', 'Figures', fig_file_name), 'png')

%% Distance mat, MDS
D = pdist(mat_phonemes, settings.metric);
S = exp(-squareform(D));
S(1:length(S)+1:end) = nan;

% Dendrogram
% fig_tree = figure('visible', 'off');
fig_tree = figure;
tree = linkage(D, 'complete');
[H, T, outperm] = dendrogram(tree, 'Orientation','left');

file_name = ['outperm_' file_name];
save(fullfile('../../Output', file_name), 'outperm')

set(gca, 'yticklabel', settings.phonemes(outperm))
set(gcf, 'Color', [1 1 1])
set(gca, 'xtick', [])
% ylabel('Relative Distance', 'fontsize', 13)
fig_file_name = ['Dendro_', settings.stimulus_onset, file_name, '.png'];
saveas(fig_tree, fullfile('..', '..', 'Figures', fig_file_name), 'png')

h_sim = figure('color', [1 1 1],'visible', 'off'); 
imagesc(S(outperm,outperm))
title('Neural activity', 'fontsize', 14)
axis xy
set(gca, 'xtick', 1:length(settings.phonemes(outperm)))
set(gca, 'xticklabel', settings.phonemes(outperm))
set(gca, 'ytick', 1:length(settings.phonemes(outperm)))
set(gca, 'yticklabel', settings.phonemes(outperm))
colorbar
saveas(h_sim, '../../Figures/similarity_mat.png', 'png')

%% MDS
% settings.generate_figures_MDS = true;
if settings.generate_figures_MDS
    Y1 = mdscale(D,2);
    fig_mds = figure('visible', 'on');
    scatter(Y1(:, 1), Y1(:, 2), 1e-2)
    text(Y1(:, 1), Y1(:, 2), settings.phonemes, 'fontsize', 16)
    set(fig_mds, 'Color', [1 1 1])
    axis off
    axis equal
    Y1 = mdscale(D,3);

    fig_file_name = ['MDS_', settings.stimulus_onset, file_name, settings.stimulus_onset, '.png'];
    saveas(fig_mds, fullfile('..', '..', 'Figures', fig_file_name), 'png')
end

%% MDS 3D
if settings.generate_figures_MDS_3D
    fig_mds3D = figure('visible', 'off');
    scatter3(Y1(:, 1), Y1(:, 2), Y1(:, 3), 1e-2)
    text(Y1(:, 1), Y1(:, 2), Y1(:, 3), settings.phonemes, 'fontsize', 16)
    set(fig_mds3D, 'Color', [1 1 1])

    title('MDS')
    fig_file_name = ['MDS3D_', file_name, settings.stimulus_onset, '.png'];
    saveas(fig_mds3D, fullfile('..', '..', 'Figures', fig_file_name), 'png')
end

%% Compare to behavioral
compare_to_behavioral = true;
if compare_to_behavioral
    load('../../Data/ExpHebWhite.mat');

    for ph = 1:length(settings.phonemes)
        ph_name = settings.phonemes{ph};
        lookup_name = [];
        switch ph_name
            case 'ba'
                lookup_name = 'b';                
            case 'cha'
                lookup_name = 'C';                
            case 'da'
                lookup_name = 'd';                
            case 'dja'
                lookup_name = 'J';                
            case 'fa'
                lookup_name = 'f';
            case 'ga'
                lookup_name = 'g';
            case 'ha'
                lookup_name = 'h';
            case 'ka'
                lookup_name = 'k';
            case 'la'
                lookup_name = 'l';
            case 'ma'
                lookup_name = 'm';
            case 'na'
                lookup_name = 'n';
            case 'pa'
                lookup_name = 'p';
            case 'ra'
                lookup_name = 'R';
            case 'sa'
                lookup_name = 's';
            case 'sha'
                lookup_name = 'S';
            case 'ta'
                lookup_name = 't';
            case 'tsa'
                lookup_name = 'ts';
            case 'va'
                lookup_name = 'v';
            case 'xa'
                lookup_name = 'X';
            case 'ya'
                lookup_name = 'y';
            case 'za'
                lookup_name = 'z';
            case 'zja'
                lookup_name = 'Z';
        end
        if ~isempty(lookup_name)
            IX = find(strcmp(lookup_name, labels));
            mapping_vec(ph) = IX;
        else
            mapping_vec(ph) = 0;
        end
    end
    behvioral_phoneme_labels = labels(mapping_vec);
    behvioral_phoneme_labels = behvioral_phoneme_labels(outperm);
    similarity_mat = similarity_mat(mapping_vec,mapping_vec);
    similarity_mat = similarity_mat(outperm,outperm);
    distance_mat = distance_mat(mapping_vec, mapping_vec);
    distance_mat = distance_mat(outperm,outperm);
    S = S(outperm, outperm);
    D = squareform(D);
    D = D(outperm, outperm);   
    
    similarity_mat(1:length(similarity_mat)+1:end) = nan;
    distance_mat(1:length(distance_mat)+1:end) = nan;

    h_sim = figure('color', [1 1 1]); 
    subplot(121)
    imagesc(S)
    title('Neural activity', 'fontsize', 14)
    axis xy
    set(gca, 'xtick', 1:length(behvioral_phoneme_labels))
    set(gca, 'xticklabel', behvioral_phoneme_labels)
    set(gca, 'ytick', 1:length(behvioral_phoneme_labels))
    set(gca, 'yticklabel', behvioral_phoneme_labels)
    colorbar
    
    subplot(122)
    imagesc(similarity_mat)
    title('Behavioral', 'fontsize', 14)
    axis xy
    set(gca, 'xtick', 1:length(behvioral_phoneme_labels))
    set(gca, 'xticklabel', behvioral_phoneme_labels)
    set(gca, 'ytick', 1:length(behvioral_phoneme_labels))
    set(gca, 'yticklabel', behvioral_phoneme_labels)    
    colorbar
    
    saveas(gcf, '../../Figures/comparison_behav_neural_similarity.png', 'png')
%     D_behavioral = -log(similarity_mat);
   
%     mean_S_behav = nanmean(similarity_mat);
%     mean_S_recor = nanmean(S);
%     figure('color', [1 1 1])
%     text(mean_S_behav/max(mean_S_behav), mean_S_recor/max(mean_S_recor), behvioral_phoneme_labels);
%     axis equal
%     xlim([0 1])
%     ylim([0 1])
%     xlabel('Behavioral')
%     ylabel('Neural Activity')
    
    similarity_mat(1:length(similarity_mat)+1:end) = 1;
    S(1:length(S)+1:end) = 1;
    distance_mat(1:length(distance_mat)+1:end) = 0;
    
    [results.RHO,results.PVAL] = corr(similarity_mat, S, 'Type','Spearman');
    S_behavr_vec = similarity_mat(logical(triu(ones(length(similarity_mat)),1)));
    S_neural_vec = S(logical(triu(ones(length(S)),1)));
    [results.RHO_sim,results.PVAL_sim] = corr(S_behavr_vec, S_neural_vec, 'Type','Spearman');
    [results.TAU_sim,results.PVAL_sim_tau] = corr(S_behavr_vec, S_neural_vec, 'Type','Kendall');
% 
%     figure;imagesc(results.RHO)
    results.mean_RHO = mean(results.RHO(1:length(results.RHO)+1:end));
    results.std_RHO = std(results.RHO(1:length(results.RHO)+1:end));
    
    for i = 1:length(results.RHO)
        vec1 = similarity_mat(i, setdiff(1:length(results.RHO), i));
        vec2 = S(i, setdiff(1:length(results.RHO), i));
        results.r(i) = corr(vec1', vec2', 'Type','Spearman');
    end
    results.mean_r = mean(results.r);
    results.std_r = std(results.r);
    
    figure('color', [1 1 1], 'visible', 'on', 'units', 'normalized', 'position', [0 0.2, 1, 0.5]);
    subplot(131)
    Y1 = mdscale(distance_mat,2);
    scatter(Y1(:, 1), Y1(:, 2), 1e-2)
    text(Y1(:, 1), Y1(:, 2), behvioral_phoneme_labels, 'fontsize', 16)    
    title('Behavioral', 'fontsize', 14)
    axis off
    subplot(132)
    Y1 = mdscale(squareform(D),2);
    scatter(Y1(:, 1), Y1(:, 2), 1e-2)
    text(Y1(:, 1), Y1(:, 2), behvioral_phoneme_labels, 'fontsize', 16)    
    title('Neural activity', 'fontsize', 14)
    axis off
    subplot(133)
    mean_D_behav = nanmean(distance_mat);
    mean_D_recor = nanmean(D);
%     figure('color', [1 1 1])
    text(mean_D_behav/max(mean_D_behav), mean_D_recor/max(mean_D_recor), behvioral_phoneme_labels, 'fontsize', 14);
    axis tight
    axis equal
    xlim([0.65 1])
    ylim([0.65 1])
    line([0 2], [0 2], 'linestyle', '--', 'color', 'k')
    title('Mean distance to other phonemes', 'fontsize', 14)
    xlabel('Behavioral', 'fontsize', 14)
    ylabel('Neural', 'fontsize', 14)
    saveas(gcf, '../../Figures/comparison_behav_neural_distances.png', 'png')
end

end