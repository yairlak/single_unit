function natural_classes = load_natural_classes(settings)
    natural_classes.labials = {'ma', 'ba', 'pa', 'va', 'fa'};
    natural_classes.coronals = {'la', 'ta', 'da', 'sa', 'za', 'sha', 'cha', 'dja', 'tsa', 'na'};
    natural_classes.dorsals = {'ya', 'ga', 'ka'};
    natural_classes.glottals = {'ha', 'xa', 'ra'};
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