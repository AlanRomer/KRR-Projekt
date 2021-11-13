%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Grid size X: 			    5
% Grid size Y: 			    3
% Number of Nodes:                  13
% Number of Highway Nodes:          0
% Number of Robots:                 2
% Number of Shelves:                2
% Number of Picking Stations:       0
% Number of Products:               2
% Number of Product Units in Total: 2
% Number of Orders:                 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#program base.

%init
init(object(node, 6), value(at, (1, 2))).
init(object(node, 2), value(at, (2, 1))).
init(object(node, 3), value(at, (3, 1))).
init(object(node, 8), value(at, (3, 2))).
init(object(node, 13), value(at, (3, 3))).
init(object(node, 7), value(at, (2, 2))).
init(object(node, 12), value(at, (2, 3))).
init(object(node, 11), value(at, (1, 3))).
init(object(node, 5), value(at, (5, 1))).
init(object(node, 10), value(at, (5, 2))).
init(object(node, 15), value(at, (5, 3))).
init(object(node, 9), value(at, (4, 2))).
init(object(node, 1), value(at, (1, 1))).
init(object(order,1),value(line,(1,1))).
init(object(order,2),value(line,(2,1))).
init(object(product,1),value(on,(1,1))).
init(object(product,2),value(on,(2,1))).
init(object(robot,1),value(at,(1,1))).
init(object(robot,2),value(at,(1,3))).
init(object(shelf,1), value(at,(5,1))).
init(object(shelf,2), value(at,(5,3))).
