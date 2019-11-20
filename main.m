clear all;
clc

figure(1);
clf;
filename = "USGSDATA/San_Fran_North.dem";
terrain  = Terrain(filename);
terrain.Display();
terrain.view();
view(3)



figure(2); clf;
terrain  = Terrain(filename);
terrain.Display();
terrain.view();
terrain.LookCircle();
