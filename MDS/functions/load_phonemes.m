function settings = load_phonemes(settings)
load('../../phoneme_names.mat')
natural_classes = load_natural_classes(settings);

%%
settings.phonemes = [natural_classes.nasals_Heb, natural_classes.liquids, natural_classes.plosives, natural_classes.fricatives];
settings.phonemes = heb_phonemes;
settings.phonemes([1,6, 10,15,22]) = [];
% settings.phonemes([1, 5, 6, 10,15, 21, 22, 27]) = [];
if settings.omit_no_response_phonemes
%     fname = sprintf('no_response_phonemes_%s.mat', settings.language);
%     load(fullfile(settings.path2data_phonemes, '..', fname));
    settings = load_responsiveness(settings);
    settings.phonemes = setdiff(settings.phonemes, settings.no_responses_phonemes);
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

end

function natural_classes = load_natural_classes(settings)
    natural_classes.vowels = {settings.a_vowel, 'e', 'o', 'u', 'i'};
    natural_classes.semi_vowels = {'ya', 'wa'};
    natural_classes.nasals_Eng = {'gna', 'ma', 'na'};
    natural_classes.nasals_Heb = {'ma', 'na'};
    natural_classes.liquids = {'ra', 'la'};
    natural_classes.approximants = [natural_classes.semi_vowels, natural_classes.liquids];
    natural_classes.plosives = {'pa', 'ta', 'ka', 'ba', 'da', 'ga'};
    natural_classes.plosives_voiced = {'ba', 'da', 'ga'};
    natural_classes.plosives_unvoiced = {'pa', 'ta', 'ka'};
    natural_classes.fricatives = {'fa', 'va', 'sa', 'za', 'sha', 'ha', 'xa'};
    natural_classes.fricatives_voiced = {'va', 'za', 'xa'};
    natural_classes.fricatives_unvoiced = {'fa', 'sa'};
    natural_classes.stridents = {'cha', 'za', 'sa', 'dja', 'tsa', 'sha'};
    natural_classes.voiced = [natural_classes.plosives_voiced, natural_classes.fricatives_voiced];
    natural_classes.unvoiced = [natural_classes.plosives_unvoiced, natural_classes.fricatives_unvoiced];
end