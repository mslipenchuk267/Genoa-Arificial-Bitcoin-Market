function [buyProb,sum] = opinion(Cells)
% identifying clusters in Cellular Automaton output and randomly resetting 
% buy Probability of agents in that cluster
% INPUT: a n -by-  n matrix coming from the CA output with
% n*n=N, the total number of agents in the market model

% OUTPUT: a vector of length N with buy probabilites for all agents /buyProb) as
% well as the number of agents in clusters (sum) 

% number of agents in the model
N = length(Cells)^2;

% indentifying the clusters in the CA
% output and counting the number of clusters 
[Cluster,numb] = bwlabel(Cells);

buyProb=ones(N,1)/2;
sum = 0;
% extracting each cluster of agents and its sizes
for i = 1:numb    
    %returning the vector of cluster members
    a = find(Cluster == i);
    size = length(a);
    sum = sum + size;
    % randomly allocating buyers/sellers
    if rand(1) < 0.5
        buy = 0;
    else
        buy = 1;
    end
          
    for k=1:size
        buyProb(a(k))  = buy;
    end
end

end 