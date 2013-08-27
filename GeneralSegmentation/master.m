function master()

    [filenames, pathname] = uigetfile('*.tif','MultiSelect', 'on');
    for i = 1:length(filenames)

        filename = filenames{i};
        [imOriginal, sepROI] = fastSegmentation(filename, pathname);

        basefilename = [pathname,filename];
        basefilename = basefilename(1:length(basefilename)-4);
        getMeanIntensity(imOriginal,sepROI,basefilename);

    end

end