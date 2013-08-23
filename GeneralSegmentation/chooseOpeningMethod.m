function [imOpen, method] = chooseOpeningMethod(imCA)
% [imOpened, method] = chooseOpeningMethod(imCA)
% Tests different morphological opening methods
% Images pop up in different windows
% Choose morphological opening from a menu
% 
%   imCA      :   uint16 2D matrix of contrast adjusted image
%   imOpened  :   uint16 2D matrix
%   method    :   string
%
%   scharr@stanford.edu
%   Aug 15, 2013

    [imOpen, method] = showOpeningMethods(imCA);

    function [imOpen, method] = showOpeningMethods(imCA)
    % choose best contrast method
        
        % choose this one or redo
        title = 'Show different opening methods';
        caChoice = menu(title,...
        'Contrast Adjusted','Morphological Opening',...
        'Opening Through Reconstruction','Show All','Choose');
        
        % Handle response
        switch caChoice
            case 1
                showCA(imCA);
                [imOpen, method] = showOpeningMethods(imCA);
            case 2
                [O1,ds] = showMorphOpen(imCA);
                [imOpen, method] = showOpeningMethods(imCA);
            case 3
                O2 = showOTR(imCA);
                [imOpen, method] = showOpeningMethods(imCA);
            case 4
                O1 = showOTR(imCA);
                O2 = showOTR(imCA);
                [imOpen, method] = showOpeningMethods(imCA);
            case 5
                [imOpen, method] = chooseOpeningMethod();
        end  
        
        function [imOpen, method] = chooseOpeningMethod()
        % Choose and return the contrast adjusted image
            title = 'Choose an opening method';
            choice = menu(title,...
            'Contrast Adjusted','Morphological Opening',...
            'Opening Through Reconstruction');
            switch choice
                case 1
                    imOpen = imCA;
                    method = 'None';
                case 2
                    [O1,ds] = showMorphOpen(imCA);
                    imOpen = O1;
                    method = {'MorphOpening',ds};
                case 3
                    [O2,ds] = showOTR(imCA);
                    imOpen = O2;
                    method = {'OTR',ds};
            end    
        end    
        
    end

    function showCA(imCA)
        % show original image
        figure, imshow(imCA);
        title('No Opening of Contrast Adjusted Image');
    end
    
    function [O1,ds] = showMorphOpen(imCA)
        % morphological opening
        ds = chooseDiskSize();
        se = strel('disk', ds);
        O1 = imopen(imCA, se);
        figure, imshow(O1);
        t = sprintf('Morphological Opening, disk size %i',ds);
        title(t);
    end

    function [O2,ds] = showOTR(imCA)
        % opening through reconstruction
        ds = chooseDiskSize();
        se = strel('disk', ds);
        Ie = imerode(imCA, se);
        O2 = imreconstruct(Ie, imCA);
        figure, imshow(O2)
        t = sprintf('Opening Through Reconstruction, disk size %i',ds);
        title(t);
    end

    function ds = chooseDiskSize()
        prompt={'Enter disk size 1 through 7'};
        name='Disk Size';
        numlines=1;
        defaultanswer={'4'};
        answer=inputdlg(prompt,name,numlines,defaultanswer);
        ds = str2num(answer{1});
    end

end

    
    
    
    
    