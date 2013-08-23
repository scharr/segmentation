function [newROI] = editROIs(cleanBW, imContrastAdjusted)
% editROIs allows you to add and delete ROIs

ROIoverlay(imContrastAdjusted,cleanBW);
[newROI] = identifyROI(cleanBW);

%% Show ROI outlines around imContrastAdjusted
    function ROIoverlay(imContrastAdjusted, ROI)
        % view the an ROI mask over the data as outlines.
        % [B,L,N,A] = bwboundaries(R,'noholes');
        B = bwboundaries(ROI);
        %figure, imshow(imContrastAdjusted); 
        imshow(imContrastAdjusted);
        set(gcf, 'Position', get(0,'Screensize'));
        hold on;
        for k=1:length(B)
            boundary = B{k};
            plot(boundary(:,2), boundary(:,1),'g','LineWidth',.5);
        end
    end

%% Add new ROIs
    function [newROI] = identifyROI(I)
        % have image take up whole screen
        % set(gcf, 'Position', get(0,'Screensize'));

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
                tempROI = createMask(h);
                newROI = addROI(I, tempROI);
                %close all;
                ROIoverlay(imContrastAdjusted,newROI);
                [newROI] = identifyROI(newROI);
            case 2
                h = impoly;
                wait(h);
                tempROI = createMask(h);
                newROI = addROI(I, tempROI);
                %close all;
                ROIoverlay(imContrastAdjusted,newROI);
                [newROI] = identifyROI(newROI);
            case 3
                h = imellipse;
                wait(h);
                tempROI = createMask(h);
                newROI = addROI(I, tempROI);
                %close all;
                ROIoverlay(imContrastAdjusted,newROI);
                [newROI] = identifyROI(newROI);
            case 4
                h = imfreehand;
                wait(h);
                tempROI = createMask(h);
                newROI = deleteROI(I, tempROI);
                %close all;
                ROIoverlay(imContrastAdjusted,newROI);
                [newROI] = identifyROI(newROI);
            case 5
                h = impoly;
                wait(h);
                tempROI = createMask(h);
                newROI = deleteROI(I, tempROI);
                %close all;
                ROIoverlay(imContrastAdjusted,newROI);
                [newROI] = identifyROI(newROI);
            case 6
                h = imellipse;
                wait(h);
                tempROI = createMask(h);
                newROI = deleteROI(I, tempROI);
                %close all;
                ROIoverlay(imContrastAdjusted,newROI);
                [newROI] = identifyROI(newROI);
            case 7
                h = imellipse;
                wait(h);
                tempROI = createMask(h);
                newROI = separateROI(I, tempROI);
                %close all;
                ROIoverlay(imContrastAdjusted,newROI);
                [newROI] = identifyROI(newROI);
            case 8 
                %close all;
                newROI = I;
                ROIoverlay(newROI,newROI);
                [newROI] = identifyROI(newROI);
            case 9
                newROI = I;
                close all;
                ROIoverlay(imContrastAdjusted,newROI);
        end
        close all;      
     end

%% ROI actions
    function newROI = addROI(I, tempROI)
        newROI = I+tempROI;
    end
    function newROI = deleteROI(I, tempROI)
        newROI = I.*imcomplement(tempROI);
    end
    function newROI = separateROI(I, tempROI)
        tempsmall = bwmorph(tempROI, 'erode');
        tempbig = bwmorph(tempROI, 'dilate');
        newROI = I.*imcomplement(tempbig);
        newROI = newROI+tempsmall;
    end
        
end

