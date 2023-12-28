clear
% Загружаем изображение
originalImage = imread('Pic_pr3_1.bmp');

% Переводим в HSV для упрощённой сегментации по цвету
hsvImage = rgb2hsv(originalImage);

%Определяем пороги для красного цвета
hueThresholdLow = 0.0; 
hueThresholdHigh = 0.1; 
saturationThresholdLow = 0.5; 
valueThresholdLow = 0.5;

% Создаём маски для красных обьектов
redMask = (hsvImage(:,:,1) >= hueThresholdLow) & ...
          (hsvImage(:,:,1) <= hueThresholdHigh) & ...
          (hsvImage(:,:,2) >= saturationThresholdLow) & ...
          (hsvImage(:,:,3) >= valueThresholdLow);

% Производим морфологическое закрытие для избавления от щелей
se = strel('disk', 3); 
redMaskClosed = imclose(redMask, se);

% Маркируем обьекты
[labels, numObjects] = bwlabel(redMaskClosed, 8);

% Измеряем площадь и индекс наименьшего обьекта
objectMeasurements = regionprops(labels, 'Area', 'PixelIdxList');

% Выбираем наименьший обьект
[minArea, minAreaIndex] = min([objectMeasurements.Area]);

% Выделяем наименьший объект черной рамкой
smallestObjectBoundary = bwboundaries(labels == minAreaIndex);
boundary = smallestObjectBoundary{1};
imshow(originalImage);
hold on;
plot(boundary(:,2), boundary(:,1), 'k', 'LineWidth', 4); % Рисуем границы черным цветом

% Отображение площади на каждом красном объекте
for k = 1:numObjects
    objectArea = objectMeasurements(k).Area;
    centroid = regionprops(labels == k, 'Centroid');
    text(centroid.Centroid(1), centroid.Centroid(2), num2str(objectArea), ...
         'Color', 'w', 'FontSize', 10, 'FontWeight', 'bold');
end
hold off;
