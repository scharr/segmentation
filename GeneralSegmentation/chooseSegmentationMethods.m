function [methods] = chooseSegmentationMethods()
    % [methods] = chooseSegmentationMethods() 
    % Opens a sequence of graphical user interfaces to segment regions of 
    % interest (ROIs) from a *.tif image. The steps include:
    %       1. Contrast adjustment
    %       2. Morphological opening
    %       3. Conversion to black & white (creation of ROIs)
    %       4. Manual editing of ROIs with the option to underlay a
    %          different image. (This is useful if ROI selection is based 
    %          on a marker different from that used to segment the image.)         
    %       5. Automatically saving all the images as *.tif files based on
    %          the filename of the original segmentation image.
    %       6. Creation of a *.mat file with a structure containing all the
    %          methods used to create the ROI. This file would be used
    %          with the runMethods function to automatically apply those
    %          segmentation methods to a new image

    %% Get the image
    % The image to segment must be a *.tif file. 
    %      1. If the image is a z-stack or timelapse movie, it may be best 
    %         to make a maximum projection image (say, in ImageJ) first. 
    %      2. You may also choose to segment off of an image using a marker 
    %         different from the one you will eventually measure (say, segment 
    %         off of GFP and then 

    [imgname, path] = uigetfile('*.tif','Choose image to segment');
    filename = [path imgname];
    imOriginal = imread(filename);

    %% adjust the contrast

    [imCA, caMethod] = chooseContrastAdjustment(imOriginal);

    %% choose a morphological opening technique

    [imOpen, oMethod] = chooseOpeningMethod(imCA);

    %% choose a BW image (starting ROIs)

    [imBW, bwMethod] = chooseBW(imOpen, imCA);

    %% edits ROIs
    title = 'Choose image to underlay ROI image for editing';
    choice = menu(title,'Default','Choose Image');
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

    sepROIfilename = sprintf('%s_labROI.tif',basefilename);
    imwrite(labROI,sepROIfilename);

end





