function combData()
% combine *.txt data from multiple samples

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

end













