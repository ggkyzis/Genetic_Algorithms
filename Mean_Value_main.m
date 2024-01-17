clear
clc
close all

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
% Setting Parameters according to the Global Optimization Toolbox through a
% optimoptions item. These parameters will be later used to characterize
% the Optimization Solving Technique.
options = optimoptions('ga','PopulationSize',20,'EliteCount',5,'MaxGenerations',20);

maxGen = options.MaxGenerations;
population_size = options.PopulationSize; 

currentGen = 1;
fval = inf;
fval_historicity = NaN(maxGen,1);
fval_historicity(1,1) = fval;
number_of_elites = options.EliteCount;
x = 3;
crossover_threshold = 0.3;
mutation_threshold = 0.4;
%% Creation of Traffic Network
% The traffic network is characterized by the nodes(cross-ways) and the
% streets. Using this function, a traffic network is created that stores
% for every node, the roads ending at the node and the roads starting from
% that node. These roads are stored by their corresponding indexes.
fprintf('------------------- <strong>Initializing Traffic Network</strong> ----------------------------\n')
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
num_of_implementations = 10;
implementation_results = NaN(num_of_implementations,1);
xi_results = cell(num_of_implementations,1);
for i = 1:num_of_implementations
    V =  V_initial * (0.85 + rand*(1.15 - 0.85));
    currentGen = 1;
    fval = inf;
    fval_historicity = NaN(maxGen,1);
    fval_historicity(1,1) = fval;
    fprintf('------------------- <strong>Initializing Population : V = %1.3f</strong> ---------------------------------\n',V)
    [population] = population_initialization(nodes,population_size,maxGen,T,t_array,c_array,a_array,currentGen,V);
    while currentGen < maxGen && termination_condition(fval_historicity)
        %% SELECTION OF PARENTS FOR REPRODUCTION
        % X-Tournament Selection
        [parents] = x_tournament_selection(x,population,population_size,currentGen); 
        %% CROSSOVER 
        [offsprings] = crossover(crossover_threshold,parents,nodes,c_array,population_size,V);
        %% MUTATION   
        [offsprings] = mutation(mutation_threshold,population,offsprings,nodes,population_size,c_array,currentGen,V);  
        %% POST-PROCESSING
        % After Crossover and Mutation the Parents variable has become the children
        % variable -> the next Generation
        [offsprings_values,parents_values,offsprings] = nextGen_creation(T,offsprings,t_array,c_array,a_array,population,population_size,currentGen);
        %% ELITISM
        [offsprings,fval,index_of_fval] = elitism(number_of_elites,offsprings_values,parents_values,offsprings,population,currentGen);
        %% PREPARATION FOR NEXTGEN
        currentGen = currentGen + 1;
        disp('----------------------------------------------------------------------')
        fprintf('\t \t <strong>Current Generation: %d</strong>\n',currentGen)
        fprintf('In the %d Generation, the min value is %f + %s in the %d individual.\n',currentGen,fval-sum(t_array),char(sum(t_array_s)),index_of_fval)
        population(:,currentGen) = offsprings;
        fval_historicity(currentGen,1) = fval;
    end
    disp('----------------------------------------------------------------------')
    %final_fval = fval - sum(t_array) + sum(t_array_s);
    implementation_results(i,1) = fval - sum(t_array);
    xi_results{i,1} = population{index_of_fval,currentGen}{1,1};
    %% Manual Validation 
    % Manual Validation that all inequalities and equalities are fullfilled 
    % in every single node for every member of our final population
    % The sum arriving and leaving from every node are printed to showcase the
    % validity of the algorithm
    validation_of_results(population,nodes,V);
end
mean_fval =  mean(implementation_results(:));
fprintf('The optimal result of a varying V that takes values in [85,115] (vehicles/min) is %f + %s.\n', mean_fval, char(sum(t_array_s)))