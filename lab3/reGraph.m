clc; clear all
close all
Re1 = [ 1.5585*10^5, 2.0063*10^5, 2.4852*10^5, 2.9453*10^5, 2.9453*10^5];
Cd = [.41517, .39321, .31598, .18080, .18000];

figure(1)
axis([.01, 10*10^7, .06, 400]);
hold on
loglog(Re1, Cd, 'ro')
 

figure(2)
axis([.01, 10*10^7, .06, 400]);
hold on
Re = [.01:10:10^7];
Cdtheo =  (24./Re)+( (2.6*(Re./5))/( 1+(Re./5).^1.52 ))+( (.411*(Re./(2.63*10^5)).^-7.94)/(1+(Re./(2.63*10^5)).^-8))+( (.25*(Re./10^6))/(1+(Re./10^6)))

loglog(Re, Cdtheo)

