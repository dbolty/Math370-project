clear all, close all, clc;


%I still dont know where to find other dem data.
filenames = gunzip('sanfranciscos.dem.gz',tempdir);
demFilename = filenames{1};
[lat,lon,Z,header,profile] = usgs24kdem(demFilename);
delete(demFilename);
Z(Z==0) = -1;
%We do this to get the domain of the dem area
latlim = [min(lat(:)) max(lat(:))];
lonlim = [min(lon(:)) max(lon(:))];



%% This is going to be another perspective of the elevation data
f = figure(2)
f.WindowState = 'maximized'
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
imageLength = 1024*4;
[A,R] = wmsread(orthoLayer,'Latlim',latlim, ...
                           'Lonlim',lonlim, ...
                           'ImageHeight',imageLength, ...
                           'ImageWidth',imageLength);

usamap(latlim, lonlim);
bx = geoshow(lat, lon, Z, 'DisplayType','surface','CData', A, 'Clipping', 'off');
% I dont know what this function does exactly yet.
daspectm('m',1)
%set up the new camera
title('San Fran fig2');
xx = linspace ( 37.6690 , 37.6255, 200);
yy = linspace ( -122.4360 , -122.5008, 200);

camtargm(mean(latlim) , mean(lonlim), 400);
ax = gca
ax.Clipping = 'off'
ax.ClippingStyle = 'rectangle'

for i = 1:200
    zoom(12);
    ax = gca;
    ax.Clipping = 'off';
    if( i > 50) 
     camtargm(xx(i-50) ,yy(i-50), 400);
    end
    camposm(xx(i),yy(i), 800)
    pause(0.02)
end

plabel off
mlabel off
