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
        questions
    end % properties
    
    %-------------------------------------------------------------------------%
    methods
        
        function self = gui
        end % constructor
        
        function answer = display_choice(self, varargin)
            % TODO: input parser here to print both question and current
            % varargin{1}
            % varargin{2}
            
            fprintf('%s > \n', upper(self.current))
            
            for icat = 1:length(self.questions)
                fprintf('[%d] - %s\n', icat,self.questions{icat})
            end
            fprintf('[%d] - exit\n', icat+1)
            answer = input('What do you want to do?: ');
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
        
    end
end % class