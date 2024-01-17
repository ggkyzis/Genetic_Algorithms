function [parents]=x_tournament_selection(x,population,population_size,currentGen)
    %% SELECTION OF PARENTS FOR REPRODUCTION
    % X-Tournament Selection
    X=x;
    parent_count = 1;
    parents = cell(population_size,1);
    while parent_count<=population_size
        rand_indexes = randi(population_size,X,1);
        minimum_value = inf;
        minimum_index = 0;
        for i = 1:X
            elite_parent_index = rand_indexes(i);
            elite_parent_value = population{elite_parent_index,currentGen}{1,2};
            if elite_parent_value < minimum_value
                minimum_value = elite_parent_value;
                minimum_index = elite_parent_index;
            end
        end
       % in case all minimum_values are equal to Inf
       % we perform the loop again for the same parent_count
       if minimum_index == 0
           continue
       end
       parents{parent_count}{1,1} = population{minimum_index,currentGen}{1,1};
       parent_count = parent_count + 1 ;
    end
end
