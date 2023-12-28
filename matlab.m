clear
%1
% Load the image
originalImage = imread('Pic_pr3_1.bmp');

% Convert to HSV color space to make color segmentation easier
hsvImage = rgb2hsv(originalImage);

% Define thresholds for 'red' color
% Note that red color may span the edges of the hue component in the HSV color space
hueThresholdLow = 0.0; % Adjust as needed
hueThresholdHigh = 0.1; % Adjust as needed
saturationThresholdLow = 0.5; % Adjust as needed
valueThresholdLow = 0.5; % Adjust as needed

% Create masks for red color
redMask = (hsvImage(:,:,1) >= hueThresholdLow) & ...
          (hsvImage(:,:,1) <= hueThresholdHigh) & ...
          (hsvImage(:,:,2) >= saturationThresholdLow) & ...
          (hsvImage(:,:,3) >= valueThresholdLow);

% Perform morphological closing to fill in gaps
se = strel('disk', 3); % Adjust size as needed
redMaskClosed = imclose(redMask, se);

% Label connected components
[labels, numObjects] = bwlabel(redMaskClosed, 8);

% Measure properties of connected components
objectMeasurements = regionprops(labels, 'Area', 'PixelIdxList');

% Find the smallest red object by area
[minArea, idxOfSmallest] = min([objectMeasurements.Area]);

% Create a mask for the smallest object
smallestRedObjectMask = false(size(redMask));
smallestRedObjectMask(objectMeasurements(idxOfSmallest).PixelIdxList) = true;

% Display the original image
subplot(1, 2, 1);
imshow(originalImage);
title('Original Image');

% Overlay the mask of the smallest red object on the original image
smallestRedObjectRgbImage = originalImage;
smallestRedObjectRgbImage(repmat(~smallestRedObjectMask, [1, 1, 3])) = 0;
subplot(1, 2, 2);
imshow(smallestRedObjectRgbImage);
title('Smallest Red Object');


%2
