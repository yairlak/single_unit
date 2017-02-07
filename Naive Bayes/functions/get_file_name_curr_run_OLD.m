function file_name = get_file_name_curr_run(settings, params)
addpath('common functions\')
settings_fiels = {'patient', 'language', 'prior_type', 'units', 'labels_type'};
params_fiels = {'num_bins', 'seed', 'time_interval'};

for f = settings_fiels
    field_value = num2str(settings.(f{1}));
    field_value = strrep(field_value, '[', '_');
    field_value = strrep(field_value, ']', '_');
    field_value = strrep(field_value, ':', '_');
    field_value = strrep(field_value, ',', '_');
    filename_struct.(f{1}) = field_value;
end
for f = params_fiels
    field_value = num2str(params.(f{1}));
    field_value = strrep(field_value, '[', '_');
    field_value = strrep(field_value, ']', '_');
    field_value = strrep(field_value, ':', '_');
    field_value = strrep(field_value, ',', '_');
    filename_struct.(f{1}) = field_value;
end

%%
file_name = [buildStringFromStruct(filename_struct, '_') '.mat'];

end