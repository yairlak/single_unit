function settings = load_phonemes(settings)
load('../../phoneme_names.mat')
natural_classes = load_natural_classes(settings);

%%
settings.phonemes = [natural_classes.nasals_Heb, natural_classes.liquids, natural_classes.plosives, natural_classes.fricatives];
settings.phonemes = heb_phonemes;
% settings.phonemes([1,6, 10,15,22]) = [];
if settings.omit_no_response_phonemes
    fname = sprintf('no_response_phonemes_%s.mat', settings.language);
    load(fullfile(settings.path2data_phonemes, '..', fname));
    settings.phonemes = setdiff(settings.phonemes, no_responses_phonemes);
end
%%
settings.phonemes = union(settings.phonemes, settings.phonemes);
for p = 1:length(settings.phonemes)
    curr_ph = settings.phonemes{p};
    switch settings.language
        case 'Hebrew'
            cmp = strcmp(heb_phonemes, curr_ph);
        case 'English'
            cmp = strcmp(eng_phonemes, curr_ph);
    end
    if sum(cmp)~=1
        error('A problem with finding serial order of phoneme')
    else
        settings.phonemes_serial_number(p) = find(cmp);
    end
end

if strcmp(settings.labels_type, 'phonemes')
    settings.conditions = settings.phonemes;
end

end