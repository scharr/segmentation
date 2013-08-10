%% stats scratch sheet

% Use a previously made ROI to get intensities from another image

[ROIfilename, path] = uigetfile('*.tif','Select sepROI file');
id = [path,ROIfilename];
sepROI = imread(id);

[imagefilename, path] = uigetfile('*.tif','Select imOriginal file');
id = [path,imagefilename];
imOriginal = imread(id);

basefilename = [path,imagefilename];
basefilename = basefilename(1:length(basefilename)-4);

getMeanIntensity(imOriginal,sepROI,basefilename);

%% try the above in bulk:

% Use a previously made ROI to get intensities from another image

[ROIfilenames, path] = uigetfile('*.tif','Select sepROI file');
id = [path,ROIfilenames];
sepROI = imread(id);

[imagefilenames, path] = uigetfile('*.tif','Select imOriginal file');
id = [path,imagefilenames];
imOriginal = imread(id);

basefilename = [path,imagefilenames];
basefilename = basefilename(1:length(basefilename)-4);

getMeanIntensity(imOriginal,sepROI,basefilename);


%% get data of one type all in a list

[files, path] = uigetfile('*.txt','Select all files of another type','Multiselect','on');

prompt = {'Enter condition name:'};
dlg_title = 'Input';
num_lines = 1;
def = {files{1}};
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
