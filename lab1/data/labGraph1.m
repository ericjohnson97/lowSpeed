clc; clear all
close all

reGraph = imread('reGraph.jpg');
[py, px] = size(reGraph)
scalex = px/(10*10^7 - 10^-1) %pix per re 
scaley = py/(400 - .06)

Re = [2.07*10^3, 2.66*10^3, 3.27*10^3, 3.865*10^3, 3.865*10^3]
Cd = [.41517, .39321, .31598, .18080, .18000]
figure(1)
hold on
imshow(reGraph);
hold on
plot(log(Re, py - log(Cd), '-o')
hold off
