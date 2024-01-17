function [offsprings_values,parents_values,offsprings]=nextGen_creation(T,offsprings,t_array,c_array,a_array,population,population_size,currentGen)
    % after Crossover and Mutation the Parents variable has become the children
    % variable -> the next Generation
    offsprings_values = zeros(1,population_size);
    parents_values = zeros(1,population_size);
    for i = 1: population_size
        offsprings{i}{1,2} = fitness_value(T,offsprings{i}{1,1},t_array,c_array,a_array); 
        offsprings_values(1,i) = offsprings{i}{1,2};
        parents_values(1,i) = population{i,currentGen}{1,2};
    end
end