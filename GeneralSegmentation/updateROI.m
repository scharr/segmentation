function updateROI()
    % User interface to load ROI image
    [ROIfname, ROIpath] = uigetfile('*.tif','Choose ROI image to update');
    ROIfilename = [ROIpath ROIfname];
    ROI = imread(ROIfilename);
    ROI = logical(ROI);

    % User interface to load underlay image
    [underlayfname, underlaypath] = uigetfile('*.tif','Choose image to underlay',...
        ROIpath);
    underlayfilename = [underlaypath underlayfname];
    imUnderlay = imread(underlayfilename);
    imCA = imadjust(imUnderlay);

    % Edit the ROIs
    [newROI, labROI] = editROIs(ROI, imCA);

    % Save (or not) new ROI images
        title = 'Save new ROI or Cancel?';
        choice = menu(title,'Overwrite Old','Save As','Cancel');
        % Handle response
        switch choice
            case 1
                imwrite(newROI,ROIfilename);
                basefilename = ROIfilename(1,1:length(ROIfilename)-12);
                sepROIfilename = sprintf('%s_labROI.tif',basefilename);
                imwrite(labROI,sepROIfilename);
                msgbox('Updated ROI images');
            case 2
                figure, imshow(newROI);
                figure, imshow(label2rgb(labROI));
                msgbox('ROI image (black and white) and labeled ROI image (color) will open. Use the graphical interface to save the images (preferably as a *.tif).');
            case 3
                msgbox('Images will not be saved.')
        end
end