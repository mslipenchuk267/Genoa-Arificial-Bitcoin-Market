function [] = opinion_prop()
% This function forms clusters amongst agents by resetting their buy
% probabilites to obtain "sure buyers" and "sure sellers".
% NOTE: This is the opinion propagation mechanism for the OLD model only
global agent
global N
global t
global globalBuyProb
global clusterPairProbability
global clusterActivateProbability
global activatedClusterSize
global clusters
% Pairing: defining which agents belong to a cluster
% Reset last buyProb at first (changed for activated clusters)
agent(N).buyProb = globalBuyProb;
for i = 1:N-1
    % Reset all buyProb to globalBuyProb (changed for activated clusters)
    agent(i).buyProb = globalBuyProb;
    for j = i+1:N
        % form pair with Pa
        if   rand(1)<clusterPairProbability && ...
            ((agent(i).cluster~=agent(j).cluster ) || agent(i).cluster==0)
            % form pair:
            % if i agent is member of cluster:
            % set j agent (and all his cluster members)
            % to i cluster (and free j cluster)
            if agent(i).cluster ~= 0
                if agent(j).cluster ~= 0
                clusters(agent(j).cluster)=0;
                clusterToChange = agent(j).cluster;
                    for k = 1:N
                        if agent(k).cluster == clusterToChange
                            agent(k).cluster = agent(i).cluster;
                        end
                    end
                end
                agent(j).cluster = agent(i).cluster;
            % elseif j agent is member of cluster (and i is not):
            % set i agent to j cluster
            elseif agent(j).cluster ~= 0
                agent(i).cluster = agent(j).cluster;
                % else
                % form new cluster and reserve slot in cluster-
                %arr
            else
                k = 1;
                while clusters(k)~= 0; k=k+1; end
                %if k ~= 1; keyboard; end
                clusters(k) = 1;
                agent(i).cluster = k;
                agent(j).cluster = k;
            end
        end
    end
end

% Cluster activation: activate a single cluster of agents
if rand(1) < clusterActivateProbability
% find nonzero clusters
    activeClusters = find(clusters);
    % random draw of a cluster (first element after randperm)
    randElemNum = randperm(length(activeClusters));
    %activeClusters = randperm(activeClusters);
    % activate the cluster
    if ~isempty(activeClusters)
        if rand(1) < 0.5
            buyProb = 0;
        else
            buyProb = 1;
        end
        tempSum = 0;
        for k = 1:N
            if agent(k).cluster == activeClusters(randElemNum(1))
                agent(k).buyProb = buyProb;
                agent(k).cluster = 0; % leave cluster
                tempSum = tempSum + 1;
            end
        end
        activatedClusterSize(t) = tempSum;
        if activatedClusterSize > 0.95*N
        %keyboard % Too big a cluster was activated
        end
        clusters(activeClusters(randElemNum(1))) = 0; 
        % free cluster
    end
end

end
 