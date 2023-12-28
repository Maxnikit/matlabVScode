% Загрузка изображения 'Pic_pr3_1.bmp'
originalImage = imread('Pic_pr3_1.bmp');

% Определение цветов в изображении
redChannel = originalImage(:, :, 1); % Извлечение красного канала
greenChannel = originalImage(:, :, 2); % Извлечение зеленого канала
blueChannel = originalImage(:, :, 3); % Извлечение синего канала

% Создание маски для голубых обьектов
blueMask = blueChannel > redChannel & blueChannel > greenChannel;

% Удаление шума с помощью морфологической операции
se = strel('disk', 3);
blueMaskCleaned = imopen(blueMask, se);

% Нахождение контуров голубых объектов
[B,L] = bwboundaries(blueMaskCleaned, 'noholes');

% Отображение изображения с выделенными голубыми объектами
imshow(originalImage);
hold on;
for k = 1:length(B)
    boundary = B{k};
    plot(boundary(:,2), boundary(:,1), 'b', 'LineWidth', 2); % Рисуем границы синим цветом
end

title('Голубые объекты');

properties = regionprops(L, 'Orientation', 'Centroid');

for k = 1:length(properties)
    orientation = properties(k).Orientation;
    centroid = properties(k).Centroid;
    text(centroid(1), centroid(2), sprintf('Orientation: %.2f', orientation), ...
        'Color', 'r', 'FontSize', 10, 'FontWeight', 'bold');
end
