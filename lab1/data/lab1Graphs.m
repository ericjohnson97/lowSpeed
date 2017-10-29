%Low Speed Lab 1 
%the purpose of this script is to import our raw data and formate the data
%in graphs
clc; clear all
close all

%read in and format data
data = csvread("data.csv");

rundata = zeros(48,3,4);
runNum = 0;
counter = 1;
for i=1:length(data)
    
    if(data(i,3) ~= runNum)
        rundata(:,:,runNum+1) = data(runNum*48+1:counter-1, 1:3);
        runNum = runNum + 1;
    end
    if( i == length(data) )
        rundata(:,:,runNum+1) = data(runNum*48+1:counter, 1:3);
        disp '4'
    end
    counter = counter + 1;
end 

alpha = [0,0,10,10];
for i=1:4
    figure(i)
    plot( rundata(1:48,1,i), rundata(1:48,2,i));
    title(['Wake Profile From Angle of Attack ' num2str(alpha(i)), ' degrees']);
    xlabel(' Pitot Static Tube Number');
    ylabel(' Pressure in [psi] ');
end



% vectors for heights and corresponding uncertainties
h = [.02,.07,.33,.7,1.2,.25,.25];
dx = [.01,.01,.01,.01,.01,.01,.01,.01];
speeds = [ 10, 20, 40, 55, 70, 35, 35];
angleOfAttack = [0,0,0,0,0,0,10];
% conversion factor for inches to meters
in_to_m = .025;

% density of ethanol
eth = 827; 

% density of air
air = 1.2;

% gravity constant
g = 9.8;

% static pressure
Pstat = 107500; %[pa]

for i = 1:7
    
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
    
    fprintf('velocity at wind speed %i at angle of attack %d = %.02f +- %.02f [m/s] \n', speeds(i), angleOfAttack(i), v(i), v_err(i));
    
end


%chord length 
c = 0.2127;
%pitot tube spaceing on rake
dy = .002; 

%using run run 2 and run 4
rakeData = zeros(19,1,2);
rakeData(:,:,1) = rundata(30:48, 2, 2);
rakeData(:,:,2) = rundata(30:48, 2, 4);
%convert to pa 
rakeData = rakeData*6894.76; %Pstat %*ones(19,1,2);

dp = 0.0000001; % uncertainty for electronic pitot tubes

%drag coefficient: Cd = 2*integral[ (U(y)/Uinf) - (U(y)/Uinf)^2 ] (dy/c) from - 

%port #40 is giving a clearly wrong mesurment, so for the sake of analysis
%has been ommitted 
aoa = [0,10];
for run=1:2
    g = g*0;
    for i=1:18
        
        % get velocity
        
        vPitot(i) = sqrt((rakeData(i,1,run) * 2) / air);
        % we believe that the either the mechanical anomometer or the elctronic
        % pitot tubes were not calibrated correctly. For the sake of analysis
        % we have assumed a linear bias of 1.1437 meters per second. see repotr
        % for more details
        vPitot(i) = vPitot(1) - 1.1437;
        dv = abs((sqrt(2)/2)*sqrt(1/(air*rakeData(i,1,run)))*dp);
        %g = (( vPitot(i)/ v(6) ) - (vPitot(i)/v(6))^2 )
        g(i) = ((( vPitot(i)/ v(5+run) ) - (vPitot(i)/v(5+run))^2 ))*2*(dy/c);
        dg(i) = abs( ((1/v(5+run)) + 2*(vPitot(i)))*dv) + abs( -vPitot(i)*(v(5+run)^-2) + 2*(vPitot(i)*(-v(5+run)^-2)*vPitot(i))*v_err(5+run));           
        
    end
    
    dc = norm(dg);
    cd = sum(g);
    fprintf('Our calculated coefficient of drag is %.02f +- %.02f for angle of attack %d \n', cd, dc, aoa(run) );

    
end
