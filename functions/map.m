function map(lat,lon,varargin)

A=imread('world1024.jpg');
% A=imread('tc1lithosphere.png');

imshow(A)

hold on
plot((lon+180)*128/45,(90-lat)*128/45,'y.',varargin{:})
