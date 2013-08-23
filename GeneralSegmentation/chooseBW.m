function [imBW, method] = chooseBW(imOpened, imCA)
% [imBW, method] = chooseBW(imOpen, imCA)
% Tests different black and white conversion methods
% Images pop up in different windows
% Choose conversion method from a menu
% 
%   imOpened  :   uint16 2D matrix of morphologically opened image
%   imCA      :   uint16 2D matrix of contrast adjusted image
%   imBW      :   double 2D matrix of a black and white image
%   method    :   string
%
%   scharr@stanford.edu
%   Aug 16, 2013

    
[imBW, method] = showBWMethods(imOpened, imCA);

    function [imBW, method] = showBWMethods(imOpen, imCA)
    % choose best contrast method
        
        % choose this one or redo
        title = 'Show different BW conversion methods';
        bwChoice = menu(title,...
        'Contrast Adjusted','Graythreshold',...
        'Regional Maxima','Show All','Choose');
        
        % Handle response
        switch bwChoice
            case 1
                showCA(imCA);
                [imBW, method] = showBWMethods(imOpened, imCA);
            case 2
                BW1 = showIm2BW(imOpen);
                [imBW, method] = showBWMethods(imOpened, imCA);
            case 3
                BW2 = showImregionalmax(imOpen);
                [imBW, method] = showBWMethods(imOpened, imCA);
            case 4
                BW1 = showIm2BW(imOpen);
                BW2 = showImregionalmax(imOpen);
                [imBW, method] = showBWMethods(imOpened, imCA);
            case 5
                [imBW, method] = chooseBWMethod();
        end  
        
        function [imBW, method] = chooseBWMethod()
        % Choose and return the BW image
            title = 'Choose a BW conversion method';
            choice = menu(title,...
            'Graythreshold','Regional Maxima');
            switch choice
                case 1
                    [BW1,lp] = showIm2BW(imOpen);
                    imBW = BW1;
                    method = {'Graythreshold',lp};
                case 2
                    BW2 = showImregionalmax(imOpen);
                    imBW = BW2;
                    method = 'RegionalMaxima';
            end    
        end    
        
    end

    function showCA(imCA)
        % show original image
        figure, imshow(imCA);
        title('Contrast Adjusted Image');
    end
    
    function [BW1,lp] = showIm2BW(imOpen)
    % make black and white based on gray threshold
    % detect threshold using "graythresh"
    % The graythresh function "computes a global threshold (level) that can  
    % be used to convert an intensity image to a binary image with im2bw.  
    % level is a normalized intensity value that lies in the range [0, 1].
    % ...uses Otsu's method, which chooses the threshold to minimize the 
    % intraclass variance of the black and white pixels."
        level = graythresh(imOpen);
        lp = chooseLevelPercent();
        thresh = level*lp;
        BW1 = im2bw(imOpen, thresh);
        BW1 = bwAdjust(BW1);
        figure, imshow(BW1);
        t = sprintf('Graythreshold, threshold adjustment: %i',lp);
        title(t);
    end

    function lp = chooseLevelPercent()
    % user interface to adjust the graythreshold level
        prompt={'Multiply graythreshold by ___'};
        name='Adjust graythreshold';
        numlines=1;
        defaultanswer={'1'};
        answer=inputdlg(prompt,name,numlines,defaultanswer);
        lp = str2num(answer{1});
    end
    
    function BW2 = showImregionalmax(imOpen)
    % imregionalmax
        BW2 = imregionalmax(imOpen);
        BW2 = bwAdjust(BW2);
        figure, imshow(BW2);
        title('Imregionalmax');
    end
end


