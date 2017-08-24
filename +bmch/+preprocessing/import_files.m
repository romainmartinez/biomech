classdef import_files
    % main launcher of the biomech toolbox.
    
    properties
        main
        dataroot
        datadir
    end % properties
    
    %-------------------------------------------------------------------------%
    methods
        
        function self = import_files(main)
            self.main = main;
            bmch.util.warnings('import_files')
            
            % get folder path
            self.dataroot = self.get_dataroot;
            
            % get folder names
            self.datadir = self.get_datadir(self.dataroot);
            
            % verify that all participants have a folder
            contains(main.conf.participants.pseudo, self.datadir)
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
        
        function participants_have_folder()
        end
        
    end % methods
    
end % class