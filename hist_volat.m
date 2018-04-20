function [] = hist_volat(n)
% This function resets the nth agent's historic volatility
% INPUT: agent number
%
% OUTPUT: none
%
global agent
global t
global stockPrice
global buySigmaK
global sellSigmaK

%calculate volatSigma
if t==1
    agent(n).volatSigma = 0;
else
    if t < agent(n).volatTimeInt
        stockPricesRecent = stockPrice(1:t);
        logPriceReturn = log( stockPricesRecent(2:end)./stockPricesRecent(1:end-1));
    else
        stockPricesRecent = stockPrice(t-agent(n).volatTimeInt+1:t);
        logPriceReturn = log( stockPricesRecent(2:end)./stockPricesRecent(1:end-1));
    end
    if (agent(n).isBuyer == 1)
        agent(n).volatSigma = buySigmaK * std(logPriceReturn);
    else
        agent(n).volatSigma = sellSigmaK * std(logPriceReturn);
    end
end