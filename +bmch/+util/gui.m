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
            fprintf('%s\n', upper(strjoin(buffer, ' > '))) 
        end % constructor
        
        function answer = display_choice(self)
            for icat = 1:length(self.category)
                fprintf('[%d] - %s\n', icat,self.category{icat})
            end
            fprintf('e[x]it | [r]eturn\n')
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
        
    end
end % class