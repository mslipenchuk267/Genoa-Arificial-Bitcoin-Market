function [p] = price_formation(marketPriceLast)
% this function balances supply and demand to determine the current market
% price from the previous market prices
% INPUT: the price in period t-1
% OUTPUT: the price in period t

% Price Formation
pLower = 0;
pUpper = 10*marketPriceLast;

% check whether demand f(pLower)>g(pLower) supply AND f(pUpper)<g(pUpper) 
% at beginning. Exit with old price if not.
[f1,g1] = supply_demand(pLower);
[f2,g2] = supply_demand(pUpper);
if f1 <= g1
    p = 0;
elseif f2>=g2
    p = 10 * marketPriceLast;
else
    pTest = (pUpper+pLower)/2;
    [f,g] = supply_demand(pTest);
    while((pUpper-pLower)>marketPriceLast/1000 && f~=g)
        pTest = (pUpper+pLower)/2;
        [f,g] = supply_demand(pTest);
        if f>g
            pLower=pTest;
        else
            pUpper=pTest;
        end
    end
    p = pTest;
end
end