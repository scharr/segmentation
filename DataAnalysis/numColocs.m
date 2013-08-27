function [perms, counts, permROIs] = numColocs(varargin)
% Takes in ROI mask images of the same size (presumably different channels
% of the same image, and returns all possible permutations of overlapping
% channels
%
% Each argument should be an ROImask image (the image itself, not the filename).
%

    % Load all ROI images into one 3D matrix
    numChan = nargin;
    [col, row] = size(varargin{1});
    ROIs = zeros(col, row, numChan);
    for i = 1:nargin
        ROIs(:,:,i) = varargin{i};
    end

    % Calculate the number of permutations of channels and record them
    numPerm = 2^numChan;
    perms = permM([0 1],numChan);
    
    % Create empty matrix and vector to hold new ROI masks of overlapping 
    % ROIs
    permROIs = zeros(col,row,numPerm);
    counts = zeros(numPerm)';
    
    % Loop through each permutation
    for i = 1:numPerm
        % create all white image to start calculating colocalizations at this permutation
        colocROI = ones(col,row);
        % loop through each channel
        for j = 1:numChan
            % if the permutation at this channel requires colocalization,
            % multipy the colocalization ROI with the coloc ROI and make
            % this the new colocROI. Only pixels that equal 1 in both
            % images will remain 1 (only overlapping parts of ROIs are
            % recorded). 
            if perms(i,j) == 1
                colocROI = colocROI.*ROIs(:,:,j);
            else
                continue
            end
            % add this colocROI to the permROI matrix, count the number of
            % objects that match this permutation, and record both
            permROIs(:,:,i) = colocROI;
            bwcc = bwconncomp(colcROI);
            counts(i) = bwcc.NumObjects;
        end
    end
    
end