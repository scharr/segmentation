%% stats scratch sheet

% Use a previously made ROI to get intensities from another image

[ROIfilename, path] = uigetfile('*.tif','Select labeled ROI file');
id = [path,ROIfilename];
labROI = imread(id);

[imagefilename, path] = uigetfile('*.tif','Select image file for analysis');
id = [path,imagefilename];
imOriginal = imread(id);

basefilename = [path imagefilename];
basefilename = basefilename(1:length(basefilename)-4);

getMeanIntensity(imOriginal,labROI,basefilename);

%% try the above in bulk:

% Use a previously made ROI to get intensities from another image

[ROIfilenames, Rpath] = uigetfile('*.tif','Select labeled ROI file(s)','Multiselect','on');
[imagefilenames, Ipath] = uigetfile('*.tif','Select original image file(s)','Multiselect','on');

if iscell(ROIfilenames) && iscell(imagefilenames) && ...
    length(ROIfilenames) == length(imagefilenames)
    for i = 1:length(ROIfilenames)
        % Read in 1st ROI file
        Rid = [Rpath,ROIfilenames{i}];
        labROI = imread(Rid);
        % Read in 1st Image file
        Iid = [Ipath,imagefilenames{i}];
        imOriginal = imread(Iid);
        
        basefilename = [path,imagefilenames{i}];
        basefilename = basefilename(1:length(basefilename)-4);
        
        getMeanIntensity(imOriginal,labROI,basefilename);
    end
else
    Rid = [path,ROIfilename];
    labROI = imread(Rid);

    Iid = [path,imagefilename];
    imOriginal = imread(Iid);

    basefilename = [path imagefilename];
    basefilename = basefilename(1:length(basefilename)-4);

    getMeanIntensity(imOriginal,labROI,basefilename);  
end


%% get data of one type all in a list

[files, path] = uigetfile('*.txt','Select all files of another type','Multiselect','on');

prompt = {'Enter condition name:'};
dlg_title = 'Input';
num_lines = 1;
def = files(1);
condition1 = inputdlg(prompt,dlg_title,num_lines,def);

cond1data = [];
for i = 1:length(files)
    currfile = [path,files{i}];
    id = fopen(currfile,'r');
    currdata = textscan(id,'%f');
    cond1data = [cond1data;currdata{:}];
    fclose(id);
end

id = fopen([path,condition1{1},'_allROIs.txt'],'w');
for i = 1:length(cond1data)
    fprintf(id,'%s\n',num2str(cond1data(i)));
end
fclose(id);
