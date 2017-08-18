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
    end % properties
    
    %-------------------------------------------------------------------------%
    methods
        
        function self = main(varargin)
            % inputs :
            %   varargin: optionnal argument if you want to debug [integer]
            
            if ~nargin
                self.field = 0;
            elseif nargin == 1
                self.field = varargin{1};
            else
                error('Too much arguments (1 optionnal, integer) [bmch warning].')
            end
            
            self.ui = bmch.util.gui;
            self.ui.print_header;
            
            self.event_loop;
        end % constructor
        
        %-------------------------------------------------------------------------%
        function self = event_loop(self)
            question_main = bmch.util.category('main');
            if self.field == 0
                self.field = self.ui.display_choice(question_main, 'main');
            end
            
            fieldi = bmch.util.category(question_main{self.field}, self.field);
            self.ui.display_choice(fieldi)
            
            switch self.field
                case 1 % pre-processing
                    self.ui.field(self.field)
                    bmch.preproc
                case 2 % processing
                    bmch.proc
                case 3 % statistics
                    bmch.stat
                case 4 % plot
                    bmch.plot
                case 5 % exit
                    fprintf('Done, goodbye.\n')
                otherwise
                    error('invalid field [bmch warning].')
            end
            
        end
        
    end % methods
    
end % class