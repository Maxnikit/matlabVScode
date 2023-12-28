% Загрузка изображения 'Pic_pr3_1.bmp'
originalImage = imread('Pic_pr3_1.bmp');

% Преобразование изображения в пространство цветов HSV
hsvImage = rgb2hsv(originalImage);
% Определяем пороги для синего цвета
hueThresholdLow = 0.5;    
hueThresholdHigh = 0.67;   
saturationThresholdLow = 0.5; 
valueThresholdLow = 0.5;      

% Создание масок для выделения синего цвета
blueMask = (hsvImage(:,:,1) >= hueThresholdLow) & ...
            (hsvImage(:,:,1) <= hueThresholdHigh) & ...
            (hsvImage(:,:,2) >= saturationThresholdLow) & ...
            (hsvImage(:,:,3) >= valueThresholdLow);

% Удаление шума с помощью морфологической операции
se = strel('disk', 3);
blueMaskCleaned = imopen(blueMask, se);

% Отображение изображения с выделенными голубыми объектами
imshow(originalImage);
hold on;
title('Голубые объекты');

% Проверяем параметр Orientation у каждого обьекта и пишем его
properties = regionprops(L, 'Orientation', 'Centroid');

for k = 1:length(properties)
    orientation = properties(k).Orientation;
    centroid = properties(k).Centroid;
    text(centroid(1), centroid(2), sprintf('Orientation: %.2f', orientation), ...
        'Color', 'r', 'FontSize', 14, 'FontWeight', 'bold');
end
% Нахождение объекта с наименьшим углом наклона по модулю
[minOrientationValue, minOrientationIndex] = min(abs([properties.Orientation]));

% Выделение объекта с наименьшим углом наклона чёрной рамкой
minBoundary = B{minOrientationIndex};
plot(minBoundary(:,2), minBoundary(:,1), 'k', 'LineWidth', 3);

hold off