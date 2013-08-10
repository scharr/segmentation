function makeMaxProjection()

    [files, path] = uigetfile('*.tif',...
    'Select all files to make max projections of','Multiselect','on');

    % allows user to select multiple of just one image
    if iscell(files)
        for i = 1:length(files)
            currfile = [path,files{i}];
            currimage = loadtiff(currfile);
            saveMip(currimage,files{i})
        end
    else
        currimage = loadtiff(files);
        saveMip(currimage,files)
    end        
    
    % takes maximum values along the 3rd dimension of the image matrix
    function saveMip(currimage,fname)
        mip = max(currimage, [], 3);
        filename = [path,'MAX2_',fname];
        imwrite(mip,filename);
    end

    % loads the tiff file as a 3D matrix
    % the length of imfinfo gives the number of images in the stack
    % simply concatinate one onto the next until finished
    function imgtemp = loadtiff(filename)
        info = imfinfo(filename);
        numImages = length(info);
        imgtemp = imread(filename,'Index',1);
        for j = 2:numImages
            imgs = cat(3, imgtemp, imread(filename,'Index',j));
            imgtemp = imgs;
        end
    end

end