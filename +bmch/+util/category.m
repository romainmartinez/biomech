function output = category(varargin)
% Enter the category you want to display here
% Warning: the string ' ' (space) is forbidden, choose '_' instead.

if ~nargin || nargin > 1
    error('invalid argument (1 required, str) [bmch warning].')
end

switch varargin{1}
    case 'main'
        output = {'preprocessing', 'processing', 'statistics', 'plot'};
    case 'preprocessing'
        output = {'configuration_files', 'model_construction', 'kinematic_reconstruction', 'channels_assignment'};
    case 'processing'
    case 'statistics'
    case 'plot'
    otherwise 
        error('invalid argument [bmch warning].')
end

