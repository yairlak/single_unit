function settings = load_responsiveness(settings)

p_thresh = settings.p_thresh;
data_files = dir(fullfile(settings.path2data_phonemes, 'Channel*.mat'));
phonemes = settings.phonemes;

for neuron_counter=1:length(data_files)
    data_file = data_files(neuron_counter).name;
    data_file = fullfile(settings.path2data_phonemes, data_file);
    load(data_file, 'BlockSpikeTrains');
    for pho=1:length(phonemes)
        pho_data = BlockSpikeTrains.(phonemes{pho});
        % check responsiveness (Evoked response)
        after_stimulus_response = sum(pho_data(:,501:1000),2);
        before_stimulus_response = sum(pho_data(:,1:500),2);
        [h,p] = ttest(after_stimulus_response, before_stimulus_response,'alpha',p_thresh); 
        responsive_h(neuron_counter,pho) = h; 
        responsive_p(neuron_counter,pho) = p; 
    end
end

settings.responsiveness.responsive_h  = responsive_h;
settings.responsiveness.responsive_p  = responsive_p;
settings.no_responses_phonemes = phonemes(sum(responsive_h,1)==0);

end
