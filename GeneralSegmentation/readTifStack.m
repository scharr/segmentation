function [tifstack] = readTifStack(imgfname)
    info = imfinfo(imgfname);
    numImages = length(info);
    rows = info(1).Height;
    cols = info(1).Width;
    tifstack = zeros(rows,cols,numImages);
    for i = 1:numImages
        tifstack(:,:,i) = imread(imgfname,'Index',i);
    end
end