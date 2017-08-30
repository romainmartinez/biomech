% import c3d files into mat files
classdef import_files
    
    properties
        main            % main class
        current         % current field (emg, force, etc.)
        target          % target channel names
        datadir         % folders contening data
        basePath        % base folder for each participant
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
            
            % open data files with 'openFolder' method
            cellfun(@(x) self.openFolder(x), self.datadir)
            
        end % constructor
        
        %-------------------------------------------------------------------------%
        function output = get_datadir(self)
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
            dataDir = cellfun(@(x) sprintf('%s%s/', dataroot, x), self.participants, 'UniformOutput', false);
            
            % get folders where current field is recorded
            f = @(x) x.folder(x.(self.current{:}) == 1);
            trialType = f(self.main.conf.trials);
            
            % get folder containing data for all trial type
            xi = cellfun(@(x) strcat(dataDir, x), trialType, 'UniformOutput', false);
            output = reshape([xi{:}], [length(dataDir) * length(xi),1]);
        end
        
        %-------------------------------------------------------------------------%
        function openFolder(self, ifolder)
            % print folder
            fprintf('folder: %s\n', ifolder)
            
            % create output folder
            savePath = sprintf('%s/%s/', ifolder, self.current{:});
            if isempty(dir(savePath))
                mkdir(savePath)
            end
            
            % trials in datadir
            filenames = dir(sprintf('%s/*.c3d', ifolder));
            trialnames = sort({filenames.name});
            
            % open each trial
            for itrial = trialnames
                % import data
                data = self.openTrial(ifolder, itrial{:}); %#ok<NASGU>
                
                % save data
                filename = sprintf('%s/%s.mat', savePath, itrial{:}(1:end-4));
                bmch.util.savefast(filename, 'data');
            end
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
        
        %-------------------------------------------------------------------------%
        function output = get_confPath(~, folder)
            output = regexprep(folder,'[^/]+(?=/$|$)','');
        end
       
    end % methods
    
end % class