%% load ROI file and movie file
[ROIfname, ROIpath] = uigetfile('*.tif','choose labeled ROI file');
[moviefname, moviepath] = uigetfile('*.tif','choose tif timelapse file',ROIpath);

%%
labROI = imread([ROIpath ROIfname]);
tifstk = loadtiffseq(moviepath,moviefname);

%% calculate raw intensities
[intensities] = mIntTime(tifstk, labROI);

%% save these raw intensities
filename = [moviepath moviefname];
basefilename = filename(1,1:length(filename)-4);
intensitiesfname = sprintf('%s_RAWints.csv',basefilename);
csvwrite(intensitiesfname,intensities);

%% show all raw intensitites
colororder = [
	0.00  0.00  1.00
	0.00  0.50  0.00 
	1.00  0.00  0.00 
	0.00  0.75  0.75
	0.75  0.00  0.75
	0.75  0.75  0.00 
	0.25  0.25  0.25
	0.75  0.25  0.25
	0.95  0.95  0.00 
	0.25  0.25  0.75
	0.75  0.75  0.75
	0.00  1.00  0.00 
	0.76  0.57  0.17
	0.54  0.63  0.22
	0.34  0.57  0.92
	1.00  0.10  0.60
	0.88  0.75  0.73
	0.10  0.49  0.47
	0.66  0.34  0.65
	0.99  0.41  0.23
];

figure;
set(gca, 'ColorOrder', colororder);
hold all
[nrows, ncols] = size(intensities);
for i = 1:nrows
    plot(intensities(i,:));
end
legend show Location NorthEastOutside;
title('Raw Fluorescence Intensities');
hold off

%% DeltaF/F
% variables
% this part is for choosing how much variance is too much
% show variance in all ROIs of a movie

% These variables will be used for the rest of the analysis
window = 100;
step = 25;
[nrows, ncols] = size(intensities);
numSteps = (length(intensities)/step)-1;

%% Standard Deviation Calculation
% Calculate standard deviations of different, overlapping windows over each
% fluorescence trace
% also, there must be a mathematical way to calculate the length of the sd
% matrix at the beginning, but I can't think of it right now
%
%   sd: matrix (numROIs x numSteps)
idx = 0;
i = 1;
first = idx+1;
last = idx+window; 
%sd = zeros(nrows,numSteps);
while last <= length(intensities)
    % calculate stdev along a row, within the window
    sd(:,i) = std(intensities(:,first:last),0,2);  
    % move the index, window, and counter (i) up
    idx = idx+step;
    first = idx+1;
    last = idx+window;
    i = i+1;
end
% evaluate the rest of the intensities if needed
first = last+1;
last = length(intensities);
if first<=last
    sd(:,i) = std(intensities(:,first:last),0,2); 
end

% FIGURE: all the standard deviations
figure;
set(gca, 'ColorOrder', colororder);
hold all
[nrows, ncols] = size(sd);
for i = 1:nrows
    scatter((1:length(sd)),sd(i,:));
end
legend show Location NorthEastOutside;
title('Standard deviation of intensities in time windows');
hold off

%% Calculating baseline fluorescence (Fo) and delta F over F
% Not sure if I can make this more elegant, but it doesn't seem to take too
% long as it is. 

% Use the same window and step sizes as before. This is necessary because
% the size of the standard deviation matrix is based on the original window
% and step sizes.

% create an empty matrix (fos), the same size as the intensities matrix, to
% record baseline fluorescence for each data point
[nrows, ncols] = size(intensities);
fos = zeros(nrows,ncols);

% so.... threshold for how much variance is too much?
% Not sure the best way to calculate baseline.
% In this case, I set a different threshold for each fluorescence trace
% based on the median of the standard deviations.
thresh = zeros(nrows,1);
for i = 1:nrows
    thresh(i,1) = median(sd(i,:));
end
thresh

% Or just ask...
%prompt = 'What is the variance threshold for calculating baseline fluorescence? ';
%thresh = input(prompt);

% Go through each overlapping window until you get almost to the end
idx = 0;
i = 1;
first = idx+1;
last = idx+window;
while last <= length(intensities)
    % and pull out all standard deviations
    currsd = sd(:,i);
        % go through each time unit in that window (j) and each trace in
        % that time unit (k)
        for j = first:last
            for k = 1:nrows
                % see if that standard deviation is under the threshold,
                % and, if it is, record the mean intensity in that window
                % as the baseline fluorescence (Fo). 
                if currsd(k) <= thresh(k)
                    fos(k,j) = mean(intensities(k,first:last),2);
                end
                % if the standard deviation was above threshold, the Fo
                % remains 0, to be filled in at the next step (again not
                % ideal)
            end
        end
    % move the index up by the step size
    idx = idx+step;
    first = idx+1;
    last = idx+window;
    i = i+1;
end
% get the last part of the traces if necessary
first = last+1;
last = length(intensities);
if first <= last
    currsd = sd(:,i);
    for k = 1:nrows
        if currsd(k) <= thresh(k)
            fos(k,j) = mean(intensities(k,first:last),2);
        end
    end
end

% FIGURE: raw Fos as scatterplot
figure;
set(gca, 'ColorOrder', colororder);
hold all
[nrows, ncols] = size(fos);
for i = 1:nrows
    scatter(1:ncols,fos(i,:));
end
legend show Location NorthEastOutside;
title('raw Fos');
hold off

%% Fill in the 0s in the baseline fluorescence trace

% % go through each trance and replace any 0 in the row with the mean of 
% % all the non-zero units in the row
% for i = 1:nrows
%     % make a copy of the row
%     temp = fos(i,:);
%     temp(temp == 0) = mean(temp(temp ~= 0),2);
%     % assign this back to the baseline fluorescence matrix
%     fos(i,:) = temp;
% end

% use linear regression to fit each trace to a line.
% use these lines as the baseline fluorescence

figure;
set(gca, 'ColorOrder', colororder);
hold all
[nrows, ncols] = size(fos);
foCurves = zeros(nrows,ncols);
for i = 1:nrows
    % make a copy of the row
    temp = fos(i,:);
    x = find(temp);
    y = temp(temp~=0);
    p = polyfit(x,y,2); % what order polynomial? probably 1 or 2.
    x2 = 1:1:2500;
    y2 = polyval(p,x2);
    foCurves(i,:) = y2;
    plot(x,y,'o',x2,y2);
end
%legend show Location NorthEastOutside;
title('curved fitted to baseline fluorescences');
hold off

%%
% FIGURE: final Fos as scatterplot
% figure;
% set(gca, 'ColorOrder', colororder);
% hold all
% [nrows, ncols] = size(fos);
% for i = 1:nrows
%     scatter(1:ncols,fos(i,:));
% end
% legend show Location NorthEastOutside;
% title('final baseline fluorescence');
% hold off

%% F minus Fo over F (deltaF/F)
% finally calculate delta F over F for all ROIs and all points in time

%dfof = (intensities - fos)./intensities;
dfof = (intensities - foCurves)./intensities;

% FIGURE: deltaF/F as line plot
figure;
set(gca, 'ColorOrder', colororder);
hold all
[nrows, ncols] = size(dfof);
for i = 1:nrows
    plot(1:ncols,dfof(i,:));
end
legend show Location NorthEastOutside;
title('deltaF/F');
hold off

%% My test! using deconvolution to estimate spike train
% set simulation metadata
% J Neurophysiol 104: 3691?3704, 2010.
% First published June 16, 2010; doi:10.1152/jn.01073.2009.
% Vogelstein et al 2009
% "Fast Nonnegative Deconvolution for Spike Train Inference From Population
% Calcium Imaging"
%
% Code here: https://github.com/jovo/oopsi

T       = 2500; % # of time steps
V.dt    = 1/10; % time step size

F = dfof(4,:);
[n_best, P_best, V, C]=fast_oopsi(F,V);

plot(n_best);













