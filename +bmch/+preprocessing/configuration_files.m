function configuration_files(main)
    % create configurations files.
    % this is the first (necessary) step.

clc
main.ui.print_header
fprintf('%s...\n', main.ui.category{str2double(main.field)})

fileID = {'emg', 'markers', 'force', 'participants', 'trials'};

folder = uigetdir(main.ui.category{str2double(main.field)});

switch main.field
    case '1' % create new bmch project
        bmch.util.warnings(main.current)
        
        % create folders
        mkdir(folder, 'inputs');
        mkdir(folder, 'outputs');
        mkdir(folder, 'conf');
        
        % create conf files (comma separated csv)
        cellfun(@(x) bmch.util.cell2csv(sprintf('%s/conf/%s.csv', folder, x), bmch.util.header(x)), fileID);
        
        % display confirmation message
        bmch.util.confirmation('createproject')
        
    case '2' % load existing bmch project
        % load csv conf files ('emg', 'markers', 'participants')
        conf_files = cellfun(@(x) readtable(sprintf('%s/conf/%s.csv', folder, x),...
            'delimiter', ','),...
            fileID, 'UniformOutput', false);
        
        % convert to conf.mat file
        conf = cell2struct(conf_files, fileID, 2);
        
        % add current folder to conf file
        conf.folder = folder;
        
        % add current folder to cache
        if ~exist('./cache', 'dir')
            mkdir('./cache')
        end
        save('./cache/cache.mat', 'folder')
        
        
        % save file to conf folder
        save(sprintf('%s/conf/conf.mat', folder), 'conf');
        
    otherwise
        error('invalid argument [bmch warning].')
end

end