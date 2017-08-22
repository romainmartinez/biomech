classdef main
    %{
%   Description: launcher of the 'BIOMECH' toolbox
%
%   author:  Romain Martinez
%   email:   martinez.staps@gmail.com
%   website: github.com/romainmartinez
    %}
    
    properties
        field
        ui
        buffer
    end % properties
    
    %-------------------------------------------------------------------------%
    methods
        
        function self = main(varargin)
            self.field = 0;
            self.event_loop;
        end % constructor
        
        %-------------------------------------------------------------------------%
        function self = event_loop(self)
            while self.field ~= 'x' % until e[x]it
                self = self.choose_field;
            end
            self.ui.print_bye
        end % event_loop
        
        function self = choose_field(self)
            if self.field == 0
                current = 'main';
            elseif self.field ~= 'r'
                current = self.ui.category{str2double(self.field)};
            end
            
            if self.field == 'r' % [r]eturn
                current = self.buffer{end-1};
                self.buffer = {self.buffer{1:end-1}};
            else
                self.buffer = [self.buffer {current}];
            end
            
            self.ui = bmch.util.gui(current, self.buffer);
            self.field = self.ui.display_choice;
            
            %             switch self.field
            %                 case 1 % pre-processing
            %                     self.ui.field(self.field)
            %                     bmch.preproc
            %                 case 2 % processing
            %                     bmch.proc
            %                 case 3 % statistics
            %                     bmch.stat
            %                 case 4 % plot
            %                     bmch.plot
            %                 otherwise
            %                     error('invalid field [bmch warning].')
            %             end
        end
        
    end % methods
    
end % class