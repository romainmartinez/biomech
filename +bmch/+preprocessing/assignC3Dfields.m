classdef assignC3Dfields
    % GUI designed to assign c3d fields
    
    properties
        fields % current channels associated with the c3d file
        conf   % target channel names
        trial  % current trial
        gui    % gui data
    end
    
    methods
        function self = assignC3Dfields(fields, conf, trial)
            self.fields = fields;
            self.conf = conf;
            self.trial = trial;
            
            % check if conf == fields
            tocheck = ~ismember(self.conf, self.fields);
            
            if tocheck
                self.gui = self.createInterface;
            end
            
        end % constructor
        
        function gui = createInterface(self)
            % root figure
            f = figure('units', 'normalized',...
                'outerposition', [.25 .25 .5 .8],...
                'MenuBar', 'none',...
                'Toolbar', 'none');
            
            % panel
            panel = uix.BoxPanel('Parent', f,...
                'Title', 'channels assignment');
            
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
            
            gui.target = uicontrol('Parent', box1,...,
                'Style', 'text',...
                'String', 'current target');
            
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
            gui.conf = uicontrol('Parent', hbox,...
                'Style', 'listbox',...
                'String', self.conf);
            hbox.Widths = [-2 -1 -1 -1];
        end % createInterface
         
        function self = updateInterface(self, src, ~)
            if contains(src.String, 'NaN')
                disp('NaN')
            else
                disp('OK')
            end
            % get current selection
            current_field = self.fields(self.gui.fields.Value);
            
            self.fields(contains(self.fields, current_field)) = [];
            
            self.gui.fields.String = self.fields;
        end % nan
        
    end
    
end

