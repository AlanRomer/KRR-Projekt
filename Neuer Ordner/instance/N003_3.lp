%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Grid size X:			    5
% Grid size Y: 			    4
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
init(object(node, 15), value(at, (5, 3))).
init(object(node, 12), value(at, (2, 3))).
init(object(node, 14), value(at, (4, 3))).
init(object(node, 11), value(at, (1, 3))).
init(object(node, 18), value(at, (3, 4))).
init(object(order,3),value(line,(3,1))).
init(object(product,3),value(on,(3,1))).
init(object(robot,3), value(at,(3,2))).
init(object(shelf,3), value(at,(1,3))).