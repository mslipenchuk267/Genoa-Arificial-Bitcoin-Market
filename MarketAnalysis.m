% To systematically compare the new model (CA opinions) with the old market 
% and to interpret results The analysis is conducted over different model 
% sizes (i.e. number of agents)
clear all
close all

clc
tic

% Enabling Features of the Markets
trading = 1;   %trading
historicVola = 1;   %historic vola
opinionPropagation = 1;   %opinion prop
short = 1; %allows shortselling
% simulation periods
T=500;
% number of agents
start = 400;
finish = 80;
steps = -
40;
loops = (finish-
start)/steps+1;
irrel = 0;
threshold = 50; % non-
plotting values
% initializing output variables
volume=zeros(T,loops);
vola=zeros(T,loops);
clusters=zeros(T,loops);
shortsales=zeros(T,loops);
price=zeros(T,loops);
volume2=zeros(T,loops);
vola2=zeros(T,loops);
clusters2=zeros(T,loops);
shortsales2=zeros(T,loops);
price2=zeros(T,loops);
voladays=10;
%Main Loop 
figure('Name',
'new versus old model')
for d=start:steps:finishi=(d-start)/steps+1;
    % running both models with d number of agents
    [volume(:,i),vola(:,i),clusters(:,i),shortsales(:,i),price(:,i)]=market('new',trading,historicVola,opinionPropagation,short,T,d,0);
    [volume2(:,i),vola2(:,i),clusters2(:,i),shortsales2(:,i),price2(:,i)]=market('old',trading,historicVola,opinionPropagation,short,T,d,0);
    %plotting volatility outputs
    Amax=max(max(vola));
    Bmax=max(max(vola2));
    scale=max(Amax,Bmax)*100*1.2;
    subplot(1,2,1)
    title('new model')
    hold 
    on
    plot(vola(voladays:T,:)*100)
    axis([voladays,T,0,scale])
    s{i} = sprintf('Agents %i', d);   
    legend(s)
    xlabel('Time')
    ylabel('Daily volatility in %')
    subplot(1,2,2)
    title('old model')
    hold on
    plot(vola2(voladays:T,:)*100)
    axis([voladays,T,0,scale])
    legend(s)
    xlabel('Time')
    % counting the non-plotting values
    if   d<threshold
        irrel=irrel+1;
    end
    pause(0.05)
end

legend(s)
hold off

% creating a volatility surface with the new model data
figure('Name','Volatility Surface: new model')
surf(vola(voladays:T,1:loops-irrel)*100,'DisplayName','Volatility Surface')
title('Volatility Surface w.r.t. Agents: new model')
xlabel('Agent-Loop')
ylabel('Time')
zlabel('Daily volatility in %')

% creating a volatility surface with the old model data
figure('Name','Volatility Surface: old model')
surf(vola2(voladays:T,1:loops-irrel)*100,'DisplayName','Volatility Surface')
title('Volatility Surface w.r.t. Agents: old model')
xlabel('Agent-Loop')
ylabel('Time')
zlabel('Daily volatility in %')

% displaying the average volatility in the two markets
figure('Name','Average Market Volatility')
plot(start:steps:finish,nanmean(vola)*100,start:steps:finish,nanmean(vola2)*100)
title('Average Market Volatility w.r.t. Agents of the two models')
legend('new model','old model');
xlabel('Agents')
ylabel('Daily volatility in %')

toc
