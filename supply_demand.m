function [f,g] = supply_demand(p)
%This function determines the supply and demand for a given market price
% INPUT: the current market price p
% OUTPUT: the aggregate demand and aggregate supply in the market model
global agent
global N

% Supply/Demand values for given price p
f = 0;
g = 0;
for n = 1:N
    % Buy orders if agent is buyer and reservation price >= marketprice
    if (agent(n).buyUpperLimit>=p) && (agent(n).isBuyer)
        f = f + agent(n).buyQuant;
    % Sell orders if agent is seller and reservation price <= marketprice
    elseif (agent(n).sellLowerLimit<=p) && (agent(n).isSeller)
        g = g + agent(n).sellQuant;
    end
end
end