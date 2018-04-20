function [Volume] = trading()
% This function is simulating the trading mechanism
% INPUT: none required
%
% OUTPUT: the volume of trades conducted in this period
%
global agent
global t
global N
global stockPrice

% lower bound of stocks to trade
[f,g] = supply_demand(stockPrice(t+1));
Volume = min(f,g);
tradedSell(t) = 0;
tradedBuy(t) = 0;



for n = 1:N
    if agent(n).isSeller == 1
        if stockPrice(t+1)>=agent(n).sellLowerLimit && tradedSell(t)<Volume
            % This seller sells
            numAssetsToSell = min(agent(n).sellQuant, Volume-tradedSell(t));
            agent(n).assets = agent(n).assets-numAssetsToSell;
            tradedSell(t) = tradedSell(t) + numAssetsToSell;
            agent(n).cash = agent(n).cash + (numAssetsToSell * stockPrice(t+1));
        end
    else
        if stockPrice(t+1)<=agent(n).buyUpperLimit && tradedBuy(t)<Volume
            % This buyer buys
            numAssetsToBuy = min(agent(n).buyQuant, Volume-tradedBuy(t));
            agent(n).assets = agent(n).assets+numAssetsToBuy;
            tradedBuy(t) = tradedBuy(t) + numAssetsToBuy;
            totalBuyPrice = numAssetsToBuy * stockPrice(t+1);
            agent(n).cash = agent(n).cash - totalBuyPrice;
        end
    end
end