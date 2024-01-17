function [nodes] = create_traffic_network()
    %% Creation of Traffic Network
    % The traffic network is characterized by the nodes(cross-ways) and the
    % streets. Using this function, a traffic network is created that stores
    % for every node, the roads ending at the node and the roads starting from
    % that node. These roads are stored by their corresponding indexes.
    
    % restrictions{number_of_node}{1} - roads that end up in the node
    % restrictions{number_of_node}{2} - roads that start from the node
    nodes = cell(9,1);
    nodes{1}{1} = 0;
    nodes{1}{2} = [1 2 3 4];
    nodes{2}{1} = 1;
    nodes{2}{2} = [5 6];
    nodes{3}{1} = 2;
    nodes{3}{2} = [7 8];
    nodes{4}{1} = 4;
    nodes{4}{2} = [9 10];
    nodes{5}{1} = [3 8 9];
    nodes{5}{2} = [11 12 13];
    nodes{6}{1} = [6 7 13];
    nodes{6}{2} = [14 15];
    nodes{7}{1} = [5 14];
    nodes{7}{2} = 16;
    nodes{8}{1} = [10 11];
    nodes{8}{2} = 17;
    nodes{9}{1} = [12 15 16 17];
    nodes{9}{2} = 0;
end

