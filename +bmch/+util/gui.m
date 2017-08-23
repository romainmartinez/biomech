classdef gui
    %{
%   Description: graphical interface
%
%   author:  Romain Martinez
%   email:   martinez.staps@gmail.com
%   website: github.com/romainmartinez
    %}
    
    properties
        current
        category
    end % properties
    
    %-------------------------------------------------------------------------%
    methods
        
        function self = gui(current, buffer)
            clc
            
            self.current = current;
            self.category = bmch.util.category(current);
            
            self.print_header;
            
            % print current category 
            buffer2print = bmch.util.pipe(buffer).upper().strjoin(' > ').strrep('_', ' ');
            fprintf('%s\n', buffer2print)
            
        end % constructor
        
        function answer = display_choice(self) 
            % display choices
            cellfun(@(x,y) fprintf('[%d] - %s\n', x, y), num2cell(1:length(self.category)), self.category)
            
            if contains(self.current, 'main')
                fprintf('e[x]it\n')
            else
                fprintf('e[x]it | [r]eturn\n')
            end
            answer = input('What do you want to do?: ', 's');
            fprintf('\n')
        end
        
    end % methods
    
    %-------------------------------------------------------------------------%
    methods(Static)
        
        function print_header
            fprintf('%s\n', repmat('-',1,42))
            fprintf('%sBIOMECH. SIGNAL PROCESSING\n', repmat(' ',1,8))
            fprintf('%s\n', repmat('-',1,42))
        end % print_header
        
        function print_bye
            fprintf('Done, bye.\n')
        end
        
        function display_warning(type)
            switch type
                case 'configuration_files'
                    warns = {'the bmch folder must be empty',...
                        'the following conf files consist of a simple csv file: `participants.csv`, `markers.csv`, `emg.csv`',...
                        'csv conf files must be comma separated'};
                otherwise
                    error('please select a listed warning [bmch warning].')
            end
            carac = repmat('~',1,6); % line
            fprintf('\n%s WARNINGS %s\n', carac, carac)
            
            % display warnings
            cellfun(@(x,y) fprintf('[%d] - %s\n', x, y), num2cell(1:length(warns)), warns);

            fprintf('%s\n', repmat('~',1,22)) % line
            
        end
        
    end
end % class