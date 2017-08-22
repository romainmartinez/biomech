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
            
            if length(self.buffer) < 3 
                self.ui = bmch.util.gui(current, self.buffer);
                self.field = self.ui.display_choice;
            else % if we are in the 3th step, we want to launch the function associated
               bmch.(self.buffer{2}).(self.buffer{3});
            end
            
        end
        
    end % methods
    
end % class