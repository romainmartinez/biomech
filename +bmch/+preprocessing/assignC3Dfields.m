classdef assignC3Dfields < handle
    % GUI designed to assign c3d fields
    
    properties
        current % current field (emg, force, etc.)
        fields  % current channels associated with the c3d file
        target  % target channel names
        trial   % current trial
        conf    % configuration file for the current participant
        gui     % gui data
        output  % correted fieldnames
        idx     % current position (relative to target number)
        tosave  % save assignment if the gui pop
        folder  % path to data (used to export the assign.mat file)
    end
    
    methods
        function self = assignC3Dfields(current, fields, target, trial, folder)
            self.current = current;
            self.fields = fields;
            self.target = target;
            self.trial = trial;
            self.output = {};
            self.idx = 1;
            self.folder = folder;
            
            % try to load an assign.mat file
            self.conf = self.loadAssign;
            
            % check if target == fields
            check = ismember(self.conf.assign.(self.current{:}), self.fields);
            
            % verify if we can find a conf file matching all fields
            checkID = all(check, 2);
            
            if any(checkID) % if there is one file matching
                for i = 1:length(self.conf.assign.(self.current{:})(checkID,:))
                    self.output{i} = self.fields{strcmp(self.fields, self.conf.assign.(self.current{:}){checkID, i})};
                end
            else
                self.gui = self.createInterface;
                uiwait(self.gui.f)
                self.tosave = 1;
            end
            
        end % constructor
        
        function conf = loadAssign(self)
            loadPath = sprintf('%s/conf.mat', self.folder);
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
        
        function gui = createInterface(self)
            % root figure
            gui.f = figure('units', 'normalized',...
                'outerposition', [.25 .25 .5 .8],...
                'MenuBar', 'none',...
                'Toolbar', 'none');
            
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
        
        function updateInterface(self, src, ~)
            self.idx = self.idx + 1;
            % get current selection
            current_field = self.fields(self.gui.fields.Value);
            
            % delete current selection from gui
            self.fields(contains(self.fields, current_field)) = [];
            
            % add field in the output
            if contains(src.String, 'NaN')
                self.output = [self.output nan];
            else
                self.output = [self.output current_field];
            end
            
            % update gui
            if self.idx > length(self.target)
                close all
            else
                self.gui.fields.String = self.fields;
                self.gui.targetButton.String = self.target{self.idx};
                self.gui.target.Value = self.idx;
            end
        end % nan
        
        function output = export(self)
            output = self.output;
        end
        
        function save(self, freq)
            conf = self.conf; %#ok<PROPLC>
            conf.assign.(self.current{:}) = vertcat(self.conf.assign.(self.current{:}), self.output); %#ok<PROPLC>
            if self.tosave
                conf.freq.(self.current{:}) = freq; %#ok<PROPLC>
                save(sprintf('%s/conf.mat', self.folder), 'conf')
            end
        end
        
    end
end
