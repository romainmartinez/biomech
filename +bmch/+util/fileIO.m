classdef fileIO
    % files inputs and output of the biomech toolbox.
    
    properties
        current          % current field (emg, force, etc.)
        folders          % folder containing c3d files
    end % properties
    
    %-------------------------------------------------------------------------%
    methods
        
        function self = fileIO(current, folders)
            self.current = current;
            self.folders = folders;
        end % constructor
        
        %-------------------------------------------------------------------------%
        function openc3d(self, conf)
            for ifolder = self.folders'
                filenames = dir(sprintf('%s/*.c3d', ifolder{:}));
                for itrial = {filenames.name}
                    % open btk object
                    c = btkReadAcquisition(sprintf('%s/%s', ifolder{:}, itrial{:}));
                    
                    if contains(self.current, 'emg') || contains(self.current, 'force')
                        d = btkGetAnalogs(c);
                    elseif contains(self.current, 'markers')
                        d = btkGetMarkers(c);
                    end
                    
                    %A METTRE DANS FUNCTION%
                    % get c3d channels
                    fields = fieldnames(d);
                    
                    self.assignc3dfields(fields, conf, itrial)
                    %%%
                    
                    % close btk object
                    btkCloseAcquisition(c);
                end
            end
            %             c = btkReadAcquisition()
            
            
            %               preallocation
        end
        
        function assignc3dfields(self, fields, conf, trial)
            % assignc3dfields  assign c3d fields with a specific GUI
            %
            %   See also MEAN, MEDIAN, QUANTILE, VAR, STD, CORR, PCA.
            
            % TODO: add help (file:///home/romain/Downloads/GUI_layout/layoutdoc/User_guide4_1.html)
            
            % create interface
            % root figure
            f = figure('units', 'normalized',...
                'outerposition', [.25 .25 .5 .8],...
                'MenuBar', 'none',...
                'Toolbar', 'none');
            
            % panel
            panel = uix.BoxPanel('Parent', f,...
                'Title', sprintf('%s - channels assignment', self.current{:}));
            
            % hbox
            hbox = uix.HBox('Parent', panel,...
                'Spacing', 5, 'Padding', 5) ;
            
            % 1) element 1: list of fields
            uicontrol('Parent', hbox,...
                'Style', 'listbox',...
                'String', fields);
            
            % 2) element 2: buttons
            box1 = uix.VButtonBox('Parent', hbox,...
                'Spacing', 5);
            uicontrol('Parent', box1,...,
                'Style', 'text',...
                'FontWeight', 'bold',...
                'String', 'current target:');
            uicontrol('Parent', box1,...,
                'Style', 'text',...
                'String', 'current target');
            uicontrol('Parent', box1, 'String', 'OK');
            uicontrol('Parent', box1, 'String', 'NaN');
            set(box1, 'ButtonSize', [130 35], 'Spacing', 5);
            
            box2 = uix.VButtonBox('Parent', hbox,...
                'Spacing', 5);
            uicontrol('Parent', box2,...,
                'Style', 'text',...
                'FontWeight', 'bold',...
                'String', 'current trial:');
            uicontrol('Parent', box2,...,
                'Style', 'text',...
                'String', 'current trial');
                        uicontrol('Parent', box2,...,
                'Style', 'text',...
                'String', '1/54 (X%)');
            set(box2, 'ButtonSize', [130 35], 'Spacing', 5);
            
            % 3) element 3: current assignments
            uicontrol('Parent', hbox,...
                'Style', 'listbox',...
                'String', conf);
            hbox.Widths = [-2 -1 -1 -1];
            
            % update interface
            
        end
        
    end % methods
    
end % class