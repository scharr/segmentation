% try watershed transform

imOriginal = I;

I = imadjust(I);
figure, imshow(I);

level = graythresh(I);
BW1 = im2bw(I, level);
BW2 = bwAdjust(BW1, I);
figure; imshow(BW2);
outlines = bwperim(BW2);
figure; imshow(outlines);
title('Outlines')

se = strel('disk', 3);
Io = imopen(I, se);
figure, imshow(Io)
title('Opening (Io)')

Ie = imerode(I, se);
Iobr = imreconstruct(Ie, I);
figure, imshow(Iobr)
title('Opening-by-reconstruction (Iobr)')

Iobrd = imdilate(Iobr, se);
Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
Iobrcbr = imcomplement(Iobrcbr);
figure, imshow(Iobrcbr)
title('Opening-closing by reconstruction (Iobrcbr)')

fgm = imregionalmax(Iobrcbr);
figure, imshow(fgm)
title('Regional maxima of opening-closing by reconstruction (fgm)')

cleanBW = bwmorph(fgm,'spur');
cleanBW = bwmorph(cleanBW,'hbreak');
se = strel('disk', 1);
cleanBW = imerode(cleanBW,se);
cleanBW = bwmorph(cleanBW,'open');
fgm = cleanBW;
figure, imshow(fgm)
title('Morphologically adjusted regional maxima')

bw = im2bw(Iobrcbr, graythresh(Iobrcbr));
figure, imshow(bw)
title('Thresholded opening-closing by reconstruction (bw)')

D = bwdist(bw);
DL = watershed(D);
bgm = DL == 0;
figure, imshow(bgm)
title('Watershed ridge lines (bgm)')

outlines = uint16(outlines);
outlines2 = imimposemin(outlines, bgm | fgm);
L = watershed(outlines2);

I4 = uint16(I);
I4(imdilate(L == 0, ones(1, 1)) | bgm | fgm) = 255;
figure, imshow(I4)
title('Markers and object boundaries superimposed on original image (I4)')

% level = graythresh(Io);
% BW = im2bw(Io, level);
% figure, imshow(BW);


% outlines = uint16(bwperim(cleanBW));
% forground = cleanBW;
% D = bwdist(cleanBW);
% DL = watershed(D);
% background = DL == 0;
% gradmag = imimposemin(outlines, background | forground);
% L = watershed(gradmag);
% cleanBW = im2bw(L);