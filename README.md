# OpenStreetMap OSM files to MATLAB

This is a very basic importer for OSM files in MATLAB. See `demo.m`
for usage.

The utiltiy does not extract all the information from these files
(notably, relations are missing), but it is good enough if the goal is
to get the road graph. On the plus side, it is so simple that it
should be easy to customize.

## Example usage

```matlab
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
```
