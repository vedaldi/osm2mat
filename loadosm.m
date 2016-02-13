function map = loadosm(filePath)
%LOADOSM  Load an OSM file in MATLAB
%   MAP = LOADOSM(FILEPATH) loads the specified file as a MATLAB
%   structure. The structure `map` contains:
%
%   * `map.nodes`: the map nodes  with:
%      * `id`: a numerical ID (unit64).
%      * `lat`: latitude (double).
%      * `lon`: longitude (double).
%   * `map.ways`: the map ways with:
%      * `id`: a numerical ID (unit64).
%      * `nds`: a list of node IDs (uint64).
%      * `tags`: a Nx2 cell array of pairs of strings key=value.
%
%   The structure contains also the following additional
%   convenience fields derived from the others:
%
%   * `map.ways.points`: a 2xN array of points (LAT,LON).
%   * `map.ways.isHighway`: a boolean.
%   * `map.ways.isBuilding`: a boolean.

opts.verbose = 0 ;

xml = xmlread(filePath) ;
map = parseRoot(opts, xml) ;

% for convenience, add an explicit list of point coordinates to each way
nodeIndex = containers.Map([map.nodes.id], 1:numel(map.nodes), 'UniformValues', true) ;
for w = 1:numel(map.ways)
  k = nodeIndex.values(num2cell(map.ways(w).nds)) ;
  k = horzcat(k{:}) ;
  map.ways(w).points = ...
    [[map.nodes(k).lat] ; [map.nodes(k).lon]] ; ;
end

% for convenience, extract some of the tags as struct fields
for w = 1:numel(map.ways)
  tags = map.ways(w).tags ;
  map.ways(w).isHighway = any(strcmp(tags(:), 'highway')) ;
  map.ways(w).isBuilding = any(strcmp(tags(:), 'building')) ;
end

% -------------------------------------------------------------------------
function map = parseRoot(opts, xml)
% -------------------------------------------------------------------------

map.nodes = {} ;
map.ways = {} ;

children = xml.getChildNodes() ;
for c = 1:children.getLength() ;
  child = children.item(c-1) ;
  name = char(child.getNodeName()) ;
  if opts.verbose > 1
    fprintf('element ''%s''\n', name) ;
  end
  switch name
    case 'osm', map = parseOsm(opts, map, child) ;
  end
end
map.nodes = cat(2, map.nodes{:}) ;
map.ways = cat(2, map.ways{:}) ;

% -------------------------------------------------------------------------
function map = parseOsm(opts, map, xml)
% -------------------------------------------------------------------------

children = xml.getChildNodes() ;
for c = 1:children.getLength() ;
  child = children.item(c-1) ;
  name = char(child.getNodeName()) ;
  if opts.verbose > 1
    fprintf('  e- ''%s''\n', name) ;
  end
  switch name
    case 'node', map = parseNode(opts, map, child) ;
    case 'way', map = parseWay(opts, map, child) ; 
  end
end

% -------------------------------------------------------------------------
function map = parseNode(opts, map, xml)
% -------------------------------------------------------------------------

attrs = xml.getAttributes() ;
for a = 1:attrs.getLength() ;
  attr = attrs.item(a-1) ;
  name = char(attr.getName()) ;
  value = char(attr.getValue()) ;
  if opts.verbose > 2
    fprintf('     a- ''%s''=''%s''\n', name, value) ;
  end
  switch name
    case 'id', node.id = sscanf(value, '%lu') ;
    case 'lat', node.lat = sscanf(value, '%f') ;
    case 'lon', node.lon = sscanf(value, '%f') ;
  end
end
map.nodes{end+1} = node ;

% -------------------------------------------------------------------------
function map = parseWay(opts, map, xml)
% -------------------------------------------------------------------------

way.id = zeros(1,1,'uint64') ;
way.nds = zeros(1,0,'uint64') ; ;
way.tags = {} ;
attrs = xml.getAttributes() ;
for a = 1:attrs.getLength() ;
  attr = attrs.item(a-1) ;
  name = char(attr.getName()) ;
  value = char(attr.getValue()) ;
  if opts.verbose > 2
    fprintf('     a- ''%s''=''%s''\n', name, value) ;
  end
  switch name
    case 'id', way.id = sscanf(value,'%lu') ;
  end
end
children = xml.getChildNodes() ;
for c = 1:children.getLength() ;
  child = children.item(c-1) ;
  name = char(child.getNodeName()) ;
  if opts.verbose > 1
    fprintf('  e- ''%s''\n', name) ;
  end
  switch name
    case 'nd', way.nds(end+1) = parseNd(opts, child) ;
    case 'tag', way.tags{end+1} = parseTag(opts, child) ;
  end
end
way.tags = cat(1, way.tags{:}) ;
map.ways{end+1} = way ;

% -------------------------------------------------------------------------
function refs = parseNd(opts, child)
% -------------------------------------------------------------------------

attrs = child.getAttributes() ;
refs = zeros(1,0,'uint64') ;
for a = 1:attrs.getLength() ;
  attr = attrs.item(a-1) ;
  name = char(attr.getName()) ;
  value = char(attr.getValue()) ;
  if opts.verbose > 2
    fprintf('       a- ''%s''=''%s''\n', name, value) ;
  end
  switch name
    case 'ref', refs(end+1) = sscanf(value,'%lu') ;
  end
end

% -------------------------------------------------------------------------
function tag = parseTag(opts, child)
% -------------------------------------------------------------------------

attrs = child.getAttributes() ;
tag = cell(1,2) ;
for a = 1:attrs.getLength() ;
  attr = attrs.item(a-1) ;
  name = char(attr.getName()) ;
  value = char(attr.getValue()) ;
  if opts.verbose > 2
    fprintf('       a-''%s''=''%s''\n', name, value) ;
  end
  switch name
    case 'k', tag{1} = value ;
    case 'v', tag{2} = value ;
  end
end
