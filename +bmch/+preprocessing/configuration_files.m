function configuration_files(self)
% create configurations files.
% this is the first (necessary) step.

clc
self.ui.print_header
fprintf('%s...\n', self.ui.category{str2double(self.field)})

fileID = {'emg', 'markers', 'participants'};

folder = uigetdir(self.ui.category{str2double(self.field)});

switch self.field
    case '1' % create new bmch project
        % display warning
        self.ui.display_warning(self.current)
        
        % create folders
        mkdir(folder, 'inputs'); % TODO: if no c3d, txt file with the data path
        mkdir(folder, 'outputs');
        mkdir(folder, 'conf');
        
        % create conf files (comma separated csv)
        cellfun(@(x) bmch.util.cell2csv(sprintf('%s/conf/%s.csv', folder, x), bmch.util.header(x)), fileID);
        
        % display confirmation message
        bmch.util.confirmation('createproject')
        
    case '2' % load existing bmch project
        % load csv conf files ('emg', 'markers', 'participants')
        conf_files = cellfun(@(x) readtable(sprintf('%s/conf/%s.csv', folder, x)), fileID, 'UniformOutput', false);
        
        % convert to conf.mat file
        conf = cell2struct(conf_files, fileID, 2);
        
        % add current folder to conf file
        conf.folder = folder;
        
        % add current folder to cache
        save('./cache/cache.mat', 'folder')
        
        % save file to conf folder
        save(sprintf('%s/conf/conf.mat', folder), 'conf');
        
    otherwise
        error('invalid argument [bmch warning].')
end

end