function generate_MDS_dendrograms(data, settings, params)
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
% PC3 = coeff(:, 3);

mat_projection = mat_phonemes * [PC1, PC2];
fig_pca = figure('visible', 'off');
scatter(mat_projection(:, 1), mat_projection(:, 2), 1e-2)
text(mat_projection(:, 1), mat_projection(:, 2), settings.phonemes, 'fontsize', 16)
set(fig_pca, 'Color', [1 1 1])
axis off
title('PCA')
fig_file_name = ['PCA_', file_name, '.png'];
saveas(fig_pca, fullfile('..', '..', 'Figures', fig_file_name), 'png')

%% Distance mat, MDS
D = pdist(mat_phonemes, settings.metric);

% Dendrogram
fig_tree = figure('visible', 'off');
tree = linkage(D, 'single');
[H, T, outperm] = dendrogram(tree);

file_name = ['outperm_' file_name];
save(fullfile('../../Output', file_name), 'outperm')

set(gca, 'xticklabel', settings.phonemes(outperm))
set(gcf, 'Color', [1 1 1])
set(gca, 'ytick', [])
ylabel('Relative Distance', 'fontsize', 13)
fig_file_name = ['Dendro_', file_name, '.png'];
saveas(fig_tree, fullfile('..', '..', 'Figures', fig_file_name), 'png')

%% MDS
if settings.generate_figures_MDS
    Y1 = mdscale(D,2);
    fig_mds = figure('visible', 'off');
    scatter(Y1(:, 1), Y1(:, 2), 1e-2)
    text(Y1(:, 1), Y1(:, 2), settings.phonemes, 'fontsize', 16)
    set(fig_mds, 'Color', [1 1 1])
    axis off
    axis equal
    Y1 = mdscale(D,3);

    fig_file_name = ['MDS_', file_name, '.png'];
    saveas(fig_mds, fullfile('..', '..', 'Figures', fig_file_name), 'png')
end

%% MDS 3D
if settings.generate_figures_MDS_3D
    fig_mds3D = figure('visible', 'off');
    scatter3(Y1(:, 1), Y1(:, 2), Y1(:, 3), 1e-2)
    text(Y1(:, 1), Y1(:, 2), Y1(:, 3), settings.phonemes, 'fontsize', 16)
    set(fig_mds3D, 'Color', [1 1 1])

    title('MDS')
    fig_file_name = ['MDS3D_', file_name, '.png'];
    saveas(fig_mds3D, fullfile('..', '..', 'Figures', fig_file_name), 'png')
end
end