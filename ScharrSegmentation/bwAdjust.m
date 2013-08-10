function [cleanBW] = bwAdjust(rawBW, imContrastAdjusted)
% cleaning up the BW image

%% Show the contrast adjusted image
%subplot(2,3,1); subimage(rawBW); title('rawBW');

%% Use built in function to remove ROIs smaller than 10 pixels
% choose the black and white image that worked best:
cleanBW = bwareaopen(rawBW, 10);
%subplot(2,3,2); subimage(cleanBW); title('1) <10px removed');

%% Remove single pixels hanging off blobs
cleanBW = bwmorph(cleanBW,'spur');
%subplot(2,3,3); subimage(cleanBW); title('2) spurs removed');

%% Remove single pixels between blobs
cleanBW = bwmorph(cleanBW,'hbreak');
% Make single B/W pixels match their surrounding pixels
cleanBW = bwmorph(cleanBW,'majority');
%subplot(2,3,4); subimage(cleanBW); title('3) single px removed');

%% Dilate image with a rolling ball structuring element.
se = strel('line',3,3);
cleanBW = imdilate(cleanBW,se);
%subplot(2,3,5), subimage(cleanBW), title('4) image dilated');

%%
cleanBW = bwmorph(cleanBW,'open');
cleanBW = bwmorph(cleanBW,'fill');
%subplot(2,3,6); subimage(cleanBW); title('5) open and filled');

%%
%figure; subplot(1,2,1); subimage(imContrastAdjusted);
%subplot(1,2,2); subimage(cleanBW);