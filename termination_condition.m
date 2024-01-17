
function [continue_flag] = termination_condition(f_val_historicity)
    % This function will be used as a termination condition
    % It is based on the idea that if in the last number_of_previous_Gens
    % generations the fitness value has remained the same, no additional
    % changes will be made and our algorithm should come to an end.
    n = length(f_val_historicity);
    number_of_previousGens = 5;
    if n > number_of_previousGens
       count_of_same_best_fitness_value = 0;
       for i = 1: number_of_previousGens
            if f_val_historicity(end,1) == f_val_historicity(end-i,1)
                count_of_same_best_fitness_value = count_of_same_best_fitness_value + 1;
            else
                continue_flag = true;
                break
            end
       end
       if count_of_same_best_fitness_value == number_of_previousGens
           continue_flag = false;
       end
    else
        continue_flag = true;
    end
end

