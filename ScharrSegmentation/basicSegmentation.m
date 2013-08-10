function basicSegmentation()

%% basic segmentation test
% get the image

[filename, imOriginal] = getImage();

%% adjust the contrast

[imContrastAdjusted] = imAdjustContrast(imOriginal);

%% choose a rawBW image

[cleanBW] = makeBW(imContrastAdjusted);

%% clean up the BW

%[cleanBW] = bwAdjust(rawBW,imContrastAdjusted);

%% edits ROIs

[baseROI] = editROIs(cleanBW, imContrastAdjusted);
imshow(baseROI)

%% edit again

[baseROI] = editROIs(baseROI, imContrastAdjusted);
imshow(baseROI)

%% save ROI

% bweuler(baseROI)
basefilename = filename(1,1:length(filename)-4);
baseROIfilename = sprintf('%s_baseROI.tif',basefilename);
imwrite(baseROI,baseROIfilename);

%% separate and label ROIs

[sepROI] = separateROIs(baseROI);

%% save separated ROIs

sepROIfilename = sprintf('%s_sepROI.tif',basefilename);
imwrite(sepROI,sepROIfilename);

end





