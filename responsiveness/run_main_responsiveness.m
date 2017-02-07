clear all; close all; clc
%%
delete('../../Output/log_unresponsive_units.txt')
for patient = {'D011', '466', '469', '472'}
    settings.patient = patient{1}; 
    params = [];
    main_responsiveness
    fprintf('%s\n', patient{1})
    results.omit_files'
end
fclose('all');