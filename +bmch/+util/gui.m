% Terminal interface of the bmch toolbox
classdef gui
    
    properties
        current
        category
    end % properties
    
    methods
        
        %-------------------------------------------------------------------------%
        function self = gui(current, buffer, folder)
            clc
            
            self.current = current;
            self.category = bmch.util.category(current);
            
            self.print_header;
            
            if ~isempty(folder)
                fprintf('bmch project: ''%s''\n', folder)
            else
                %                 fprintf('no bmch project loaded\n')
                bmch.util.warnings('no_project')
            end
            
            % print current category
            buffer2print = bmch.util.pipe(buffer).upper().strjoin(' > ').strrep('_', ' ');
            fprintf('%s\n', buffer2print)
            
        end % constructor
        
        %-------------------------------------------------------------------------%
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
    
    methods(Static)
        
        %-------------------------------------------------------------------------%
        function print_header
            fprintf('%s\n', repmat('-',1,42))
            fprintf('%sBIOMECH. SIGNAL PROCESSING\n', repmat(' ',1,8))
            fprintf('%s\n', repmat('-',1,42))
        end % print_header
        
        %-------------------------------------------------------------------------%
        function print_bye
            fprintf('Done, bye.\n')
        end
    end
end % class