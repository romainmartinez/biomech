classdef main
    % main launcher of the biomech toolbox.
    
    properties
        conf
        field
        ui
        buffer
        current
        debug
    end % properties
    
    %-------------------------------------------------------------------------%
    methods
        
        function self = main(varargin)
            % verify that bmch is the current working directory
            if ~contains(pwd, 'biomech')
                error('make the biomech package folder your current directory [bmch warning].')
            end
            
            if ~exist('./cache', 'dir')
                mkdir('./cache')
            end
            
            try
                % load cache folder
                load('./cache/cache.mat');
                % load conf files from cache folder
                load(sprintf('%s/conf/conf.mat', folder));
                self.conf = conf;
            catch
                self.conf.folder = [];
            end
            
            if nargin == 1 % debug mode
                self.debug = num2str(varargin{1});
            end
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
                self.current = 'main';
            elseif self.field ~= 'r'
                self.current = self.ui.category{str2double(self.field)};
            end
            
            if self.field == 'r' % [r]eturn
                self = self.return2previous(1);
            else
                self.buffer = [self.buffer {self.current}];
            end
            
            self.ui = bmch.util.gui(self.current, self.buffer, self.conf.folder);
            
            if isempty(self.debug)
                self.field = self.ui.display_choice;
            else % debug mode
                self.field = self.debug(1);
                self.debug(1) = [];
            end
            
            if length(self.buffer) == 3 && self.field ~= 'r' && self.field ~= 'x'
                self = self.launcher; % launch specific function
                bmch.main;
            end
        end % choose_field
        
        function self = return2previous(self, nb)
            self.current = self.buffer{end-nb};
            self.buffer = {self.buffer{1:end-nb}};
        end % return2previous
        
        function self = launcher(self)
            bmch.(self.buffer{2}).(self.buffer{3})(self);
            self = self.return2previous(2);
            self.ui.category = bmch.util.category(self.current);
        end % launcher
        
    end % methods
    
end % class