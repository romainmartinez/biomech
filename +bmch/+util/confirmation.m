function confirmation(varargin)
% Enter the message you want to display after an event
% Warning: the string ' ' (space) is forbidden, choose '_' instead.

if ~nargin || nargin > 1
    error('invalid argument (1 required, str) [bmch warning].')
end

switch varargin{1}
    case 'createproject'
        question = 'After filling the conf file, you can load the bmch project.';
    case 'loadproject'
        question = {'Projec.'};
    otherwise
        error('invalid argument [bmch warning].')
end

answer = input(sprintf('%s\n[o]k?: ', question), 's');

if answer ~= 'o'
    error('please, type [o] or rerun the current action [bmch warning].')
end
