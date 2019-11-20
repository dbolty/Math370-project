clear all;
clc

figure(1);
clf
filename = "USGSDATA/sanfranciscos.dem";
terrain  = Terrain(filename);
terrain.Display()


figure(2);clf;
terrain.Display();
terrain.LookCircle();


figure(3);clf;
terrain.Display();
drone2 = Drone()
drone2.view()
drone2 = drone2.Fly_Drone([37.6288,-122.3799,6000],[37.6288,-122.3799,950],30)
%drone2 = drone2.Fly_Drone([37.63,-122.3799,3000],[37.638,-122.3799,950],30)
drone2 = drone2.Fly_Drone([37.68,-122.45,6000],[37.688,-122.45,950],30)
drone2 = drone2.fly_to([37.62884,-122.3799,20000],50)
%drone2 = drone2.Fly_Drone([37.6255,-122.48,1200],[37.6455,-122.4016,800],30)
drone2 = drone2.Fly_Drone([37.75,-122.355,2000],[37.68,-122.4016,800],30)