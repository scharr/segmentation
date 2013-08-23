function [ intensities ] = mIntTime(imfname, labROIfname)
%[ output_args ] = mIntTime( input_args )
%   This takes a filename (string) of a time lapse movie of fluorescent calcium
%   signalling in cells, and a corresponding filename of a labeled ROI mask, and calculates the mean
%   intensities of the cells over time.
%   It returns a matrix of mean intensities where each row is an individual
%   cell and each column is one frame.

    tif = readTifStack(imfname);
    labROI = imread(labROIfname);
    dims = size(tif);
    
    if length(dims) == 2
        stats = regionprops(labROI,tif,'MeanIntensity');
        intensities = reshape([stats.MeanIntensity],size(stats));
        
    elseif length(dims) == 3
    
    numImages = dims(3);
    stats = regionprops(labROI,tif,'MeanIntensity');
    intensities = zeros(size(stats),numImages);
    for i = 1:numImages
        intensities(i,:) = (reshape([stats.MeanIntensity],size(stats)));
    end


end

