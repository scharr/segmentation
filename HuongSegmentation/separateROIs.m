function [sepROI] = separateROIs(baseROI)
% numbers each ROI

    CC2 = bwconncomp(baseROI);
    sepROI = labelmatrix(CC2);
    figure, imshow(label2rgb(sepROI));


end