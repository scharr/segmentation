function runMethods()
    % Load in all the methods
    [mFilename, mPath] = uigetfile('*.mat','Choose methods file');
    methodsfile = [mPath mFilename];
    load('-mat', methodsfile);

    % Parse the methods
    caMethod = methods.Contrast_Adjustment;

    if iscell(methods.Opening)
        oMethod = methods.Opening{1};
        ds = methods.Opening{2};
    else
        oMethod = methods.Opening;
    end

    if iscell(methods.BW_Conversion)
        bwMethod = methods.BW_Conversion{1};
        lp = methods.BW_Conversion{2};
    else
        bwMethod = methods.BW_Conversion;
    end
    
    eMethod = methods.Edit_Image;
    
    % Choose image to segment
    [filename, imOriginal] = getImage('Choose image to segment');

    % Adjust the contrast of the image
    % caMethods
    %'Original','Imadjust1','Imadjust5','Adapthisteq','Histeq1','Histeq2'
    switch caMethod
        case 'Original'
            imCA = imOriginal;
        case 'Imadjust1'
            imCA = imadjust(imOriginal,stretchlim(imOriginal),[]);
        case 'Imadjust5'
            imCA = imadjust(imOriginal,stretchlim(imOriginal,[0.01 0.95]),[]);
        case 'Adapthisteq'
            imCA = imadjust(imOriginal);
        case 'Histeq1'
            imCA = histeq(imOriginal);
        case 'Histeq2'
            imCA = histeq(imOriginal,25);
    end

    % oMethods
    %'None','MorphOpening','OTR'
    % ds optional for both
    switch oMethod
        case 'None'
            imOpen = imCA;
        case 'MorphOpening'
            se = strel('disk', ds);
            imOpen = imopen(imCA, se);
        case 'OTR'
            se = strel('disk', ds);
            Ie = imerode(imCA, se);
            imOpen = imreconstruct(Ie, imCA);
    end

    % bwMethods
    % 'Graythreshold','RegionalMaxima'
    % lp optional for Graythreshold
    switch bwMethod
        case 'Graythreshold'
            level = graythresh(imOpen);
            thresh = level*lp;
            BW1 = im2bw(imOpen, thresh);  
        case 'RegionalMaxima'
            BW1 = imregionalmax(imOpen);
    end
    imBW = bwAdjust(BW1);
    
    % eMethods
    % 'Default','Choose'
    switch eMethod
        case 'Default'
            imCAUnder = imCA;
        case 'Choose'
            [~, imCAUnder] = getImage('*.tif','Choose image to underlay.');
    end
    [newROI, labROI] = editROIs(imBW, imCAUnder);

    %% save ROIs

    % bweuler(baseROI)
    basefilename = filename(1,1:length(filename)-4);
    baseROIfilename = sprintf('%s_baseROI.tif',basefilename);
    imwrite(newROI,baseROIfilename);

    %% save labeled ROIs

    sepROIfilename = sprintf('%s_labROI.tif',basefilename);
    imwrite(labROI,sepROIfilename);

end