function [newROI, labROI] = editROIs(imBW, imCA)
% [newROI] = editROIs(imBW, imCA)
% Takes an ROI image, overlays it on a contrast adjusted image and allows
% the user to add, delete, and separate regions of interest from the image
% 
%   imCA      :   uint16 2D matrix of contrast adjusted image
%   imBW      :   logical 2D matrix of a black and white image
%   newROI    :   double 2D matrix of a black and white image
%   labROI    :   uint8 2D matrix of newROI with ROIs numerically labeled
%  
%
%   scharr@stanford.edu
%   Aug 16, 2013

figure;
set(gcf, 'Position', get(0,'Screensize'));
himage = ROIoverlay(imCA, imBW);
[newROI] = identifyROI(imBW,himage);
[labROI] = labelROIs(newROI);

%% Show ROI outlines around imContrastAdjusted
    function himage = ROIoverlay(imCA, ROI)
    % view the an ROI mask over the data as outlines.
        B = bwboundaries(ROI); 
        himage = imshow(imCA);
        hold on;
        for k=1:length(B)
            boundary = B{k};
            plot(boundary(:,2), boundary(:,1),'m','LineWidth',.5);
        end
    end

%% Add new ROIs
    function [newROI] = identifyROI(currROI, himage)
        % draw on new ROIs with ellipse tool.
        % freehand works okay, but more tricky than useful, I think.
        % then hold all commands until double click of ROI closes window
        title('Draw a region, move if desired, & double click')
       
        editChoice = menu('How would you like to draw your region?',...
            'add freehand','add polygon','add ellipse',...
            'del freehand','del polygon','del ellipse',...
            'separate ellipse','show BW','accept');
        
        switch editChoice
            case 1
                h = imfreehand;
                wait(h);
                tempROI = createMask(h,himage);
                newROI = addROI(currROI, tempROI);
                himage = ROIoverlay(imCA,newROI);
                [newROI] = identifyROI(newROI,himage);
            case 2
                h = impoly;
                wait(h);
                tempROI = createMask(h,himage);
                newROI = addROI(currROI, tempROI);
                himage = ROIoverlay(imCA,newROI);
                [newROI] = identifyROI(newROI,himage);
            case 3
                h = imellipse;
                wait(h);
                tempROI = createMask(h,himage);
                newROI = addROI(currROI, tempROI);
                himage = ROIoverlay(imCA,newROI);
                [newROI] = identifyROI(newROI,himage);
            case 4
                h = imfreehand;
                wait(h);
                tempROI = createMask(h,himage);
                newROI = deleteROI(currROI, tempROI);
                himage = ROIoverlay(imCA,newROI);
                [newROI] = identifyROI(newROI, himage);
            case 5
                h = impoly;
                wait(h);
                tempROI = createMask(h,himage);
                newROI = deleteROI(currROI, tempROI);
                himage = ROIoverlay(imCA,newROI);
                [newROI] = identifyROI(newROI,himage);
            case 6
                h = imellipse;
                wait(h);
                tempROI = createMask(h,himage);
                newROI = deleteROI(currROI, tempROI);
                himage = ROIoverlay(imCA,newROI);
                [newROI] = identifyROI(newROI,himage);
            case 7
                h = imellipse;
                wait(h);
                tempROI = createMask(h,himage);
                newROI = separateROI(currROI, tempROI);
                himage = ROIoverlay(imCA,newROI);
                [newROI] = identifyROI(newROI,himage);
            case 8 
                newROI = currROI;
                himage = ROIoverlay(newROI,newROI);
                [newROI] = identifyROI(newROI,himage);
            case 9
                newROI = currROI;
                himage = ROIoverlay(imCA,newROI);
        end
        close all;      
     end

%% ROI actions
    function newROI = addROI(I, tempROI)
    % add region to ROI image
        newROI = I+tempROI;
    end
    function newROI = deleteROI(I, tempROI)
    % delete region from ROI image
        newROI = I.*imcomplement(tempROI);
    end
    function newROI = separateROI(I, tempROI)
    % separate ellipse from other regions
        tempsmall = bwmorph(tempROI, 'erode');
        tempbig = bwmorph(tempROI, 'dilate');
        newROI = I.*imcomplement(tempbig);
        newROI = newROI+tempsmall;
    end
    
%% separate and label ROIs
    function labROI = labelROIs(baseROI)
    % numbers each ROI

    CC2 = bwconncomp(baseROI);
    labROI = labelmatrix(CC2);
    figure, imshow(label2rgb(labROI));

    end
end

