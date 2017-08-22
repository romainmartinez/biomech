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
            buffer2print = bmch.util.pipe(buffer).upper().strjoin(' > ').strrep('_', ' ');
            fprintf('%s\n', buffer2print)
        end % constructor
        
        function answer = display_choice(self)
            for icat = 1:length(self.category)
                fprintf('[%d] - %s\n', icat, strrep(self.category{icat}, '_', ' '))
            end
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
                    warns = {'the bmch folder must be empty'};
                otherwise
                    error('please select a listed warning [bmch warning].')
            end
            carac = repmat('~',1,6);
            fprintf('%s WARNINGS %s\n', carac, carac)
            
            for iwarn = 1:length(warns)
                fprintf('%d - %s\n', iwarn, warns{iwarn})
            end
            
            fprintf('%s\n', repmat('~',1,22))
            
        end
        
    end
end % class