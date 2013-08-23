function [imOriginal, sepROI] = fastSegmentation(imgname, path)

% load image
filename = [path imgname];
imOriginal = imread(filename);

% adjust contrast & create black & white image
imContrastAdjusted = imadjust(imOriginal);
level = graythresh(imContrastAdjusted);
BW1 = im2bw(imContrastAdjusted, level);
cleanBW = bwAdjust(BW1, imContrastAdjusted);

% imregionalmax method of getting BW image
% tends to be better for neurosn
% BW2 = imregionalmax(imContrastAdjusted);
% cleanBW = bwAdjust(BW2, imContrastAdjusted);

% try watershed transform
% outlines = uint16(bwperim(cleanBW));
% forground = cleanBW;
% D = bwdist(cleanBW);
% DL = watershed(D);
% background = DL == 0;
% gradmag = imimposemin(outlines, background | forground);
% L = watershed(gradmag);
% cleanBW = im2bw(L);

% edit ROIs
baseROI = editROIs(cleanBW, imContrastAdjusted);

% save ROI
basefilename = filename(1,1:length(filename)-4);
baseROIfilename = sprintf('%s_baseROI.tif',basefilename);
imwrite(baseROI,baseROIfilename);

% separate, label, and save separated ROIs
sepROI = separateROIs(baseROI);
sepROIfilename = sprintf('%s_sepROI.tif',basefilename);
imwrite(sepROI,sepROIfilename);

end
