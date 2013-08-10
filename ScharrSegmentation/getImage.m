function [filename, imOriginal] = getImage()
% [filename, imOriginal] = getImage()
% function takes no arguments.
% brings up a user interface to select a single *.tif file
% returns the path and the original image in uint16 format

    [imgname, path] = uigetfile('*.tif','Select an image to segment');
    filename = [path imgname];
    imOriginal = imread(filename);
    
end