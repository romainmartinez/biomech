function output = header(varargin)
% Enter the header you want to input here
% Warning: the string ' ' (space) is forbidden, choose '_' instead.

if ~nargin || nargin > 1
    error('invalid argument (1 required, str) [bmch warning].')
end

switch varargin{1}
    case 'participants'
        output = {'pseudo', 'process', 'laterality', 'group', 'mass', 'height', 'date'};
    case 'emg'
        output = {'muscle_id', 'publication_name'};
    case 'markers'
        output = {'marker_id'};
    case 'force'
        output = {'analog_id'};
    otherwise 
        error('invalid argument [bmch warning].')
end

