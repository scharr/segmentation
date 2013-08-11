
function HuongsSegmentation()

chooseAdventure()

    function chooseAdventure()
    % choose this one or redo
            prompt = 'Which step would you like to do?';
            %name = 'Huongs Segmentation';
            choice = menu(prompt,'.stk to .tif','Max Projections','Segment',...
                'Calculate Intensities','Combine Data','Exit');
            % Handle response
            switch choice
                case 1
                    Dir = uigetdir(pwd,'Where are the .stk files?');
                    changeFileExtension(Dir,'.stk','.tif');
                    chooseAdventure()
                case 2
                    makeMaxProjection();
                    chooseAdventure()
                case 3
                    segmentImage();
                    chooseAdventure()
                case 4
                    calcIntensities();
                    chooseAdventure()
                case 5
                    combineData();
                    chooseAdventure()
                case 6
                    clear all
                    close all
            end
    end

    function segmentImage()
        %% basic segmentation
        %% get image to segment
        [imgname, path] = uigetfile('*.tif','Select Nuclei Image');
        filename = [path imgname];
        imDAPI = imread(filename);

        %% get neuron image
        [imgname, path] = uigetfile('*.tif','Select Neuron Image');
        filename = [path imgname];
        imNeuron = imread(filename);

        %% get contrast adjusted neuron image
        caNeuron = imadjust(imNeuron);

        %% make BW image
        level = graythresh(imDAPI);
        rawBW = im2bw(imDAPI, level);

        cleanBW = bwareaopen(rawBW, 10);
        cleanBW = bwmorph(cleanBW,'spur');
        cleanBW = bwmorph(cleanBW,'hbreak');
        cleanBW = bwmorph(cleanBW,'majority');
        cleanBW = bwmorph(cleanBW,'fill');
        cleanBW = bwmorph(cleanBW,'open');

        %% edit ROIs
        [baseROI] = editROIs(cleanBW, caNeuron);
        imshow(baseROI)

        %% save baseROI
        basefilename = filename(1,1:length(filename)-4);
        baseROIfilename = sprintf('%s_baseROI.tif',basefilename);
        imwrite(baseROI,baseROIfilename);

        %% separate, label, and save sepROIs
        [sepROI] = separateROIs(baseROI);
        sepROIfilename = sprintf('%s_sepROI.tif',basefilename);
        imwrite(sepROI,sepROIfilename);
    end

    function calcIntensities()
        %% Use a previously made ROI to get intensities from another image

        [ROIfilename, path] = uigetfile('*.tif','Select ROI file');
        id = [path,ROIfilename];
        sepROI = imread(id);

        [imagefilename, path] = uigetfile('*.tif','Select image to measure intensities');
        id = [path,imagefilename];
        imOriginal = imread(id);

        basefilename = [path,imagefilename];
        basefilename = basefilename(1:length(basefilename)-4);

        getMeanIntensity(imOriginal,sepROI,basefilename);
    end

    function combineData()
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
    end

end
