V = sum(solution(1:4));
nodes =  create_traffic_network();
n =  length(solution);
for i = 1:n
            for k = 1:length(nodes)
                ending_rodes_indexes = nodes{k}{1};
                if ending_rodes_indexes == 0
                    sum_ending = V;
                else
                    sum_ending = sum(solution(ending_rodes_indexes));
                end
                starting_rodes_indexes = nodes{k}{2};
                if starting_rodes_indexes == 0
                    sum_starting = V;
                else
                    sum_starting = sum(solution(starting_rodes_indexes));
                end
                fprintf('Number of node %d. Sum coming is %f. Sum leaving is %f. Restrictions Fullfilled : %d\n',k,sum_ending,sum_starting,(sum_ending==sum_starting))
            end
end