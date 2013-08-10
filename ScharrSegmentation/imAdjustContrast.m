function [imContrastAdjusted] = imAdjustContrast(imOriginal)
% [imContrastAdjusted, method] = imAdjustContrast(imOriginal)
% tests different

    % set up subplots
    subplot(2,3,1);

    % show original image
    imagesc(imOriginal);
    title('imOriginal');

    % show histogram of original image
    [counts,x] = imhist(imOriginal);
    subplot(2,3,2);
    title('Histogram of imOriginal');
    bar(x,counts);
    xlim([0 x(end)]); 
    
    % imadjust
    % adjusts histogram so 1% of brightest & darkest are saturated (I
    % think...)
    CA1 = imadjust(imOriginal,stretchlim(imOriginal),[]);
    subplot(2,3,3);
    imagesc(CA1);
    title('imadjust');
    
    % adapthisteq
    % Adapt image using Contrast-limited Adaptive Histogram Equalization
    % (CLAHE)
    CA2 = imadjust(imOriginal);
    subplot(2,3,4);
    imagesc(CA2);
    title('adapthisteq');
    
    % histeq
    % equalizes the histogram of the image
    CA3 = histeq(imOriginal);
    subplot(2,3,5);
    imagesc(CA3);
    title('histeq');
    
    imContrastAdjusted = chooseCAMethod();

    % choose best contrast method
    function imContrastAdjusted = chooseCAMethod()
        
        % choose this one or redo
        prompt = 'Which contrast method would you like to use?';
        name = 'Choose your favorite contrast';
        caChoice = questdlg(prompt, name, ...
        'imadjust','adapthisteq','histeq','imadjust');
        % Handle response
        switch caChoice
            case 'imadjust'
                imContrastAdjusted = CA1;
            case 'adapthisteq'
                imContrastAdjusted = CA2;
            case 'histeq'
                imContrastAdjusted = CA3;
        end
        
        subplot(2,3,6);
        imagesc(imContrastAdjusted);
        title('imContrastAdjusted');    
    
        % choose this one or redo
        choice = questdlg('Is this good?', 'Finished?', ...
        'Yes finished','No not finished','Yes finished');
        % Handle response
        switch choice
            case 'Yes finished'
                return;
            case 'No not finished'
                chooseCAMethod();
        end
        
    end
    caMethod = caChoice;
end

    
    
    
    
    