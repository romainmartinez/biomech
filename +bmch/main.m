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
            % inputs :
            %   varargin: optionnal argument if you want to debug [integer]
            
            if ~nargin
                self.field = 0;
            elseif nargin == 1
                self.field = num2str(varargin{1});
            else
                error('Too much arguments (1 optionnal, integer) [bmch warning].')
            end
            
            self.event_loop;
            
        end % constructor
        
        %-------------------------------------------------------------------------%
        function self = event_loop(self)
            while self.field ~= 'x'
                self = self.choose_field;
            end
            self.ui.print_bye
        end % event_loop
        
        function self = choose_field(self)
            if self.field == 0
                current = 'main';
            elseif isempty(self.buffer)
                self.ui.category = bmch.util.category('main');
                current = self.ui.category{str2double(self.field)};
            else
                current = self.ui.category{str2double(self.field)};
            end
            
            self.buffer = [self.buffer {current}];
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