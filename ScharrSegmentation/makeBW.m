function [cleanBW] = makeBW(imContrastAdjusted)
% tests different

    % set up subplots & show original image
    subplot(2,2,3);
    imshow(imContrastAdjusted);
    title('imContrastAdjusted');
    
    % make black and white based on gray threshold
    % detect threshold using "graythresh"
    % The graythresh function "computes a global threshold (level) that can  
    % be used to convert an intensity image to a binary image with im2bw.  
    % level is a normalized intensity value that lies in the range [0, 1].
    % ...uses Otsu's method, which chooses the threshold to minimize the 
    % intraclass variance of the black and white pixels."
    level = graythresh(imContrastAdjusted);
    BW1 = im2bw(imContrastAdjusted, level);
    cleanBW1 = bwAdjust(BW1, imContrastAdjusted);
    subplot(2,2,2);
    imshow(cleanBW1);
    title('graythresh');
    
    % imregionalmax
    % adjusts histogram so 1% of brightest & darkest are saturated (I
    % think...)
    BW2 = imregionalmax(imContrastAdjusted);
    cleanBW2 = bwAdjust(BW2, imContrastAdjusted);
    subplot(2,2,1);
    imshow(cleanBW2);
    title('imregionalmax');

    % choose best contrast method
    function cleanBW = chooseBWMethod()
        
        % choose this one or redo
        prompt = 'Which BW method would you like to use?';
        name = 'Choose your favorite BW';
        bwChoice = questdlg(prompt, name, ...
        'imregionalmax','graythresh','graythresh');
        % Handle response
        switch bwChoice
            case 'graythresh'
                cleanBW = cleanBW1;
            case 'imregionalmax'
                cleanBW = cleanBW2;
        end
        
        subplot(2,2,4);
        imshow(cleanBW);
        title('rawBW');    
    
        % choose this one or redo
        choice = questdlg('Is this good?', 'Finished?', ...
        'Yes finished','No not finished','Yes finished');
        % Handle response
        switch choice
            case 'Yes finished'
                return;
            case 'No not finished'
                chooseBWMethod();
        end
        
    end
    cleanBW = chooseBWMethod();
end


