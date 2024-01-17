function [offsprings,fval,index_of_fval]=elitism(number_of_elites,offsprings_values,parents_values,offsprings,population,currentGen)
    %% ELITISM
    % here we can perform Elitism as well
    % take the 5 genes with the worst fitness value from children(nextGen) 
    % and replace them with the 5 genes with the best fitness value 
    % from the currentGen
    [~,Imax] = maxk(offsprings_values,number_of_elites);
    [~,Imin] = mink(parents_values,number_of_elites);
    
    for i = 1:number_of_elites
        index_max = Imax(i);
        index_min = Imin(i);
        offsprings{index_max}{1,1} = population{index_min,currentGen}{1,1};
        offsprings{index_max}{1,2} = population{index_min,currentGen}{1,2};
    end
    [fval, index_of_fval] = mink(offsprings_values,1);

end