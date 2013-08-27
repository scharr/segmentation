function [filename, imOriginal] = getImage(prompt)
% [filename, imOriginal] = getImage(prompt)
%
%   prompt  :   string with instructions to user
% 
%   brings up a user interface to select a single *.tif file
%   returns the path and the original image in uint16 format
%   returns all pages of multipage tiffs in a M x N x Z matrix
%
%   scharr@stanford.edu
%   Aug 15, 2013

    % Open GUI to select a .tif image to segment
    %[imgname, path] = uigetfile('*.tif',prompt);
    [imgname, path] = uigetfile();
    filename = [path imgname];
    
    % Get the number of images in the .tif file
    numImages = length(imfinfo(filename));
    % If only one, read that image
    if numImages == 1
        imOriginal = imread(filename);
    % If more than one, open as a 3D matrix
    % Read first slice of image, and then concatinate slices onto 
    % that matrix
    else
%         imOriginal = imread(filename,'Index',1);
%         for i = 2:numImages
%             imOriginal = cat(3, imgtemp, imread(filename,'Index',i));
%         end
        imOriginal = readTifStack(filename);
    end
 
end