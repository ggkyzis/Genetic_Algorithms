%% Initial Comments and Parameters
% In this optimization problem, we are called to minimize the time needed
% for a car to cross our Traffic Network. We takle this problem by
% minimizing the sum of Ti(), where T() is the time needed to pass a certain
% road. By minimizing the total sum of Ti()s for a certain V, we minimize
% the total time, and thus we minimize the average time needed for a car to
% pass the traffic network.
syms x_i a_i c_i t_i
T(x_i,a_i,c_i,t_i) = t_i + a_i * x_i/(1-x_i/c_i);

V_initial = 100;

c_array = [54.13 21.56 34.08 49.19 33.03 21.84 29.96 24.87 47.24 33.97 26.89 32.76 39.98 37.12 53.83 61.65 59.73];

a_array = [1.25 1.25 1.25 1.25 1.25 1.5 1.5 1.5 1.5 1.5 1 1 1 1 1 1 1];

syms t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 positive
t_array_s = [t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17];
% In the following t_array the t_is have been set to 1, a random number, as
% their value will not affect our problem, but only the final result, which
% will be modified to show the t1, t2 etc.
% We use this t_array to improve the speed of our algorithm enabling it to
% work with double numbers insted of syms.
t_array = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];

%% Parameters Setting
options = optimoptions('ga','PopulationSize',5,'MaxGenerations',10);

maxGen = options.MaxGenerations;
population_size = options.PopulationSize; 

currentGen = 1;
fval = inf;

% number used for X-Tournament-Selection Process
x = 3;

crossover_threshold = 0.5;
% Mutation possibility is equal to 1. that is becaused every gene must be
% altered to meet the new V requirements.
mutation_threshold = 1;

% Array to store the values of the volume of Traffic
V_array = NaN(maxGen,1);
V_array(1,1) = V_initial;

%% Creation of Traffic Network
% The traffic network is characterized by the nodes(cross-ways) and the
% streets. Using this function, a traffic network is created that stores
% for every node, the roads ending at the node and the roads starting from
% that node. These roads are stored by their corresponding indexes.
[nodes] = create_traffic_network();

%% Initialization of Population
% In the implemented Optimization technique, a unique process is being
% followed. Instead of assigning random numbers using a penalty function to
% make sure that in each generation the parents that fullfill the
% requirements will continue, we make sure that in the initialization that
% every gene created fullfils the corresponding requirements. This
% implementation is more complex and not so effeciently computingly, but
% demonstrates better results in our problem, as from the 1st generation
% every solution is a feasible one, and thus our Genetic Alorithm can
% search in a wider range of feasible solutions.
[population] = population_initialization(nodes,population_size,maxGen,T,t_array,c_array,a_array,currentGen,V_initial);

while currentGen < maxGen
    disp('----------------------------------------------------------------------')
    fprintf('\t \t <strong>Current Generation %d - Volume of Traffic : %f </strong>\n',currentGen,V_array(currentGen,1))
    % V value may be changed 15% of the starting value
    V =  V_initial * (0.85 + rand*(1.15 - 0.85));
    V_array(currentGen+1,1) = V;
    %% SELECTION OF PARENTS FOR REPRODUCTION
    % X-Tournament Selection
    [parents] = x_tournament_selection(x,population,population_size,currentGen); 
    %% CROSSOVER 
    [offsprings] = crossover(crossover_threshold,parents,nodes,c_array,population_size,V);
    %% MUTATION   
    [offsprings] = mutation(mutation_threshold,population,offsprings,nodes,population_size,c_array,currentGen,V); 
    %% POST-PROCESSGIN
    % After Crossover and Mutation the Parents variable has become the children
    % variable -> the next Generation
    [offsprings_values,parents_values,offsprings] = nextGen_creation(T,offsprings,t_array,c_array,a_array,population,population_size,currentGen);

    %% PREPARATION FOR NEXTGEN
    [fval,index_of_fval] = prepare_for_next_gen(offsprings_values);
    currentGen = currentGen + 1 ;
    fprintf('In the %d Generation, the min value is %f + %s in the %d individual.\n',currentGen,fval-sum(t_array),char(sum(t_array_s)),index_of_fval)
    population(:,currentGen) = offsprings;
    
end
disp('----------------------------------------------------------------------')
final_fval = fval - sum(t_array) + sum(t_array_s);
disp('The value xi for each road is given below.')
vars = {'x1' 'x2' 'x3' 'x4' 'x5' 'x6' 'x7' 'x8' 'x9' 'x10' 'x11' 'x12' 'x13' 'x14' 'x15' 'x16' 'x17'};
Table = array2table(population{index_of_fval,currentGen}{1,1}(:)','VariableNames',vars);
disp(Table)
%% MANUAL VALIDATION OF RESULTS
% Validating that all the restrictions are fullfiled by visual
% representation
validate_results_thema3(population,nodes,V_array);

