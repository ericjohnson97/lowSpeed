%Low Speed Lab 2
%the purpose of this script is to import our raw data and formate the data
%in graphs
clc; clear all
close all

%read in and format data
data = csvread("data2.csv");

rundata = zeros(48,3,7);
runNum = 0;
counter = 1;
for i=1:length(data)
    
    if(data(i,3) ~= runNum)
        rundata(:,:,runNum+1) = data(runNum*48+1:counter-1, 1:3);
        runNum = runNum + 1;
    end
    if( i == length(data) )
        rundata(:,:,runNum+1) = data(runNum*48+1:counter, 1:3);
    end
    counter = counter + 1;
end 

[m,n,p] = size(rundata);

figure(1)
%runs used 
runNum = [1,3,4,5,6];
label = ["Speed 40","Speed 50","Speed 60","Speed 70","Speed 70"];

% monometer pressures
h = [.35, .58, .89, 1.25, 1.25];
dx = [.01, .01, .01, .01, .01];

% density of ethanol
eth = 827; 

% density of air
air = 1.2;

% gravity constant
g = 9.8;

% static pressure
Pstat = 109100; %[pa]

% conversion factor for inches to meters
in_to_m = .025;

for i = 1:length(h)
    
    % convert inches to meters
    x = h(i) * in_to_m;
    y = x * sqrt((dx(i)/h(i))^2);
    
    % get hydraulic pressure
    a = eth * g * x;
    b = a * sqrt((y/x)^2);
    Phdr = Pstat + a;
    Phdr_err = b;
    
    % get dynamic pressure
    Pd = Phdr - Pstat;
    Pd_err = sqrt(Phdr_err^2);
    % get velocity
    v(i) = sqrt((Pd * 2) / air);
    v_err(i) = v(i)*sqrt((Pd_err/Pd)^2);
    
    %fprintf('velocity at wind speed %i at angle of attack %d = %.02f +- %.02f [m/s] \n', speeds(i), angleOfAttack(i), v(i), v_err(i));
    
end

% temperature in degrees celcius
T = 19.5 + 273; 

% diameter of shpere
D =.216;

% standard temperature 
To =  288.6;

%mu at sealevel and stadard temperature 
muo = 1.7894*10^-5;

%mu at out test conditions. equation from book
mu = muo*((T/To)^(3/2))*((To+110)/(T+110));

%reynolds number at each speed 
Re =  (air*v*D)/mu

%theta angle for each pitot port
theta = 0:10:350;
%convert to radians 
theta = theta.*(pi/180);
R = .5*D;

%An for 0 and 180 which is port 0 and 18 
An(1) = .5*pi*(R^2)*(sin(theta(1)+(5*(pi/180)))^2);
An(19) = .5*pi*(R^2)*(sin(theta(19)+(5*(pi/180)))^2);
%calc An 
for i=1:36
    if(abs(theta(i) - 0) > .001 && abs(theta(i) - pi) > .001) 
        if( theta(i) < pi)
            An(i) = ((.5*pi*(R^2)*((sin(theta(i)+(5*(pi/180)))^2) - (sin( theta(i)-(5*(pi/180)) )^2))));
        end
        if ( theta(i) > pi)
            An(i) = -1*(.5*pi*(R^2)*((sin(theta(i)+(5*(pi/180)))^2) - (sin( theta(i)-(5*(pi/180)) )^2)));
        end
   end
end
%convert Psi measurments to pa  
rundata(:,2,:) = rundata(:,2,:)*6894.76;
rundata(19,2,:) = (rundata(18,2,:) + rundata(20,2,:)) / 2
Pinf = rundata(19,2,:);
%calc drag
for run=1:7
sum = 0;
    for i=1:36
        sum = ((rundata(i,2,run)) - (Pinf(run)))*An(i) + sum;
    end
    Fd(run) = sum
end
Po = rundata(1,2,:)
for run=1:7
    sum = 0;
    for i=1:36
        sum = ((Po(run) - (Pinf(run))))*An(i) + sum;
    end
   denom(run) = sum
   cd(run) = Fd(run)/denom(run)
end


for i=1:length(runNum)
    subplot(3,2,i)
    title(label(i));
    hold on
    plot(rundata(:,1,runNum(i)+1), rundata(:,2,runNum(i)+1));
end


