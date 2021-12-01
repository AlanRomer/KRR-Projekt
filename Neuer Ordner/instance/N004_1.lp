%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Grid size X: 			    5
% Grid size Y: 			    3
% Number of Nodes:                  8
% Number of Highway Nodes:          0
% Number of Robots:                 3
% Number of Shelves:                3
% Number of Picking Stations:       0
% Number of Products:               3
% Number of Product Units in Total: 3
% Number of Orders:                 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#program base.

%init
init(object(node, 3), value(at, (3, 1))).
init(object(node, 8), value(at, (3, 2))).
init(object(node, 13), value(at, (3, 3))).
init(object(node, 7), value(at, (2, 2))).
init(object(node, 5), value(at, (5, 1))).
init(object(node, 10), value(at, (5, 2))).
init(object(node, 15), value(at, (5, 3))).
init(object(node, 9), value(at, (4, 2))).
init(object(order,1),value(line,(1,1))).
init(object(product,1),value(on,(1,1))).
init(object(robot,1), value(at,(3,1))).
init(object(shelf,1), value(at,(5,1))).