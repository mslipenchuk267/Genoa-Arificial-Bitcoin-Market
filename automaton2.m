function[ClusterDynamics] = automaton2(agents,periods,plot)
%This function uses a stochastic cellular automaton to model cluster
%building amongst all agents over the specified time horizon

tic

%Parameter SetUp: 

% Lines 10-21 - reference
pini = 0.15; % prob. to be in cluster @ initilization or reinitalization 
             % after cluster 'burst'.           
p = 1; % Curbs chances of an agent remaining in cluster, p=1=no impact                 
pr = 1; % Curbs chances of neighbors de-clustering, pr=1=no impact                
pd = 0.6; % Prob. to curb the de-clustering effect of neighbor cells after burst
pn = 0.0003; % level of background noise              
pdest = 0.1; % Prob. for clusters to be destroyed (based on size)

N = round(sqrt(agents));   
T = periods; 

densl = 0.85; % local maximum, allowed cluster density per area              
densg = 0.25; % global maximum, allowed cluster density per area 

PLOTS = plot;

% Line 27-29 - reference
% Initializations
ClusterDynamics = zeros(N,N,T);
Cells = zeros(N+2,N+2);
Cells(2:N+1,2:N+1) = (rand(N,N)<pini);

% Line 34-39 - reference
% Row/column indices set up
up = (1:N);
down = (3:N+2);
center_rows = (2:N+1);
left = (1:N);
right = (3:N+2);
center_cols = (2:N+1);

if PLOTS 
    figure('Name','Agent Cluster Dynamics')
    subplot(1,2,1)
    imagesc(Cells(center_rows,center_cols))
    colormap(gray)
    title('Initial state')
    drawnow;
end

% Clustering Simulation
for i=1:T
    % Line 57-89 - reference
    % Local Cluster Limitations
    
    % Three upper squares:
    % Check if local maximum conditions met: 
    % cell density > allowed cluster density area & random check if there
    % is a probability for the cluster to be 'destroyed' (pdest)
    if sum(sum(Cells(2:round(N/3)+1,2:round(N/3)+1)))... 
            > ((N/3)^2)*densl && rand()<pdest 
        % Local area 'square' is set to random intial condition if burst
        Cells(2:round(N/3)+1,2:round(N/3)+1)=rand(round(N/3),round(N/3))...
            < pini; 
    end
    if sum(sum(Cells(2:round(N/3)+1,round(N/3)+2:round(N/3)*2)+1))...
            > ((N/3)^2)*densl && rand()<pdest
        Cells(2:round(N/3)+1,round(N/3)+2:round(N/3)*2+1)=rand(round(N/3),round(N/3))...
            < pini;
    end
    if sum(sum(Cells(2:round(N/3)+1,round(N/3)*2+2:round(N/3)*3+1)))...
            > ((N/3)^2)*densl && rand()<pdest
        Cells(2:round(N/3)+1,round(N/3)*2+2:round(N/3)*3+1)=rand(round(N/3),round(N/3))...
            < pini;
    end
    
    % Three middle squares:
    if sum(sum(Cells(round(N/3)+2:round(N/3)*2+1,2:round(N/3)+1)))...
            > ((N/3)^2)*densl && rand()<pdest
        Cells(round(N/3)+2:round(N/3)*2+1,2:round(N/3)+1)=rand(round(N/3),round(N/3))...
            < pini;
    end  
    if sum(sum(Cells(round(N/3)+2:round(N/3)*2+1,round(N/3)+2:round(N/3)*2+1)))...
            > ((N/3)^2)*densl && rand()<pdest
        Cells(round(N/3)+2:round(N/3)*2+1,round(N/3)+2:round(N/3)*2+1)=rand(round(N/3),round(N/3))...
            < pini;
    end
    if sum(sum(Cells(round(N/3)+2:round(N/3)*2+1,round(N/3)*2+2:round(N/3)*3+1)))...
            > ((N/3)^2)*densl && rand()<pdest
        Cells(round(N/3)+2:round(N/3)*2+1,round(N/3)*2+2:round(N/3)*3+1)=rand(round(N/3),round(N/3))...
            < pini;
    end
    
    % Three lower squares:  
    if sum(sum(Cells(round(N/3)*2+2:round(N/3)*3+1,2:round(N/3)+1)))...
            > ((N/3)^2)*densl && rand()<pdest
        Cells(round(N/3)*2+2:round(N/3)*3+1,2:round(N/3)+1)=rand(round(N/3),round(N/3))...
            < pini;
    end   
    if sum(sum(Cells(round(N/3)*2+2:round(N/3)*3+1,round(N/3)+2:round(N/3)*2+1)))...
            > ((N/3)^2)*densl && rand()<pdest
        Cells(round(N/3)*2+2:round(N/3)*3+1,round(N/3)+2:round(N/3)*2+1)=rand(round(N/3),round(N/3))...
            < pini;
    end
    if sum(sum(Cells(round(N/3)*2+2:round(N/3)*3+1,round(N/3)*2+2:round(N/3)*3+1)))...
            > ((N/3)^2)*densl && rand()<pdest
        Cells(round(N/3)*2+2:round(N/3)*3+1,round(N/3)*2+2:round(N/3)*3+1)=rand(round(N/3),round(N/3))...
            < pini;
    end  
    
    % Line 93-104 - reference
    % Neighbourhood information storage     
    aga = Cells(up,left);
    agb = Cells(up,center_cols);
    agc = Cells(up,right);
    agd = Cells(center_rows,left);
    age = Cells(center_rows,right);
    agf = Cells(down,left);
    agg = Cells(down,center_cols);
    agh = Cells(down,right);
    ag  = Cells(center_rows,center_cols);
    
    % Automaton clustering rules 
    % 1st part checks clustering conditions, 2nd checks de-clusteing cond.
    Cells(center_rows,center_cols) =... 
        max((((ag==1)&rand(N,N)<p|...
              (agb==1) & (agd==1) & rand(N,N)<pr|... % Upper and Left
              (age==1) & (agg==1) & rand(N,N)<pr|... % Right and Bottom
              (agd==1) & (agg==1) & rand(N,N)<pr|... % Left and Bottom
              (agb==1) & (age==1) & rand(N,N)<pr|... % Upper and right
               rand(N,N)<pn)...       
             -((ag==1) & (aga==1) & (agb==1) & (agd==1) & (agf==1)&...
              (agg==1) & (agc==0) & (age==0) & (agh==0) & rand(N,N)<pd)...
             -((ag==1) & (agb==1) & (agc==1) & (age==1) & (agh==1)&...    
              (agg==1) & (aga==0) & (agd==0) & (agf==0) & rand(N,N)<pd)...
             -((ag==1) & (agd==1) & (aga==1) & (agb==1) & (agc==1)&...    
              (age==1) & (agf==0) & (agg==0) & (agh==0) & rand(N,N)<pd)...
             -((ag==1) & (agd==1) & (agf==1) & (agg==1) & (agh==1)&...     
              (age==1) & (aga==0) & (agb==0) & (agc==0) & rand(N,N)<pd)), zeros(N,N));
    
    % Line 125 - reference 
    % Global Cluster Limitations
    % Tests if the cluster density > allowed cluster density, den If it is this
    % initiates a cluster burst.
    if (sum(sum(Cells)) > (N*N)*densg) && rand()<pdest
        % Agents reset back to random probability for agent to be in a
        % cluster, pini.
        Cells(center_rows,center_cols) = (rand(N,N)<pini);
    end
    
    Cells2 = Cells(center_rows,center_cols);
    ClusterDynamics(:,:,i) = Cells2;
    
    if PLOTS 
        subplot(1,2,2)
        imagesc(Cells2)
        colormap(gray)
        title('Dynamics over time')
        drawnow;
    end
end

toc

end
                             
                             
                             
                             
                             
                             
                             
                             
                             
                             
                             