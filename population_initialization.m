function [population]= population_initialization(nodes,population_size,maxGen,T,t_array,c_array,a_array,currentGen,V)
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
    
    population = cell(population_size,maxGen);
    for count = 1:population_size
        genes = zeros(length(c_array),1);
        % flag that goes to 1 if all requirements are met for all the streets
        flag = 0;
        while flag == 0
            for i = 1:(length(nodes)-1) %the last node is the exit node, everything has been initialized
                ending_roads = nodes{i}{1};
                if ending_roads == 0
                    sum_coming = V;
                else
                    sum_coming = sum(genes(ending_roads));
                end
                starting_roads = nodes{i}{2};
                current_sum = 0;
                if length(starting_roads) ~=1
                   for j = 1 :(length(starting_roads)-1)
                       starting_road_number = starting_roads(j);
                       genes(starting_road_number) = 0 + rand* min(c_array(starting_road_number),sum_coming);
                       current_sum = current_sum + genes(starting_road_number);
                    end
                end
                genes(starting_roads(length(starting_roads))) = sum_coming - current_sum;
                flag = 0;
                if genes(starting_roads(length(starting_roads)))<=c_array(starting_roads(length(starting_roads)))
                    if genes(starting_roads(length(starting_roads))) >=0
                       flag = 1;
                    end
                end
                if flag==0    
                    break
                end
            end
        end
        population{count,currentGen}{1,1} = genes;
        population{count,currentGen}{1,2} = fitness_value(T,genes,t_array,c_array,a_array);
    end
end

