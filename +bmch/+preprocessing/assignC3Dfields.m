% GUI designed to assign c3d fields
classdef assignC3Dfields < handle
    
    properties
        current % current field (emg, force, etc.)
        fields  % current channels associated with the c3d file
        target  % target channel names
        trial   % current trial
        conf    % configuration file for the current participant
        confPath% path to conf file
        gui     % gui data
        output  % correted fieldnames
        idx     % current position (relative to target number)
        tosave  % save assignment if the gui pop
        folder  % path to data (used to export the assign.mat file)
    end
    
    %-------------------------------------------------------------------------%
    methods
        function self = assignC3Dfields(current, fields, target, trial, folder)
            self.current = current;
            self.fields = fields;
            self.target = target;
            self.trial = trial;
            self.output = {};
            self.idx = 1;
            self.folder = folder;
            
            % get conf path
            self.confPath = self.get_confPath;
            
            % try to load an assign.mat file
            self.conf = self.loadAssign;
            
            % load assignment for current field
            assign = self.conf.assign.(self.current{:});
            
            % get best assignment
            assign = self.bestAssign(assign);
            
            if isempty(assign)
                % there is no assigment matching, so pop GUI
                self.gui = self.createInterface;
                uiwait(self.gui.f)
                self.tosave = 1;
            else
                % there is a matching
                for i = 1:length(assign)
                    if ischar(assign{i})
                        self.output{i} = self.fields{strcmp(self.fields, assign{i})};
                    else
                        self.output{i} = NaN;
                    end
                end
            end
        end % constructor
        
        %-------------------------------------------------------------------------%
        function output = get_confPath(self)
            output = regexprep(self.folder,'[^/]+(?=/$|$)','');
        end
        
        %-------------------------------------------------------------------------%
        function conf = loadAssign(self)
            loadPath = sprintf('%sconf.mat', self.confPath);
            if ~isempty(dir(loadPath))
                load(loadPath, 'conf');
                
                if ~isfield(conf.assign, self.current) %#ok<NODEF>
                    % if there is no field associated with the current channel type (emg, etc.)
                    conf.assign.(self.current{:}) = {};
                end
                
            else % if there is no conf file associated with this participant
                conf.assign.(self.current{:}) = {};
            end
        end % loadAssign
        
        %-------------------------------------------------------------------------%
        function output = bestAssign(self, assign)
            isGood = [];
            for cellRow = size(assign, 1): -1 : 1
                % current row
                row = assign(cellRow, :);
                % detect NaN
                notNaN = cellfun(@(x) ischar(x), row);
                % check if all assignment are in fields
                check = ismember(row(notNaN), self.fields);
                
                isGood(cellRow) = all(check, 2);
                sumGood(cellRow) = sum(check);
            end
            
            if any(isGood)
                % if there is conf file(s) matching
                if sum(isGood) > 1
                    % take the one with more matching
                    [~,isGood] = max(sumGood);
                else
                    isGood = logical(isGood);
                end
                
                output = assign(isGood,:);
            else
                % there is no assigment matching
                output = [];
            end
        end
        
        %-------------------------------------------------------------------------%
        function gui = createInterface(self)
            % root figure
            gui.f = figure('units', 'normalized',...
                'outerposition', [.25 .25 .5 .8],...
                'MenuBar', 'none',...
                'Toolbar', 'none');
            set(gui.f,'KeyPressFcn',@self.keyStroke);
            set(gui.f,'windowscrollWheelFcn',@self.scrollWheel);
            
            % panel
            panel = uix.BoxPanel('Parent', gui.f,...
                'Title', sprintf('%s - channels assignment', self.current{:}));
            
            % hbox
            hbox = uix.HBox('Parent', panel,...
                'Spacing', 5, 'Padding', 5) ;
            
            % 1) element 1: list of fields (dynamic)
            gui.fields = uicontrol('Parent', hbox,...
                'Style', 'listbox',...
                'String', self.fields);
            
            % 2) element 2: buttons (dynamic)
            box1 = uix.VButtonBox('Parent', hbox,...
                'Spacing', 5);
            
            uicontrol('Parent', box1,...,
                'Style', 'text',...
                'FontWeight', 'bold',...
                'String', 'current target:');
            
            gui.targetButton = uicontrol('Parent', box1,...,
                'Style', 'text',...
                'String', self.target{self.idx});
            
            uicontrol('Parent', box1,...
                'String', 'OK',...
                'Callback', @self.updateInterface);
            uicontrol('Parent', box1,...
                'String', 'NaN',...
                'Callback', @self.updateInterface);
            set(box1, 'ButtonSize', [150 35], 'Spacing', 5);
            
            box2 = uix.VButtonBox('Parent', hbox,...
                'Spacing', 5);
            uicontrol('Parent', box2,...,
                'Style', 'text',...
                'FontWeight', 'bold',...
                'String', 'current trial:');
            gui.trial = uicontrol('Parent', box2,...,
                'Style', 'text',...
                'String', self.trial);
            set(box2, 'ButtonSize', [150 35], 'Spacing', 5);
            
            % 3) element 3: current assignments
            gui.target = uicontrol('Parent', hbox,...
                'Style', 'listbox',...
                'String', self.target,...
                'Value', self.idx);
            hbox.Widths = [-2 -1 -1 -1];
        end % createInterface
        
        %-------------------------------------------------------------------------%
        function updateInterface(self, src, ~)
            self.idx = self.idx + 1;
            
            % if there is no markers, put NaN
            if isempty(self.fields)
                nb = length(self.target) - length(self.output);
                self.output = [self.output repmat({NaN}, 1, nb)];
                close all
            else
                
                % get current selection
                current_field = self.fields(self.gui.fields.Value);
                
                % add field in the output
                if contains(src.String, 'NaN')
                    self.output = [self.output nan];
                else
                    self.output = [self.output current_field];
                    % delete current selection from gui
                    self.fields(strcmp(self.fields, current_field)) = [];
                end
                
                % update gui
                if self.idx > length(self.target)
                    close all
                else
                    self.gui.fields.String = self.fields;
                    self.gui.targetButton.String = self.target{self.idx};
                    self.gui.target.Value = self.idx;
                end
            end
        end % updateInterface
        
        %-------------------------------------------------------------------------%
        function output = export(self)
            output = self.output;
        end % export
        
        %-------------------------------------------------------------------------%
        function save(self, freq)
            if self.tosave
                conf = self.conf; %#ok<PROPLC>
                conf.assign.(self.current{:}) = vertcat(self.conf.assign.(self.current{:}), self.output); %#ok<PROPLC>
                
                conf.freq.(self.current{:}) = freq; %#ok<PROPLC>
                
                
                save(sprintf('%sconf.mat', self.confPath), 'conf')
            end
        end % save
        
        %-------------------------------------------------------------------------%
        function keyStroke(self, ~, Event)
            switch Event.Character
                case '1'
                    src.String = 'OK';
                    self.updateInterface(src)
                case '2'
                    src.String = 'NaN';
                    self.updateInterface(src)
                otherwise
                    warning('wrong key stroke (OK [1] or NaN [2])')
            end
        end % keyStroke
        
        %-------------------------------------------------------------------------%
        function scrollWheel(self, ~, Event)
            value = self.gui.fields.Value + Event.VerticalScrollCount;
            max = length(self.gui.fields.String);
            if value < 1
                self.gui.fields.Value = 1;
            elseif value > max
                self.gui.fields.Value = max;
            else
                self.gui.fields.Value = value;
            end
        end % keyStroke
        
    end
end
