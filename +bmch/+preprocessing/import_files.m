classdef import_files
    % main launcher of the biomech toolbox.
    
    properties
        main            % main class
        fileio          % fileIO class
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
            % fileIO class object
            self.fileio = bmch.util.fileIO(self.current, self.datadir);
            % get the current conf file (only first column)
            conf = table2cell(self.main.conf.(self.current{:})(:,1));
            % open c3d files
            self.fileio.openc3d(conf)
        end
        
    end % methods
    
end % class