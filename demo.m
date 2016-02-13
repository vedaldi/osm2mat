% Load an OSM file as a MATLAB structure MAP
map = loadosm('oxford.osm') ;

% Plot highways, buildings, and other lines
figure(1) ; clf ; hold on ; grid on ;
hw = find([map.ways.isHighway]) ;
bl = find([map.ways.isBuilding]) ;
ot = setdiff(1:numel(map.ways), [hw, bl]) ;

lines=osmgetlines(map, hw) ; plot(lines(1,:), lines(2,:), 'b-', 'linewidth', 2) ;
lines=osmgetlines(map, bl) ; plot(lines(1,:), lines(2,:), 'g-', 'linewidth', 1) ;
lines=osmgetlines(map, ot) ; plot(lines(1,:), lines(2,:), 'k-', 'linewidth', 1) ;

axis equal ; legend('highways', 'building', 'other') ;