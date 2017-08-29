classdef import_files
    % main launcher of the biomech toolbox.
    
    properties
        main            % main class
        current         % current field (emg, force, etc.)
        target          % target channel names
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
            
            % target channel names
            self.target = table2cell(self.main.conf.(self.current{:})(:,1));
            
            % select participants
            selected = main.conf.participants.pseudo(main.conf.participants.process == 1);
            self.participants = bmch.util.selector(selected);
            
            % get data folders
            self.datadir = self.get_datadir;
            
            % open data files
            cellfun(@(x) self.openFolder(x), self.datadir)
            
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
        
        %-------------------------------------------------------------------------%
        function openFolder(self, ifolder)
            % trials in datadir
            filenames = dir(sprintf('%s/*.c3d', ifolder));
            % print folder
            fprintf('folder: %s\n', ifolder)
            % open each trial
            data = cellfun(@(x) self.openTrial(ifolder, x), {filenames.name}, 'UniformOutput', false);
            % save mat file for each participant
        end
        
        %-------------------------------------------------------------------------%
        function data = openTrial(self, ifolder, itrial)
            % print trial
            fprintf('\ttrial: %s\n', itrial);
            
            % open btk object
            c = btkReadAcquisition(sprintf('%s/%s', ifolder, itrial));
            
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
            assign = bmch.preprocessing.assignC3Dfields(self.current, fields, self.target, itrial, ifolder);
            corrected = assign.export;
            
            % save assignment into conf
            assign.save(freq);
            
            % close btk object
            btkCloseAcquisition(c);
            
            % preallocate
            data = zeros(lastFrame, length(self.target));
            % get data
            for i = 1:length(corrected)
                if ischar(corrected{i})
                    data(:,i) = d.(corrected{i});
                else % NaN
                    data(:,i) = NaN;
                end
            end
        end
       
    end % methods
    
end % class