function [tradeVolume,vola1d,Cluster,shortsale,price] = market(version,trade,histVola,opinionProp,short,T,agents,p)
% MARKET
%   Prototyping Version: 1/10,000 size of real Market
%   Final Version:   1/100 size of real Market
%   Validation Time Span: | Speculation Time Span:
%   1/1/2016 - 1/1/2017   | /1/2017 - 1/1/2018
%
% This function simulatates an agent-based financial market
% INPUTS are: 'new' or 'old' market model (as a string); activate (1) or
% deactivate (0) the model features: trading, historic volatility, opinion
% propagation and shortselling; number of timeperiods T to be simulated and
% number of agents in the model; finally 0 or 1 for graphical plots
% sample inputs are: market('new',1,1,1,1,500,400,1);
% OUTPUTS are: trading Volume in the market, the daily volatility, the
% number of agents in clusters, number of shortsales and the price proces

% Starts stop watch timer for performance
tic

% Model Features
TRADING = trade;
HISTORICAL_VOLATILITY = histVola;
OPINION_PROPAGATION_CLUSTERS = opinionProp;
SHORTSELLING=short;
PLOTS=p;
if strcmp(version,'new') 
    NEWMARKET=1; 
else 
    NEWMARKET=0;
end

% Parameter Initialization
global agent;
global t;
global globalBuyProb; % Remove before submit
global globalBuyProbRandom; % buy probability of 'random' investor 
global globalBuyProbChartist % buy probability of 'chartist' investor
global clusterPairProbability;
global clusterActivateProbability;
global activatedClusterSize;
global clusters;
global buySigmaK;
global sellSigmaK;
global timeSteps;
global N;
global stockPrice;
timeSteps = T;
N = agents;
PercentageDone = 0;

% Global market parameters
stockPrice = ones(timeSteps,1) * ;
activatedClusterSize = zeros(timeSteps,1);
clusters = zeros(N,1); % maximum number of possible clusters: N/2
clusterPairProbability = 0.0001;
clusterActivateProbability = 0.2;
tradeVolume = zeros(timeSteps,1);
vola1d = zeros(timeSteps,1);
shortsale = zeros(timeSteps,1);

% set global agent parameters
% 2 types of buy probs to support hetero-investors
globalBuyProbRandom = .1;
globalBuyProbChartist = .5;

% Buying and selling variables
sellMu = 1.02;
sellSigmaK = .01; % was 3.5
buyMu = 1.02;
buySigmaK = .01; % was 3.5
shortSigma = 0.2;

% Initializing the heterogenous agents individual parameters
prob_random = .7; % No need for prob_chartist as seen below.
investorSplit = rand(N); % Assign rand 0-1 to each investors index
for n = 1:N
    if investorSplit(n) <= prob_random % Investor becomes a random trader
        agent(n).cash = 1000;
        agent(n).assets = 1000;
        agent(n).volatSigma = 0.02;
        agent(n).volatTimeInt = 50;
        agent(n).buyProb = globalBuyProbRandom;
        agent(n).isBuyer = 0;
        agent(n).isSeller = 0;
        agent(n).buyCash = 0;
        agent(n).buyQuant = 0;
        agent(n).buyUpperLimit = 0;
        agent(n).sellQuant = 0;
        agent(n).sellLowerLimit = inf;
        agent(n).cluster = 0;
    elseif investorSplit(n) > prob_random % Investor becomes a charist
        agent(n).cash = 1000;
        agent(n).assets = 1000;
        agent(n).volatSigma = 0.02;
        agent(n).volatTimeInt = 50;
        agent(n).buyProb = globalBuyProbChartist;
        agent(n).isBuyer = 0;
        agent(n).isSeller = 0;
        agent(n).buyCash = 0;
        agent(n).buyQuant = 0;
        agent(n).buyUpperLimit = 0;
        agent(n).sellQuant = 0;
        agent(n).sellLowerLimit = inf;
        agent(n).cluster = 0; % Member of cluster = 1 & else = 0
    end
end

% Run the cellular automaton (CA): 
% if opinion propagatian is activated in the new model
if (OPINION_PROPAGATION_CLUSTERS && NEWMARKET==1)
    Cells=automaton2(N,timeSteps,PLOTS);
end

% Main Loop
for t = 1:timeSteps
    
    % Opinion Propagation in the old model
    if   OPINION_PROPAGATION_CLUSTERS && NEWMARKET==0
        opinion_prop()
    end
    
    % Opinions Propagation in the new model
    if OPINION_PROPAGATION_CLUSTERS && NEWMARKET==1
        % passing the CA output to the opinion function, which returns a vector
        % of reset buy probabilites for all agents
        [buyProb,activatedClusterSize(t)]=opinion(Cells(:,:,t));
        for n = 1:length(buyProb)
            agent(n).buyProb=buyProb(n);
        end
    end
    
    for n = 1:N
        % Agent is Buyer or Seller during this time-step?
        if rand(1)<agent(n).buyProb 
            %randomly choosing buyers
            agent(n).isSeller = 0;
            agent(n).isBuyer = 1;
            % buyCash update: if short-selling is activated, then exceedance of current
            % cash account is allowed (credit buying); else short-selling constraint
            if SHORTSELLING
                agent(n).buyCash = abs(normrnd(0.5,shortSigma))*agent(n).cash;
            else 
                agent(n).buyCash = rand(1)*agent(n).cash;
            end
        else 
            %rest are sellers
            agent(n).isSeller = 1;
            agent(n).isBuyer = 0;
            % sellQuant update: if short-selling is activated, then exceedance of
            % current asset level is allowed; else short-selling constraint
            if SHORTSELLING
                agent(n).sellQuant = round(abs(normrnd(0.5,shortSigma))*agent(n).assets);
            else 
                agent(n).sellQuant = round(rand(1)*agent(n).assets); 
            end
            % counting incidenct of short-selling
            if agent(n).sellQuant>agent(n).assets
                shortsale(t)=shortsale(t)+1;
            end
        end
        % Historial Volatility
        if HISTORICAL_VOLATILITY
            hist_volat(n)
        end
        % Agent buy or sell parameters
        % Implement MC hypo here??
        if (agent(n).isBuyer == 1)
            agent(n).buyUpperLimit = stockPrice(t)*(normrnd(buyMu,agent(n).volatSigma));
            agent(n).buyQuant = round(agent(n).buyCash/agent(n).buyUpperLimit);
        else
            agent(n).sellLowerLimit = stockPrice(t)/abs(normrnd(sellMu,agent(n).volatSigma));
        end
    end
    % New Market Price
    stockPrice(t+1) = price_formation(stockPrice(t));
    % Trading
    if TRADING
        tradeVolume(t)=trading();
    end
    
    % Miners given bitcoin rewards after day of trading.
    
    
    if PLOTS
        if PercentageDone ~= round(100*(t/timeSteps))
            PercentageDone = round(100*(t/timeSteps));
        end
    end
end