classdef fileIO
    % main launcher of the biomech toolbox.
    
    properties
        current         % current field (emg, force, etc.)
        folders          % folder containing c3d files
    end % properties
    
    %-------------------------------------------------------------------------%
    methods
        
        function self = fileIO(current, folders)
            self.current = current;
            self.folders = folders;
        end % constructor
        
        %-------------------------------------------------------------------------%
        function openc3d(self)
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
                    structname = fieldnames(d);
                    %%%
                    
                    % close btk object
                    btkCloseAcquisition(c);
                end
            end
            %             c = btkReadAcquisition()
            
            
            %               preallocation
        end
        
        function assignc3dfields
        end
        
    end % methods
    
end % class