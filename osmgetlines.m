function lines = osmgetlines(map, ways)
%OSMGETLINES  Extract lines from selected map ways for plotting
%   LINES = OSMGETLINES(MAP, WAYS) get a set of lines for the
%   specified WAYS for plotting. LINES(1,:) contains the LAT
%   coordinates nad LINES(2,:) the LON coordinates of the points. NaN
%   values break different lines. This data can be fed directly to
%   MATLAB LINE() command for plotting (which is much faster than
%   plotting individual lines).

lines = {map.ways(ways).points} ;
n = numel(lines) ;
breaks = num2cell(NaN(2, n), [1, n]) ;
lines = vertcat(lines, breaks) ;
lines = horzcat(lines{:}) ;
