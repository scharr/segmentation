function [intensities] = getMeanIntensity(imOriginal,sepROI,basefilename)

%% show only ROIs of original image

%origROI = imOriginal.*uint16(baseROI);
%figure; imshow(origROI);

%% get average intensities of images, save to *.txt file, and return to workspace

stats = regionprops(sepROI,imOriginal,'MeanIntensity');
intensities = reshape([stats.MeanIntensity],size(stats));
intFilename = sprintf('%s_intensities.txt',basefilename);
intFile = fopen(intFilename, 'w');
for i = 1:length(stats)
    fprintf(intFile, '%s\n',num2str(stats(i).MeanIntensity));
end

fclose(intFile);
end