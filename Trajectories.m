% To systematically compare the new model (CA opinions) with the old market 
% and to interpret results The analysis is conducted to test the stability 
% of the models over multiple runs
%clear all
close all

clc
tic

% Enabling Features of the Markets
trading = 1;   %trading
historicVola = 1;   %historic vola
opinionPropagation = 1;   %opinion prop
short = 1; %allows shortselling
T = 1000;  %simulation periods
agents=200; %number of agents
loops=10; %specify the number of runs

% initializing output variables
volume=zeros(T,loops);
vola=zeros(T,loops);
clusters=zeros(T,loops);
shortsale=zeros(T,loops);
price=ones(T,loops);
volume2=zeros(T,loops);
vola2=zeros(T,loops);
clusters2=zeros(T,loops);
shortsales2=zeros(T,loops);
price2=zeros(T,loops);
voladays=10;
%Main Loop 
figure('Name','new versus old model')
for i=1:loops
    % running both models in each loop
    [volume(:,i),vola(:,i),clusters(:,i),shortsale(:,i),price(:,i)]=market('new',trading,historicVola,opinionPropagation,short,T,agents,0);
    [volume2(:,i),vola2(:,i),clusters2(:,i),shortsales2(:,i),price2(:,i)]=market('old',trading,historicVola,opinionPropagation,short,T,agents,0);
    
    %plotting volatility outputs
    Amax=max(max(vola));
    Bmax=max(max(vola2));
    scale=max(Amax,Bmax)*100*1.2;
    s{i} = sprintf('Loop %i', i);
    subplot(2,2,1)
    title('new model vola')
    hold on
    plot(vola(voladays:T,:)*100)
    axis([voladays,T,0,scale])
    legend(s)
    xlabel('Time')
    ylabel('Daily volatility in %')
    subplot(2,2,2)
    title('old model vola')
    hold on
    plot(vola2(voladays:T,:)*100)
    axis([voladays,T,0,scale])
    legend(s)
    xlabel('Time')
    ylabel('Daily volatility in %')
    
    %plotting cluster outputs
    subplot(2,2,3)
    title('new model clusters')
    hold 
    on
    plot(clusters(voladays:T,:))
    xlabel('Time')
    ylabel('Cluster Members')
    subplot(2,2,4)
    title('old model clusters')
    hold 
    on
    plot(clusters2(voladays:T,:))
    xlabel('Time')
    ylabel('Cluster Members')
    pause(0.05)
end

hold off

% plotting the price paths in both models
figure('Name','Price Trajectories new model')
plot(price(1:T-1,:));
xlabel('Time')
ylabel('Price Dynamics')
legend(s)
figure('Name','Price Trajectories old model')
plot(price2(1:T-1,:));
xlabel('Time')
ylabel('Price Dynamics')
legend(s)