function [output] = splitChannels(imOriginal, numChannels)
% [varargout] = splitChannels(imOriginal, numChannels)
%   Takes a multipage tiff and separates into different images based on
%   number of channels. Output is a cell array where each cell is a
%   channel.
%   Separated images may be single or multipage
%
%   Channels must be collated: 
%       eg. image #     1, 2, 3, 4, 5, 6, 7, 8, 9 
%           channel #   1, 2, 3, 1, 2, 3, 1, 2, 3
% 
%   imOriginal  :   3D uint16 matrix
%   numChannels :   integer
%   output      :   cell array
%
%   scharr@stanford.edu
%   Aug 15, 2013

    % Make sure that image is a 3D matrix and get the dimensions 
    numDims = length(size(imOriginal));
    dims = size(imOriginal);
    if numDims  == 3
        numSlices = dims(3);
    else
        error('imOriginal must be a 3D matrix')
    end
    
    % Define dimensions of each output image
    numRows = dims(1);
    numCols = dims(2);
    numImages = numSlices/numChannels;
    
    % Go through each output image (one output image per channel)
    % Make an empty 3D matrix for each output image
    % Assign corresponding slice of original image to the temp output image
    % Assign temp output image to output variable
    output = cell(1,numChannels);
    step = numChannels;
    for i = 1:numChannels
        temp = zeros(numRows, numCols, numImages);
        idx = i;
        for j = 1:numImages 
            temp(:,:,j) = imOriginal(:,:,idx);
            idx = idx+step;
        end
        output{i} = temp;
    end
    
end


