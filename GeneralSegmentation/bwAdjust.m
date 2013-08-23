function cleanBW = bwAdjust(BW)
    cleanBW = bwmorph(BW,'spur');
    cleanBW = bwmorph(cleanBW,'hbreak');
    cleanBW = bwmorph(cleanBW,'clean');
    cleanBW = bwmorph(cleanBW,'diag');
    cleanBW = bwmorph(cleanBW,'fill');
    cleanBW = bwmorph(cleanBW,'majority');
    cleanBW = bwmorph(cleanBW,'majority');
    cleanBW = bwmorph(cleanBW,'open');
end