% Загрузка изображения 'Pic_pr3_1.bmp'
originalImage = imread('Pic_pr3_1.bmp');

% Преобразование изображения в пространство цветов HSV
hsvImage = rgb2hsv(originalImage);

%Определяем пороги для зелёного цвета
hueThresholdLow = 0.2; 
hueThresholdHigh = 0.5; 
valueThresholdLow = 0.1;

% Создаём маски для зелёных обьектов
greenMask = (hsvImage(:,:,1) >= hueThresholdLow) & ...
            (hsvImage(:,:,1) <= hueThresholdHigh) & ...
            (hsvImage(:,:,3) >= valueThresholdLow);

% Удаление шума с помощью морфологической операции
se = strel('disk', 3);
greenMaskCleaned = imopen(greenMask, se);

% Отображение изображения
imshow(originalImage);
hold on;
title('Зелёные обьекты');

% Проверяем параметр Orientation у каждого обьекта и пишем его
properties = regionprops(L, 'Orientation', 'Centroid');

for k = 1:length(properties)
    orientation = properties(k).Orientation;
    centroid = properties(k).Centroid;
    text(centroid(1), centroid(2), sprintf('Угол наклона: %.2f', orientation), ...
        'Color', 'black', 'FontSize', 12, 'FontWeight', 'bold');
end
% Нахождение объекта с наибольшим углом наклона
[maxOrientationValue, maxOrientationIndex] = max([properties.Orientation]);

% Выделение объекта с наименьшим углом наклона чёрной рамкой
maxBoundary = B{maxOrientationIndex};
plot(maxBoundary(:,2), maxBoundary(:,1), 'k', 'LineWidth', 3);

hold off