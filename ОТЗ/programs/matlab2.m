% Загрузка изображения 'Pic_pr3_1.bmp'
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

% Удаление шума с помощью морфологической операции
se = strel('disk', 3);
redMaskClosed = imopen(redMask, se);

imshow(originalImage)

% Нахождение свойств для каждого красного объекта
properties = regionprops(L, 'BoundingBox', 'Area', 'Eccentricity', 'Perimeter', 'Centroid');

% Инициализация переменной для подсчета красных квадратов
numRedSquares = 0;

% Анализ каждого красного объекта
for k = 1:length(properties)
    % Получение координат ограничивающего прямоугольника и площади
    boundingBox = properties(k).BoundingBox;
    area = properties(k).Area;
perimeter = properties(k).Perimeter;
    eccentricity = properties(k).Eccentricity;
    circularity = (4 * pi * area)/(perimeter^2);
    
    % Вычисление соотношения сторон ограничивающего прямоугольника
    width = boundingBox(3);
    height = boundingBox(4);
    aspectRatio = width / height;
    
    % Проверка, является ли объект квадратом и не кругом
    if aspectRatio > 0.9 && aspectRatio < 1.1  && circularity < 0.9
        % Увеличение количества красных квадратов
        numRedSquares = numRedSquares + 1;
        
        % Обведение квадрата зелёной линией
        rectangle('Position', boundingBox, 'EdgeColor', 'g', 'LineWidth', 2);
    end
end

% Вывод количества красных квадратов
disp(['Количество красных квадратов: ' num2str(numRedSquares)]);



