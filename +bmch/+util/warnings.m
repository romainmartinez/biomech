function warnings(varargin)
% Enter the warning you want to display
% Warning: the string ' ' (space) is forbidden, choose '_' instead.

if ~nargin || nargin > 1
    error('invalid argument (1 required, str) [bmch warning].')
end

switch varargin{1}
    case 'configuration_files'
        warns = {'the bmch folder must be empty',...
            'the following conf files consist of a simple csv file: `participants.csv`, `markers.csv`, `emg.csv`',...
            'csv conf files must be comma separated'};
    case 'no_project'
        warns = {'there is no project loaded in the cache folder',...
            'if you want to create a new project, go to preprocessing > configuration_files > create new bmch project',...
            'if you want to load an existing project, go to preprocessing > configuration_files > load existing bmch project into cache'};
    otherwise
        error('invalid argument [bmch warning].')
end

% print line
carac = repmat('~',1,6);
fprintf('\n%s WARNINGS %s\n', carac, carac)

% display warnings
cellfun(@(x,y) fprintf('[%d] - %s\n', x, y), num2cell(1:length(warns)), warns);

% print line
fprintf('%s\n', repmat('~',1,22)) % line
end