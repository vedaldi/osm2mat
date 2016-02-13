# OpenStreetMap OSM files to MATLAB

This is a very basic importer for OSM files in MATLAB. See `demo.m`
for usage.

The utiltiy does not extract all the information from these files
(notably, relations are missing), but it is good enough if the goal is
to get the road graph. On the plus side, it is so simple that it
should be easy to customize.

## Example usage

The script

```matlab
% Load an OSM file as a MATLAB structure MAP
map = loadosm('oxford.osm') ;

% Plot highways, buildings, and other lines
figure(1) ; clf ; hold on ; grid on ;
hw = find([map.ways.isHighway]) ;
bl = find([map.ways.isBuilding]) ;
ot = setdiff(1:numel(map.ways), [hw, bl]) ;

lines=geo2xy(osmgetlines(map, hw)) ; plot(lines(1,:), lines(2,:), 'b-', 'linewidth', 1.5) ;
lines=geo2xy(osmgetlines(map, bl)) ; plot(lines(1,:), lines(2,:), 'g-', 'linewidth', 0.75) ;
lines=geo2xy(osmgetlines(map, ot)) ; plot(lines(1,:), lines(2,:), 'k-', 'linewidth', 0.5) ;

set(gca,'ydir','reverse') ;
xlabel('Web Mercator X') ;
ylabel('Web Mercator Y') ;
legend('highways', 'building', 'other') ; title('OSM in MATLAB') ;
axis equal ; box on ;
```

will produce the MATLAB figure below:

![MATLAB figure](oxford.png "MATLAB rendering of the `oxford.osm` file.")
