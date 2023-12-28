% Загрузка изображения 'Pic_pr3_1.bmp'
originalImage = imread('Pic_pr3_1.bmp');

% Сегрегация синего цвета
% Преобразование изображения в пространство цветов HSV
hsvImage = rgb2hsv(originalImage);
% Выделение синего цвета по компоненте Hue
hueThresholdLow = 0.5;     % Нижний порог оттенка для синего цвета
hueThresholdHigh = 0.67;   % Верхний порог оттенка для синего цвета
saturationThreshold = 0.5; % Порог насыщенности для синего цвета
valueThreshold = 0.5;      % Порог яркости для синего цвета

% Создание масок для выделения синего цвета
blueMask = (hsvImage(:,:,1) >= hueThresholdLow) & (hsvImage(:,:,1) <= hueThresholdHigh) & ...
           (hsvImage(:,:,2) >= saturationThreshold) & (hsvImage(:,:,3) >= valueThreshold);
% Удаление шума с помощью морфологической операции
se = strel('disk', 3);
blueMaskCleaned = imopen(blueMask, se);

% Нахождение контуров голубых объектов
[B,L] = bwboundaries(blueMaskCleaned, 'noholes');

% Отображение изображения с выделенными голубыми объектами
imshow(originalImage);
hold on;


title('Голубые объекты');

properties = regionprops(L, 'Orientation', 'Centroid');

for k = 1:length(properties)
    orientation = properties(k).Orientation;
    centroid = properties(k).Centroid;
    text(centroid(1), centroid(2), sprintf('Orientation: %.2f', orientation), ...
        'Color', 'r', 'FontSize', 10, 'FontWeight', 'bold');
end
% Нахождение объекта с наименьшим углом наклона по модулю
[minOrientationValue, minOrientationIndex] = min(abs([properties.Orientation]));

% Выделение объекта с наименьшим углом наклона чёрной рамкой
minBoundary = B{minOrientationIndex};
plot(minBoundary(:,2), minBoundary(:,1), 'k', 'LineWidth', 3);

hold off