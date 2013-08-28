function [intensities] = mIntTime(tifstk, labROI)
%[intensities] = mIntTime(tifstk, labROI)
%   This takes a matrix representing a time lapse movie, and a corresponding 
%   labeled ROI mask, and calculates the mean intensities in the ROIs over time.
%   It returns a matrix of mean intensities where each row is an individual
%   cell and each column is one frame.
%
%       tifstk:      uint8 or uint16 3D matrix
%       labROI:      label matrix of ROIs
%       intensities: double 3D matrix 
%
%   scharr@stanford.edu
%   August 26, 2013
%
% (In a previous version, this function took the filenames instead of the
% images themselves. Uncomment the following two lines to revert)
%     tif = readTifStack(imfname);
%     labROI = imread(labROIfname);

    % Takes the dimensions of the tifstack
    dims = size(tifstk);
    
    % If it's only a 2D matrix (1 frame), calculate intensity
    if length(dims) == 2
        stats = regionprops(labROI,tifstk,'MeanIntensity');
        intensities = reshape([stats.MeanIntensity],size(stats));
    % If it's a 3D matrix (many frames), calculate intensity, then create
    % an empty matrix to hold all intensities, then calculate intensities
    % in each ROI for each frame
    elseif length(dims) == 3
        numImages = dims(3);
        stats = regionprops(labROI,tifstk(:,:,1),'MeanIntensity');
        intensities = zeros(length(stats),numImages);  
        for i = 1:numImages
            stats = regionprops(labROI,tifstk(:,:,i),'MeanIntensity');
            intensities(:,i) = (reshape([stats.MeanIntensity],size(stats)));
            disp(i);
        end
    end

end

