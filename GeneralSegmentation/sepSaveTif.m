function sepSaveTif(image,basenames,numChannels,path)
% 
% image is a string with the path of the image that you want to segment
% basenames is a cell array
%   eg {'chan1','chan2','chan3','chan4','chan5'}
% numChannels is an integer
%
    tifstack = readTifStack(image);
    s = size(tifstack);
    if numChannels == 1
        for i = 1:s(3)
            basefilename = sprintf('%s/%s.tif',path,basenames{i});
            imwrite(tifstack(:,:,i),basefilename);
        end
        
    elseif numChannels > 1
    % Go through each output image (one output image per channel)
    % and save to a separeately named file
    dims = size(tifstack);
    numSlices = dims(3);
    numImages = numSlices/numChannels;
    step = numChannels;
    for i = 1:numChannels
        idx = i;
        for j = 1:numImages 
            temp = tifstack(:,:,idx);
            temp = uint8(temp);
            basefilename = sprintf('%s/%s_%d.tif',path,basenames{i},j);
            imwrite(temp,basefilename);
            idx = idx+step;
        end
    end
%     elseif numChannels > 1
%         stacks = splitChannels(tifstack, numChannels);
%         for i = 1:length(stacks)
%             im = stacks{i};
%             for j = 1:(s(3)/numChannels)
%                 basefilename = sprintf('%s/%s_%d.tif',path,basenames{i},j);
%                 %imwrite(im(:,:,j),basefilename);
%             end
%         end
%     end

end