figure;
hold on
[nrows, ncols] = size(intensities);
for i = 1:nrows
    plot(intensities(i,:));
end
hold off