function xy = geo2xy(geo, center)
%GEO2XY  Convert (LAT,LON) pairs in XY pairs using the Web Mercator projection
%   XY = GEO2XY(GEO) takes a matrix of latitude GEO(1,:) and
%   lognigutde GEO(2,:) values and returns the Web Mercatro projection
%   XY (aka Google Maps). The world is mapped into the square [0,
%   256]x[0,256].
%
%   XY = GEO2XY(GEO, TRUE) centers the projection on the geographical
%   center of the coordinates.

xy = 128/pi * [geo(2,:) + pi; pi - log(tan(pi/4 + geo(1,:)))] ;
