classdef import_files
    % main launcher of the biomech toolbox.
    
    properties
        main            % main class
        current         % current field (emg, force, etc.)
        datadir         % folders contening data
        participants    % participants name
    end % properties
    
    %-------------------------------------------------------------------------%
    methods
        
        function self = import_files(main)
            self.main = main;
            bmch.util.warnings('import_files')
            
            % current field (emg, force, etc.)
            self.current = main.ui.category(str2double(main.field));
            
            % select participants
            selected = main.conf.participants.pseudo(main.conf.participants.process == 1);
            self.participants = bmch.util.selector(selected);
            
            % get data folders
            self.datadir = self.get_datadir;
            
            % open data files
            self.open_c3d
            
        end % constructor
        
        %-------------------------------------------------------------------------%
        function datadir = get_datadir(self)
            istheretxt = dir(sprintf('%s/inputs/*.txt', self.main.conf.folder));
            
            if ~isempty(istheretxt)
                % data folder is in a txt file
                fileID = fopen(sprintf('%s/%s', istheretxt.folder, istheretxt.name));
                C = textscan(fileID,'%s');
                fclose(fileID);
                dataroot = C{1}{:};
            else
                % data folder is in 'inputs', in the bmch project folder
                dataroot = sprintf('%s/inputs/', self.main.conf.folder);
            end
            % folders contening data
            datadir = cellfun(@(x) sprintf('%s%s', dataroot, x), self.participants, 'UniformOutput', false);
        end
        
        function open_c3d(self)
            % current conf file (only first column)
            conf = table2cell(self.main.conf.(self.current{:})(:,1));
            
            for ifolder = self.datadir'
                filenames = dir(sprintf('%s/*.c3d', ifolder{:}));
                fprintf('folder: %s\n', ifolder{:})
                for itrial = {filenames.name}
                    fprintf('\ttrial: %s\n', itrial{:});
                    % open btk object
                    c = btkReadAcquisition(sprintf('%s/%s', ifolder{:}, itrial{:}));
                    
                    if contains(self.current, 'emg') || contains(self.current, 'force')
                        d = btkGetAnalogs(c);
                    elseif contains(self.current, 'markers')
                        d = btkGetMarkers(c);
                    end
                    
                    % get current channels names
                    fields = fieldnames(d);
                    
                    % assign c3d channels name
                    assign = bmch.preprocessing.assignC3Dfields(self.current, fields, conf, itrial, ifolder{:});
                    corrected = assign.export;
                    % save assignment into conf
                    assign.save;
                    
                    % close btk object
                    btkCloseAcquisition(c);
                end
            end
        end
        
    end % methods
    
end % class