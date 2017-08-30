% pipe operator
% inspired by R ('magrittr') and python ('pandas')
classdef pipe
    
    properties (Access = private)
        arg
    end
    
    methods
        
        %-------------------------------------------------------------------------%
        function this = pipe(arg)
            this.arg = arg;
        end % constructor
        
        %-------------------------------------------------------------------------%
        function result = subsref(this, s)
            if mod(numel(s), 2) ~= 0 || any(~strcmp({s(1:2:end).type}, '.')) || any(~strcmp({s(2:2:end).type}, '()'))
                error('invalid syntax');
            end
            
            result = this.arg;
            
            for idx = 1:2:numel(s)
                result = feval(s(idx).subs, result, s(idx+1).subs{:});
            end
        end
    end
end