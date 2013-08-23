function [imCA, method] = chooseContrastAdjustment(imOriginal)
% [imContrastAdjusted, method] = chooseContrastAdjustment(imOriginal)
% Tests different contrast adjustment method
% Images pop up in different windows
% Choose contrast adjustment method from a menu
% 
%   imContrastAdjusted  :   uint16 2D matrix
%   method              :   string
%
%   scharr@stanford.edu
%   Aug 15, 2013

    [imCA, method] = showCAMethods(imOriginal);

    function [imCA, method] = showCAMethods(imOriginal)
    % choose best contrast method
    global CA1 CA2 CA3 CA4 CA5;
        
        % choose this one or redo
        title = 'Show different contrast methods';
        caChoice = menu(title,...
        'Original','Imadjust 1%','Imadjust 5%','Adapthisteq','Histeq 1',...
        'Histeq 2','Show All','Choose');
        
        % Handle response
        switch caChoice
            case 1
                showOriginalImage(imOriginal);
                [imCA, method] = showCAMethods(imOriginal);
            case 2
                CA1 = showImadjust1(imOriginal);
                [imCA, method] = showCAMethods(imOriginal);
            case 3
                CA2 = showImadjust2(imOriginal);
                [imCA, method] = showCAMethods(imOriginal);
            case 4
                CA3 = showAdapthisteq(imOriginal);
                [imCA, method] = showCAMethods(imOriginal);
            case 5
                CA4 = showHisteq1(imOriginal);
                [imCA, method] = showCAMethods(imOriginal);
            case 6
                CA5 = showHisteq2(imOriginal);
                [imCA, method] = showCAMethods(imOriginal);
            case 7
                CA1 = showImadjust1(imOriginal);
                CA2 = showImadjust2(imOriginal);
                CA3 = showAdapthisteq(imOriginal);
                CA4 = showHisteq1(imOriginal);
                CA5 = showHisteq2(imOriginal);
                [imCA, method] = showCAMethods(imOriginal);
            case 8
                [imCA, method] = chooseCAMethod();
        end 
        
        
        function [imCA, method] = chooseCAMethod()
        % Choose and return the contrast adjusted image
            title = 'Choose a contrast method';
            choice = menu(title,...
            'Original','Imadjust 1%','Imadjust 5%','Adapthisteq','Histeq 1',...
            'Histeq 2');
            switch choice
                case 1
                    imCA = imOriginal;
                    method = 'Original';
                case 2
                    imCA = CA1;
                    method = 'Imadjust1';
                case 3
                    imCA = CA2;
                    method = 'Imadjust5';
                case 4
                    imCA = CA3;
                    method = 'Adapthisteq';
                case 5
                    imCA = CA4;
                    method = 'Histeq1';
                case 6
                    imCA = CA5;
                    method = 'Histeq2';
            end    
        end    
        
    end

    function showOriginalImage(imOriginal)
        % show original image
        figure, imshow(imOriginal);
        title('imOriginal');
    end
    
    function CA1 = showImadjust1(imOriginal)
        % imadjust
        % adjusts histogram so certain percentages of brightest & darkest
        % pixels are saturated
        CA1 = imadjust(imOriginal,stretchlim(imOriginal),[]);
        figure, imshow(CA1);
        title('imadjust: top 1% and bottom 1% saturated');
    end

    function CA2 = showImadjust2(imOriginal)
        CA2 = imadjust(imOriginal,stretchlim(imOriginal,[0.01 0.95]),[]);
        figure, imshow(CA2);
        title('imadjust: top 5% and bottom 1% saturated');
    end

    function CA3 = showAdapthisteq(imOriginal)
        % adapthisteq
        % Adapt image using Contrast-limited Adaptive Histogram Equalization
        % (CLAHE)
        CA3 = adapthisteq(imOriginal);
        figure, imshow(CA3);
        title('adapthisteq');
    end
    
    function CA4 = showHisteq1(imOriginal)
        % histeq
        % equalizes the histogram of the image into many or a 
        % limited number of bins
        CA4 = histeq(imOriginal);
        figure, imshow(CA4);
        title('histeq with default bins');
    end
    
    function CA5 = showHisteq2(imOriginal)
        CA5 = histeq(imOriginal,25);
        figure, imshow(CA5);
        title('histeq with 25 bins');
    end

end

    
    
    
    
    