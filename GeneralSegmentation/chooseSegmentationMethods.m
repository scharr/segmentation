function [methods] = chooseSegmentationMethods()

    %% basic segmentation test
    % get the image

    [filename, imOriginal] = getImage('Choose image to segment');

    %% adjust the contrast

    [imCA, caMethod] = chooseContrastAdjustment(imOriginal);

    %% choose a morphological opening technique

    [imOpen, oMethod] = chooseOpeningMethod(imCA);

    %% choose a BW image (starting ROIs)

    [imBW, bwMethod] = chooseBW(imOpen, imCA);

    %% edits ROIs
    title = 'Choose image to underlay ROI image for editing';
    choice = menu(title,...
    'Default','Choose Image');
    % Handle response
    switch choice
        case 1
            imCAUnder = imCA;
            eMethod = 'Default';
        case 2
            [~, imUnderlay] = getImage('Choose image to underlay');
            imCAUnder = imadjust(imUnderlay);
            eMethod = 'Choose';
    end
    
    [newROI, labROI] = editROIs(imBW, imCAUnder);
    
    %% record and methods

    methods = struct('Contrast_Adjustment',caMethod,'Opening',{oMethod},...
        'BW_Conversion',{bwMethod},'Edit_Image',eMethod);
    
    %% save methods, ROI, and labeled ROIs. 
    basefilename = filename(1,1:length(filename)-4);

    methodsfilename = sprintf('%s_ROImethods.mat',basefilename);
    save(methodsfilename,'methods');
    
    baseROIfilename = sprintf('%s_baseROI.tif',basefilename);
    imwrite(newROI,baseROIfilename);

    sepROIfilename = sprintf('%s_sepROI.tif',basefilename);
    imwrite(labROI,sepROIfilename);

end





