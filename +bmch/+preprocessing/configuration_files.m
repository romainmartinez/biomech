function tata =  configuration_files(self)
% create configurations files.
% this is the first (necessary) step.
clc
self.ui.print_header
fprintf('%s...\n', self.ui.category{str2double(self.field)})

switch self.field
    case '1' % create new bmch project
    self.ui.display_warning(self.current)
    conf.folder = uigetdir(self.ui.category{str2double(self.field)});
    
    mkdir(conf.folder, 'outputs');
    mkdir(conf.folder, 'conf');
    
    % 1) participants' pseudo
    
    case '2' % load existing bmch project
    otherwise
end

% conf folder
% conf path
% conf participant
% load existing folder
end