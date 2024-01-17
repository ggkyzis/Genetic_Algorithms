
function [offsprings]=mutation(threshold,population,offsprings,nodes,population_size,c_array,currentGen,V)
    %% MUTATION
    % For the change(Dx) in the genes, we will use a random distribution with zero
    % mean and variance according to the variance of the specific value x_i of
    % in each population.
    %computing the variances for each x_i 
    sigmas = calculate_sigmas(population,population_size,currentGen);
    mutation_threshold = threshold;
    % instead of performing mutation by altering all the x_i directly
    % we firstly alter the x_1 based on the standard deviation of x_i at
    % the population. after this we adjust all the other x_i values. this
    % is done in order to slightly change the values in each mutation and
    % continue to fullfil the restrictions
    for i = 1 : population_size
        p_m = rand();
        if p_m < mutation_threshold
            % In mutation we alter all the values soo....
            mutated_genes = zeros(length(c_array),1);
            % flag that goes to 1 if all requirements are met for all the streets
            flag = 0;
            while flag == 0
                mutation_dx = normrnd(zeros(17,1),sigmas);
                for k = 1:(length(nodes)-1)
                    ending_roads = nodes{k}{1};
                    if ending_roads == 0
                        sum_coming = V;
                    else
                        sum_coming = sum(mutated_genes(ending_roads));
                    end
                    starting_roads = nodes{k}{2};
                    current_sum = 0;
                    if length(starting_roads) ~=1
                        for j = 1 :(length(starting_roads)-1)
                            starting_road_number = starting_roads(j);
                            mutated_genes(starting_road_number) = max(0,min(offsprings{i}{1,1}(starting_road_number) + mutation_dx(starting_road_number),c_array(starting_road_number)));
                            current_sum = current_sum + mutated_genes(starting_road_number);
                        end
                    end
                    mutated_genes(starting_roads(length(starting_roads))) = sum_coming - current_sum;
                    flag = 0;
                    if mutated_genes(starting_roads(length(starting_roads)))<=c_array(starting_roads(length(starting_roads)))
                        if mutated_genes(starting_roads(length(starting_roads))) >=0
                            flag = 1;
                        end
                    end
                    if flag==0    
                        break
                    end
                end
            end
        fprintf('\t \t \t \t \t MUTATION\n')
        offsprings{i}{1,1}(:) = mutated_genes(:);
        end
    end
end

function [sigmas] =calculate_sigmas(population,population_size,currentGen)
    variances = zeros(population_size,17);
    for member = 1:population_size
        variances(member,:) = transpose(population{member,currentGen}{1,1});
    end
    variances = var(variances);
    sigmas = sqrt(variances)';
end