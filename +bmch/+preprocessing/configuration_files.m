function configuration_files(self)
% create configurations files.
% this is the first (necessary) step.
clc
self.ui.print_header
fprintf('%s...\n', self.ui.category{str2double(self.field)})

fileID = {'emg', 'markers', 'participants'};

conf.folder = uigetdir(self.ui.category{str2double(self.field)});

switch self.field
    case '1' % create new bmch project
        self.ui.display_warning(self.current)
%         conf.folder = uigetdir(self.ui.category{str2double(self.field)});
        
        mkdir(conf.folder, 'inputs'); % TODO: if no c3d, txt file with the data path
        mkdir(conf.folder, 'outputs');
        mkdir(conf.folder, 'conf');
        
        % create conf files (comma separated csv)
        cellfun(@(x) bmch.util.cell2csv(sprintf('%s/conf/%s.csv', conf.folder, x), bmch.util.header(x)), fileID);
                
        answer = input('After filling the conf file, you can load the bmch project.\n [o]k?: ', 's');
        
        if answer ~= 'o'
            error('please, type [o] or re-create a project [bmch warning].')
        end
        
    case '2' % load existing bmch project
        cellfun(@(x) bmch.util.cell2csv(sprintf('%s/conf/%s.csv', conf.folder, x), bmch.util.header(x)), fileID);
        xi = {'emg', 'participants'}
        xi = cellfun(@(x) readtable(sprintf('%s/conf/%s.csv', conf.folder, x)), xi);
        
        xi = readtable(sprintf('%s/conf/%s.csv', conf.folder, xi));
    otherwise
end

% conf path
% conf participant
% load existing folder
end