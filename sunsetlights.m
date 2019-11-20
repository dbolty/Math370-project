% Trenton Jansen
%h is the light handle.
function sunsetlights(h)
    redsunset=253;%variables
    yellowsunset=94;
    bluesunset=83;
    redsun=253;
    yellowsun=184;
    bluesun=19;
    sunsetanglechange=20;
    %function
    p=h.Position;
    r=sqrt(p(1)^2+p(2)^2);
    angle=atan(p(3)/r);
    red=253;
    yellow= min( yellowsunset+angle*(yellowsun-yellowsunset)/(sunsetanglechange*pi/180),yellowsun );
    blue= max( bluesunset+angle*(bluesun-bluesunset)/(sunsetanglechange*pi/180),bluesun);
    h.Color =[red/255 yellow/255 blue/255 ]
end