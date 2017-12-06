clc; clear all
close all
V =  10;
A = 1;
b = [.001,.01,.1,1,10];

%b=.001
[X,Y] = meshgrid(-.02:.0005:.02);
theta1 = atan2(Y,X+b(1));
theta2 = atan2(Y,X-b(1));
f = V*Y+(A/(2*pi))*(atan2(Y,(X+b(1))))-(A/(2*pi))*(atan2(Y,(X-b(1))));
figure(1)
contour(X,Y,f,25,'b');
hold on
contour(X,Y,f,[0,0],'r')

%b=.01
[X,Y] = meshgrid(-.1:.0005:.1);
theta1 = atan2(Y,X+b(2));
theta2 = atan2(Y,X-b(2));
f = V*Y+(A/(2*pi))*(atan2(Y,(X+b(2))))-(A/(2*pi))*(atan2(Y,(X-b(2))));
figure(2)
contour(X,Y,f,25,'b');
hold on
contour(X,Y,f,[0,0],'r')

%b=.1
[X,Y] = meshgrid(-.5:.0005:.5);
theta1 = atan2(Y,X+b(3));
theta2 = atan2(Y,X-b(3));
f = V*Y+(A/(2*pi))*(atan2(Y,(X+b(3))))-(A/(2*pi))*(atan2(Y,(X-b(3))));
figure(3)
contour(X,Y,f,25,'b');
hold on
contour(X,Y,f,[0,0],'r')

%b=1
[X,Y] = meshgrid((-5:.05:5),(-1:.001:1));
theta1 = atan2(Y,X+b(4));
theta2 = atan2(Y,X-b(4));
f = V*Y+(A/(2*pi))*(atan2(Y,(X+b(4))))-(A/(2*pi))*(atan2(Y,(X-b(4))));
figure(4)
contour(X,Y,f,25,'b');
hold on
contour(X,Y,f,[0,0],'r')

%b=10
[X,Y] = meshgrid((-15:.5:15),(-1:.0005:1));
theta1 = atan2(Y,X+b(5));
theta2 = atan2(Y,X-b(5));
f = V*Y+(A/(2*pi))*(atan2(Y,(X+b(5))))-(A/(2*pi))*(atan2(Y,(X-b(5))));
figure(5)
contour(X,Y,f,25,'b');
hold on
contour(X,Y,f,[0,0],'r')

%problem 2
chord=2*sqrt(b.^2+b/(pi*10));
thickness=[.0113,.035,.081,.11,.114];
tc=thickness./chord;
figure(6)
plot(b,tc)
title('T/C vs B ');






