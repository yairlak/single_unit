function results = check_responsiveness(data, settings, params)

phonemes = fieldnames(data.rasters_binned(1));
num_phonemes = length(phonemes);

units = settings.units;
num_units = length(units);

responsiveness_h = nan(num_units, num_phonemes);
responsiveness_p = nan(num_units, num_phonemes);
for u = 1:num_units
    for ph = 1:num_phonemes
        curr_ph = phonemes{ph};
        curr_data = data.rasters_binned(u).(curr_ph);
        before_stimulus = curr_data(:,1);
        after_stimulus = curr_data(:,2);
        [h, p] = ttest(before_stimulus, after_stimulus);
        results.responsiveness_h(u, ph) = h;
        results.responsiveness_p(u, ph) = p;
    end
    results.response_inducing_phonemes{u} = phonemes(results.responsiveness_h(u, :)==1);
end
results.responsive_units = nansum(results.responsiveness_h, 2)>1;
results.omit_files = data.file_names(~results.responsive_units);

for f = 1:length(results.omit_files)
    src = fullfile(settings.path2data_phonemes, results.omit_files{f});
    folders = strsplit(settings.path2data_phonemes, '/');
    folders = folders(1:end-1);
    destin = strjoin(folders, '/');
    movefile(src, destin)
end