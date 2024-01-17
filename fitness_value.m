function [evaluation] = fitness_value(T,genes,t_array,c_array,a_array)
    sumT = 0;
    for count = 1:length(c_array)
        if c_array(count) == genes(count)
            sumT = inf;
            break
        end
        sumT = sumT + T(genes(count),a_array(count),c_array(count),t_array(count));
    end
    evaluation = double(sumT);
end
