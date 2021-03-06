%Low Speed Lab 1 
%the purpose of this script is to import our raw data and formate the data
%in graphs
clc; clear all
close all

%read in and format data
data = csvread("data2.csv");

rundata = zeros(57,3,2);
runNum = 0;
counter = 1;
for i=1:length(data)
    if(data(i,4) ~= runNum+1)
        rundata(:,:,runNum+1) = data(runNum*57+1:counter-1, 1:3);
        runNum = runNum + 1;
    end
    if( i == length(data) )
        rundata(:,:,2) = data(runNum*57+1:counter, 1:3);
    end
    counter = counter + 1;
end 

alpha = [0,0,10,10];
ball = ["World Series Ball", "Regular Season Ball"];
for i=1:runNum+1
    figure(i)
    plot( rundata(1:57,2,i), 1:57);
    title(['Wake Profile From  ', ball(i)]);
    ylabel(' Pitot Static Tube Number');
    xlabel(' Pressure in [psi] ');
end



% density of air
air = 1.2;
%calculated from anamometer
Vinf = 26.72; 
v_err = .12;
%chord length 
c = 0.073;
%pitot tube spaceing on rake
dy = .002; 

rakeData = zeros(57,1,2);
rakeData(:,:,1) = rundata(:, 2, 1);
rakeData(:,:,2) = rundata(:, 2, 2);
%convert to pa 
rakeData = rakeData*6894.76; 

dp = 0.0000001; % uncertainty for electronic pitot tubes

%drag coefficient: Cd = 2*integral[ (U(y)/Uinf) - (U(y)/Uinf)^2 ] (dy/c) from - 

for run=1:2
    for i=1:length(rakeData(:,:,run))
        vPitot(i) = sqrt((rakeData(i,1,run) * 2) / air);
        dv = abs((sqrt(2)/2)*sqrt(1/(air*rakeData(i,1,run)))*dp);
        g(i) = ( ( vPitot(i)/ Vinf)  - (vPitot(i)/Vinf)^2 )*2*(dy/c);
        dg(i) = abs( ((1/Vinf)) + 2*(vPitot(i))*dv) + abs( -vPitot(i)*(Vinf^-2) + 2*(vPitot(i)*(Vinf^-2)*vPitot(i))*v_err);               
    end
    dc = norm(dg);
    cd = sum(g);
    fprintf('The coefficient of drag for the %s is %f +- %f \n', ball(run), cd,  dc);
    
end
mu = 1.983e-5;
Re = (air*Vinf*c)/mu;
deltaRe = abs((air*c)/mu)*v_err;
fprintf('The Reynolds number for the balls is %e +- %f\n', Re, deltaRe);




