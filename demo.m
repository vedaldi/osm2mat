% Load an OSM file as a MATLAB structure MAP
map = loadosm('oxford.osm') ;

% Plot highways, buildings, and other lines
figure(1) ; clf ; hold on ; grid on ;
hw = find([map.ways.isHighway]) ;
bl = find([map.ways.isBuilding]) ;
ot = setdiff(1:numel(map.ways), [hw, bl]) ;

lines=osmgetlines(map, hw) ; plot(lines(2,:), lines(1,:), 'b-', 'linewidth', 1.5) ;
lines=osmgetlines(map, bl) ; plot(lines(2,:), lines(1,:), 'g-', 'linewidth', 0.75) ;
lines=osmgetlines(map, ot) ; plot(lines(2,:), lines(1,:), 'k-', 'linewidth', 0.5) ;

xlabel('longitude') ;
xlabel('latitude') ;
legend('highways', 'building', 'other') ; title('OSM in MATLAB') ;
axis equal ; box on ;