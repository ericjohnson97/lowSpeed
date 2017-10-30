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
P = [.35, .58, .89, 1.25, 1.25];
dP = [.01, .01, .01, .01, .01];

% density of ethanol
eth = 827; 

% density of air
air = 1.2;

% gravity constant
g = 9.8;

% static pressure
Pstat = 109100; %[pa]

% temperature in degrees celcius
T = 19.5; 



for i=1:length(runNum)
    subplot(3,2,i)
    title(label(i));
    hold on
    plot(rundata(:,1,runNum(i)+1), rundata(:,2,runNum(i)+1));
end


