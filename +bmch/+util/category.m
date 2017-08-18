function output = category(varargin)

if ~nargin || nargin > 1
    error('invalid argument (1 required, str) [bmch warning].')
end

switch varargin{1}
    case 'main'
        output = {'pre-processing', 'processing', 'statistics', 'plot'};
    case 'pre-processing'
        output = {'model construction', 'kinematic reconstruction', 'channels assignment'};
    case 'processing'
    case 'statistics'
    case 'plot'
    otherwise 
        error('invalid argument [bmch warning].')
end

