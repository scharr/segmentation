[imgfilename, imgpath] = uigetfile('*.tif','choose tifstack for intensities over time');
imfname = [imgpath imgfilename];
[ROIfilename, ROIpath] = uigetfile('*.tif',imgpath,'choose labeled ROI mask');
labROIfname = [ROIpath ROIfilename];

intensities = mIntTime(imfname, labROIfname);