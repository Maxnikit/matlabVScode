% Загрузка изображения 'Pic_pr3_1.bmp'
image = imread('Pic_pr3_1.bmp');

% Определение зеленого цвета в изображении
greenChannel = image(:, :, 2); % Извлечение зеленого канала
redChannel = image(:, :, 1); % Извлечение красного канала
blueChannel = image(:, :, 3); % Извлечение синего канала

% Создание маски для красных объектов
redMask = redChannel > greenChannel & redChannel > blueChannel;

% Удаление шума с помощью морфологической операции
se = strel('disk', 3);
redMaskCleaned = imopen(redMask, se);

% Нахождение контуров красных объектов
[B,L] = bwboundaries(redMaskCleaned, 'noholes');

% Обведение красных объектов черной рамкой
imshow(image);
hold on;
for k = 1:length(B)
    boundary = B{k};
    plot(boundary(:,2), boundary(:,1), 'k', 'LineWidth', 2);
end
hold off;

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
        
        % Обведение квадрата красной линией
        rectangle('Position', boundingBox, 'EdgeColor', 'g', 'LineWidth', 2);
    end
end

% Вывод количества красных квадратов
disp(['Количество красных квадратов: ' num2str(numRedSquares)]);



