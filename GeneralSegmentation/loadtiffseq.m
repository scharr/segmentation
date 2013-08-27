function D = loadtiffseq(pathname,filename)

info=imfinfo(strcat(pathname,filename));
nZ = numel(info);
D = zeros(512,512,nZ);
for i = 1:nZ
    D(:,:,i)=imread(strcat(pathname,filename),i,'Info',info);
    disp('reading slice#',i);
end

%%% see http://blogs.mathworks.com/steve/2009/04/02/matlab-r2009a-imread-and-multipage-tiffs/