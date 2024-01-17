function validate_results(population,nodes,V_array)
    [n,m] = size(population);
    for j = 1:m
        V = V_array(j);
        for i = 1:n
            for k = 1:length(nodes)
                ending_rodes_indexes = nodes{k}{1};
                if ending_rodes_indexes == 0
                    sum_ending = V;
                else
                    sum_ending = sum(population{i,j}{1,1}(ending_rodes_indexes));
                end
                starting_rodes_indexes = nodes{k}{2};
                if starting_rodes_indexes == 0
                    sum_starting = V;
                else
                    sum_starting = sum(population{i,j}{1,1}(starting_rodes_indexes));
                end    
                fprintf('Number of Generation %d, Number of Gene %d, Number of node %d, Sum coming is %f, Sum leaving is %f. Restrictions Fullfilled : %d\n',j,i,k,sum_ending,sum_starting,sum_ending==sum_starting)
            end
        end
    end
    disp('Note that some number are completely the same, but due a very small change due to system accuracy, they are not seen as equals.')

end
