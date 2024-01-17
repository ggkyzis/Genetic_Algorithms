function [parents] = crossover(threshold,parents,nodes,c_array,population_size,V)
    % CROSSOVER -> Divide the population into 2 halfs
    % One Point Crossover:In this one-point crossover,
    % a random crossover point is selected 
    % and the tails of its two parents are swapped to get new off-springs.
    % the possibility of crossover will be p_c
    crossover_threshold = threshold;
    num_of_pairs = floor(population_size/2);
    median_element = ceil(population_size/2);
    for i = 1:num_of_pairs
        p_c = rand();
        if p_c <= crossover_threshold
            % the random index which will be the separating point
            random_split_index = randi(16);
            gene1 = NaN(length(c_array),1);
            gene2 = NaN(length(c_array),1);
            for j=1:random_split_index
                gene1(j,1) = parents{i}{1,1}(j);
                gene2(j,1) = parents{i + median_element}{1,1}(j);
            end
            for j=(random_split_index+1):17
                gene1(j,1) = parents{i + median_element}{1,1}(j);
                gene2(j,1) = parents{i}{1,1}(j);
            end
            % now in the gene1 we must check that after the
            % random_split_index the restrictions are fullfilled
            gene1 = transpose(gene1);
            gene2 = transpose(gene2);
            crossover_gene1 = after_crossover_restrictions(gene1,parents,i,nodes,c_array,V);
            parents{i}{1,1} = crossover_gene1;
            crossover_gene2 = after_crossover_restrictions(gene2,parents,i+median_element,nodes,c_array,V);
            parents{i + median_element}{1,1} = crossover_gene2;
        end
    end
end


function [crossover_gene]=after_crossover_restrictions(gene,parents,index,nodes,c_array,V)
    crossover_gene = zeros(length(c_array),1);
    % flag that goes to 1 if all requirements are met for all the streets
    for k = 1:(length(nodes)-1)
        ending_roads = nodes{k}{1};
        if ending_roads == 0
            sum_coming = V;
        else
            sum_coming = sum(crossover_gene(ending_roads));
        end
        starting_roads = nodes{k}{2};
        current_sum = 0;
        if length(starting_roads) ~=1
            for j = 1 :(length(starting_roads)-1)
                starting_road_number = starting_roads(j);
                crossover_gene(starting_road_number) = gene(starting_road_number);
                current_sum = current_sum + crossover_gene(starting_road_number);
            end
        end
        crossover_gene(starting_roads(length(starting_roads))) = sum_coming - current_sum;
        flag = 0;
        if crossover_gene(starting_roads(length(starting_roads)))<=c_array(starting_roads(length(starting_roads)))
            if crossover_gene(starting_roads(length(starting_roads))) >=0
                flag = 1;
            end
        end
        if flag==0
            break
        end
    end
    if flag==0
        crossover_gene = parents{index}{1,1};
    else
        fprintf('\t \t \t \t \t CROSSOVER\n')
    end
end