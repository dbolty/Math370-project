classdef Terrain
    %TERRAIN Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        filename
        latlim
        lonlim
        lat
        lon
        Z
        header
        profile
        OrthoImage
        curr_cam_loc
        curr_cam_tar
    end
    
    methods
        function obj = Terrain(filename)
            %%Load in the data from the 7.5deg DEM file
            [obj.lat,obj.lon,obj.Z,obj.header,obj.profile] = usgs24kdem(filename);
            obj.Z(obj.Z==0) = -1;
            obj.latlim = [min(obj.lat(:)) max(obj.lat(:))];
            obj.lonlim = [min(obj.lon(:)) max(obj.lon(:))];
            %% This is going to be another perspective of the elevation data
            numberOfAttempts = 5;
            attempt = 0;
            info = [];
            serverURL = 'http://basemap.nationalmap.gov/ArcGIS/services/USGSImageryOnly/MapServer/WMSServer?';
            while(isempty(info))
                try
                    info = wmsinfo(serverURL);
                    orthoLayer = info.Layer(1);
                catch e 

                    attempt = attempt + 1;
                    if attempt > numberOfAttempts
                        throw(e);
                    else
                        fprintf('Attempting to connect to server:\n"%s"\n', serverURL)
                    end        
                end
            end
            imageLength = 2048;
            [obj.OrthoImage,R] = wmsread(orthoLayer,'Latlim',obj.latlim, ...
                                       'Lonlim',obj.lonlim, ...
                                       'ImageHeight',imageLength, ...
                                       'ImageWidth',imageLength);
            x = obj.latlim(1);
            y = obj.lonlim(2);
            z = max(max(obj.Z));
            obj.curr_cam_loc = [x,y,z];
            obj.curr_cam_tar = [mean(obj.latlim) , mean(obj.lonlim), z];
        end
        
        function [camp, camt] = get_cam(obj)
            camp = obj.curr_cam_loc; 
            camt = obj.curr_cam_tar;
        end
        function Display(obj)
            f= gcf;
            f.WindowState = 'maximized';
            usamap(obj.latlim, obj.lonlim);
            geoshow(obj.lat, obj.lon, obj.Z, 'DisplayType','surface','CData', obj.OrthoImage, 'Clipping', 'off');
            zoom(2)
            daspectm('m',1);
            x = obj.latlim(1);
            y = obj.lonlim(2);
            z = max(max(obj.Z));
            camproj('orthographic')
            camposm(x , y ,z+1000);
            %lighting gouraud
            camtargm(mean(obj.latlim) , mean(obj.lonlim), z);
            plabel off
            mlabel off
            axis off
        end
        
        function view(obj)
            x = obj.latlim(1);
            y = obj.lonlim(2);
            z = max(max(obj.Z));
            camproj('perspective')
            [x,y,z] = camposm(x , y ,z+1000);
            view(3);
            campos([x,y,z])            
        end
        
         function Line(obj)
            obj.Display();
            [xm,ym,z]=camposm(min(obj.latlim),min(obj.lonlim),10000)
            [xM,yM,z]=camposm(max(obj.latlim),max(obj.lonlim),10000);
            l=linspace(xm,xM,100);L=linspace(ym,yM,100);zoom(1.5)
                for i=1:100
            	camva(5)
                campos([l(i) L(i) 10000])
                camtarget([l(i) L(i) max(max(obj.Z))])
                drawnow
                pause(.1)
                end
        end
        function LookCircle(obj)            
            obj.Display();
            [xm,ym,z]=camposm(min(obj.latlim),min(obj.lonlim),10000)
            [xM,yM,z]=camposm(max(obj.latlim),max(obj.lonlim),10000);
            l=linspace(xm,xM,50);L=linspace(ym,yM,50);zoom(1.5)
            camproj('perspective');k=0
                for i=1:99
                    k=k+1
                    camva(90)
                    campos([mean(l) mean(L) max(max(obj.Z))+100]) 
                    if k<50
                    camtarget([l(1) L(k) max(max(obj.Z))])
                    end
                    if k>=50
                    camtarget([l(k-49) L(50) max(max(obj.Z))])
                    end
                    pause(0.1)
                    drawnow
                end
                k=0;
                for i=1:99
                    k=k+1
                    if k<50
                    camtarget([l(50) L(50-k) max(max(obj.Z))])
                    end
                    if k>=50
                    camtarget([l(100-k) L(1) max(max(obj.Z))])
                    end
                    pause(.1)
                    drawnow
                end
        end
        
        function Circle(obj)
            obj.Display();
            [xm,ym,z]=camposm(min(obj.latlim),min(obj.lonlim),10000)
            [xM,yM,z]=camposm(max(obj.latlim),max(obj.lonlim),10000);
            l=linspace(xm,xM,50);L=linspace(ym,yM,50);
            for i=linspace(0,2*pi,30)
                %camva(45)
                campos([mean(l)+cos(i) mean(L)+sin(i) max(max(obj.Z))+1000])
                camtarget([mean(l) mean(L) max(max(obj.Z))])
                pause(.5)
                drawnow
            end
        end
        function set_lighting(obj,lat,lon)
            lighting gouraud
            handle = lightm(lat,lon);
            sunsetlights(handle);
        end

    end
end

