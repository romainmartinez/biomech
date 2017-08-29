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
                        freq = btkGetAnalogFrequency(c);
                        lastFrame = btkGetAnalogFrameNumber(c);
                    elseif contains(self.current, 'markers')
                        d = btkGetMarkers(c);
                        freq = btkGetPointFrequency(c);
                        lastFrame = btkGetLastFrame(c);
                    end
                    
                    % get current channels names
                    fields = fieldnames(d);
                    
                    % assign c3d channels name
                    assign = bmch.preprocessing.assignC3Dfields(self.current, fields, conf, itrial, ifolder{:});
                    corrected = assign.export;
                    % save assignment into conf
                    assign.save(freq);
                    
                    % close btk object
                    btkCloseAcquisition(c);
                    
                    % 3d matrix of the corresponding data
                    % | emg     | data x muscles x time  |
                    % | analog  | data x channels x time |
                    % | markers | axes x markers x time  |
                    
                    data.emg = zeros(lastFrame, length(conf));
                    data.force = zeros(lastFrame, length(conf));
                    data.M = zeros(3, length(conf), lastFrame);
                   
                    % preallocate
                    data= zeros(lastFrame, length(conf));
                    % get data
                    for i = 1:length(corrected)
                        data(:,i) = d.(corrected{i});
                    end
                end
            end
        end % open_c3d
        
        function extract_data(self)
        end
        
    end % methods
    
end % class