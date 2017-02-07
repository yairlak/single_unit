function model = get_bayesian_priors(model, settings, params)
% If uniform priors set all ones. Otherwise, load priors from file.
%%
natural_classes = load_natural_classes(settings);
switch settings.language
    case 'Hebrew'
        natural_classes.nasals = natural_classes.nasals_Heb;
end

%%
switch settings.prior_type
    case 'uniform'
        model.priors = ones(1, size(model.mean_firing_rate_matrix, 2));
        
    case 'frequency in experiment'
        for cnd = 1:length(settings.conditions)
            curr_cnd = settings.conditions{cnd};
            switch settings.labels_type
                case 'phonemes'
                    phonemes = {curr_cnd};
                otherwise
                    phonemes = natural_classes.(curr_cnd);
            end
            n = 1;
            for ph = 1:length(phonemes)
                if any(strcmp(settings.phonemes, phonemes{ph}))
                    n = n + 1;
                end
            end
            priors(cnd) = n;
        end
        model.priors = priors/sum(priors);
        %%----!!!!----override---
        model.priors = 1/length(settings.conditions);
        %%--------------
        
    case 'phoneme frequency'
        switch settings.language
            case 'Hebrew'
                switch settings.patient
                    case 'D011'
                        file_name = sprintf('%s phoneme frequency.txt', settings.language);
                    case {'466', '469', '472'}
                        file_name = 'English phoneme frequency for English speaker presented with Hebrew phonemes.txt';
                end
            case 'English'
        end
    % Open file and get priors
    fID = fopen(fullfile(settings.path2mainData, file_name));
    priors = textscan(fID, '%f %s');
    fclose(fID);
    priors = double(priors{1,1});
    priors = priors/sum(priors);
    priors = priors(settings.phonemes_serial_number);
    model.priors = priors';
end

end