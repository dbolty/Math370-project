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
terrain.set_lighting(37.71, -122.42);
[camp, camt] = terrain.get_cam();
drone2 = Drone(camp,camt)
drone2.view()
zoom(2.5)
%drone2 = drone2.Fly_Drone([37.6288,-122.3799,6000],[37.6288,-122.3799,950],30)
%drone2 = drone2.Fly_Drone([37.63,-122.3799,3000],[37.638,-122.3799,950],30)
%drone2 = drone2.Fly_Drone([37.68,-122.45,6000],[37.688,-122.45,950],30)
%%Good Data Point for locations
drone2 = drone2.fly_to([37.62884,-122.4555,2000],50)
drone2 = drone2.fly_to([37.71453,-122.4902,1500],50)
drone2 = drone2.fly_to([37.729535,-122.4088,1300],50)
drone2 = drone2.fly_to([37.74535,-122.3588,1800],50)
drone2 = drone2.fly_to([37.74535,-122.3588,2000],50)