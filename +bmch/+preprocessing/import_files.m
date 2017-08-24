classdef import_files
    % main launcher of the biomech toolbox.
    
    properties
        main
        dataroot
        datadir
        participants
    end % properties
    
    %-------------------------------------------------------------------------%
    methods
        
        function self = import_files(main)
            self.main = main;
            bmch.util.warnings('import_files')
            
            % select participants
            self.participants = bmch.util.selector(main.conf.participants.pseudo);

            % get folder path
            self.dataroot = self.get_dataroot;   
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
        
    end % methods
    
end % class