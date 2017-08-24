classdef import_files
    % main launcher of the biomech toolbox.
    
    properties
        main            % main class
        fileio          % fileIO class
        dataroot        % path to data
        datadir         % folders contening data
        participants    % participants name
        current         % current field (emg, force, etc.)
    end % properties
    
    %-------------------------------------------------------------------------%
    methods
        
        function self = import_files(main)
            self.main = main;
            bmch.util.warnings('import_files')
            
            % current field (emg, force, etc.)
            self.current = main.ui.category(str2double(main.field));
            
            % select participants
            self.participants = bmch.util.selector(main.conf.participants.pseudo);
            
            % get folder path
            self.dataroot = self.get_dataroot;
            
            % check if there is a folder for each selected participants
            self.datadir = self.get_datadir(self.dataroot);
            
            % open data files
            self.open_c3d
            
        end % constructor
        
        %-------------------------------------------------------------------------%
        function dataroot = get_dataroot(self)
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
        end
        
        function datadir = get_datadir(~, dir_name)
            %outputs a cell with directory names (as strings), given a certain dir name (string)
            dd = dir(dir_name);
            isub = [dd(:).isdir];
            datadir = {dd(isub).name}';
            datadir(ismember(datadir,{'.','..'})) = [];
        end
        
        function open_c3d(self)
            % get all data folders
            folders = cellfun(@(x) sprintf('%s%s', self.dataroot, x), self.datadir, 'UniformOutput', false);
            % fileIO class object
            self.fileio = bmch.util.fileIO(self.current, folders);
            % open c3d files
            self.fileio.openc3d
        end
        
    end % methods
    
end % class