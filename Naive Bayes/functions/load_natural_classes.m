function natural_classes = load_natural_classes(settings)
    natural_classes.vowels = {settings.a_vowel, 'e', 'o', 'u', 'i'};
    load('../../phoneme_names.mat')
    natural_classes.consonants = setdiff(heb_phonemes', {'aa', 'e', 'i', 'o', 'u'});
    
    natural_classes.labials = {'ma', 'ba', 'pa', 'va', 'fa'};
    natural_classes.non_labials = setdiff(natural_classes.consonants, natural_classes.labials);
    natural_classes.alveolar = {'ta', 'da', 'ts', 'sa', 'za', 'n', 'l'};
    natural_classes.coronals = {'la', 'ta', 'da', 'sa', 'za', 'sha', 'cha', 'dja', 'tsa', 'na'};
    natural_classes.non_coronals = setdiff(natural_classes.consonants, natural_classes.coronals);
    natural_classes.dorsals = {'ya', 'ga', 'ka'};
    natural_classes.non_dorsals = setdiff(natural_classes.consonants, natural_classes.dorsals);
    natural_classes.glottals = {'ha', 'xa', 'ra'};
    natural_classes.gutturals = {'ha', 'xa', 'ra'};
    natural_classes.non_gutturals = setdiff(natural_classes.consonants, natural_classes.gutturals);
    
    natural_classes.semi_vowels = {'ya', 'wa'};
    natural_classes.nasals_Eng = {'gna', 'ma', 'na'};
    natural_classes.nasals_Heb = {'ma', 'na'};
    natural_classes.non_nasals = setdiff(natural_classes.consonants, natural_classes.nasals_Heb);
    natural_classes.liquids = {'ra', 'la'};
%     natural_classes.approximants = [natural_classes.semi_vowels, natural_classes.liquids];
    
    natural_classes.plosives = {'pa', 'ta', 'ka', 'ba', 'da', 'ga'};
    natural_classes.non_plosives = setdiff(natural_classes.consonants, natural_classes.plosives);
    natural_classes.fricatives = {'fa', 'va', 'sa', 'za', 'sha', 'ha', 'xa', 'ha'};
    natural_classes.non_fricatives = setdiff(natural_classes.consonants, natural_classes.fricatives);
    natural_classes.affricates = {'cha', 'dja', 'tsa'};
    natural_classes.non_affricates = setdiff(natural_classes.consonants, natural_classes.affricates);
    
    natural_classes.voiced = {'ba', 'da', 'ga', 'dja', 'va', 'za', 'zja', 'ra', 'ma', 'na', 'la', 'ya'};
    natural_classes.unvoiced = {'pa', 'ta', 'ka', 'tsa', 'cha', 'fa', 'sa', 'sha', 'xa', 'ha'};
    
    natural_classes.approximants_Heb = {'la', 'ya', 'ra'};
    natural_classes.non_approximants = setdiff(natural_classes.consonants, natural_classes.approximants_Heb);
    
    natural_classes.sonorants = {natural_classes.vowels{:}, natural_classes.nasals_Heb{:}, natural_classes.approximants_Heb{:}};
    natural_classes.obstruents = {natural_classes.fricatives{:}, natural_classes.plosives{:}, natural_classes.affricates{:}};

    
    natural_classes.fricatives_voiced = {'va', 'za', 'xa'};
    natural_classes.fricatives_unvoiced = {'fa', 'sa'};
    natural_classes.plosives_voiced = {'ba', 'da', 'ga'};
    natural_classes.plosives_unvoiced = {'pa', 'ta', 'ka'};
    natural_classes.stridents = {'cha', 'za', 'sa', 'dja', 'tsa', 'sha'};    
end