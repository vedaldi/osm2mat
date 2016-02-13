function xy = geo2xy(geo)
%GEO2XY Convert (LAT,LON) pairs into XY pairs using the Web Mercator projection
%   XY = GEO2XY(GEO) takes a matrix of latitude GEO(1,:) and
%   longitude GEO(2,:) values and returns the Web Mercator projection
%   XY (aka Google Maps). The world is mapped into the square [0,
%   256]x[0,256], provided that latitude is cut off at 85.051129
%   degrees.
%
%   GEO is supposed to be in degrees (not radians). Note that the Y
%   coordinate grows from north to south; this is to make XY match
%   pixel coordinates (0,0) is the up-left corner of the image.

geo = (pi/180) * geo ;
xy = (128/pi) * [pi + geo(2,:);  pi - log(tan(pi/4 + geo(1,:)/2))] ;
