function tifm = loadtiffseq(fullfilename)
% tifm = loadtiffseq(pathname,filename)
%       Takes the filename of a multipage *.tif files (aka tif stack or
%       movie) and returns the images as one 3D matrix.
%
%       *.stk files (from Metamorph imaging software) must be saved as
%       *.tif files. ImageJ works well for this. Just changing the
%       extension has not worked for me.
%
%       see http://blogs.mathworks.com/steve/2009/04/02/matlab-r2009a-imread-and-multipage-tiffs/
%       as a reference for reading very large multipage tif images.
%
% scharr@stanford.edu
% August 26, 2013

    info=imfinfo(fullfilename));
    nZ = numel(info);
    rows = info(1).Height;
    cols = info(1).Width;
    tifm = zeros(rows,cols,nZ);
    for i = 1:nZ
        tifm(:,:,i)=imread(strcat(fullfilename),i,'Info',info);
        disp(['reading slice #',int2str(i)]);
    end

end
