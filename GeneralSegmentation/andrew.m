
%% take massive, multichannel tif file
[file, path] = uigetfile('*.tif',pwd,'Choose image file');

%%
imgf = [path file];

%%
basenames = {'chan1','chan2','chan3','chan4','chan5'};
numChannels = 5;

%% save each image separately
sepSaveTif(imgf,basenames,numChannels,path);

%% testing changing contrasts

[a, path] = uigetfile('*.tif');

%%
im = imread([path a]);
im = uint8(im);

imCA = imadjust(im,[0.1 0.2],[]);
imshow(imCA);

