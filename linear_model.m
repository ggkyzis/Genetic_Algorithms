% fitness_values = load('fitnessvalues.mat');
% fitness_values = fitness_values.implementation_results(1:200);
% genes = load('xis.mat');
% genes = genes.xi_results(1:200);
% 
%vars = {'V' 'x1' 'x2' 'x3' 'x4' 'x5' 'x6' 'x7' 'x8' 'x9' 'x10' 'x11' 'x12' 'x13' 'x14' 'x15' 'x16' 'x17' };
% x = [];
% V = [];
% for i =1:length(genes)
%     helper = genes{i}';
%     x = [x;helper];
%     V = [V ;sum(helper(1:4))];
% end
% data = [V x];
% Table = array2table(data,'VariableNames',vars);
% 
% n = size(Table);
% rows = n(1);
% X = [ones(rows,1) V];
% b = X\x;
V = 93;
[solution] = create_linear_model(V);
validate_the_results_of_linear_model(solution,V);

function [solution] = create_linear_model(V_new)
    V = load('Linear_Model_Vs.mat');
    V = V.V;
    genes = load('Linear_Model_Xis.mat');
    genes = genes.xi_results(1:200);
    y = [];
    for i =1:length(genes)
        helper = genes{i}';
        y = [y;helper];
    end
    vars = {'x1' 'x2' 'x3' 'x4' 'x5' 'x6' 'x7' 'x8' 'x9' 'x10' 'x11' 'x12' 'x13' 'x14' 'x15' 'x16' 'x17' };
    n = length(y);
    X = [ones(n,1) V];
    b = X\y;
    disp(size(b))
    V_est = [1 V_new];
    solution = V_est*b;
    fprintf('\t <strong>For given V = %f, the solution of the traffic network is the following:</strong>\n',V_new)
    Table = array2table(solution,'VariableNames',vars);
    disp(Table)
end

function validate_the_results_of_linear_model(solution,V)
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

end