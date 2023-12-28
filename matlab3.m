% Загрузка изображения 'Pic_pr3_1.bmp'
image = imread('Pic_pr3_1.bmp');

% Определение зеленого цвета в изображении
greenChannel = image(:, :, 2); % Извлечение зеленого канала
redChannel = image(:, :, 1); % Извлечение красного канала
blueChannel = image(:, :, 3); % Извлечение синего канала

% Создание маски для зеленых объектов
greenMask = greenChannel > redChannel & greenChannel > blueChannel;

% Удаление шума с помощью морфологической операции
se = strel('disk', 3);
greenMaskCleaned = imopen(greenMask, se);

% Нахождение контуров зеленых объектов
[B,L] = bwboundaries(greenMaskCleaned, 'noholes');

% Обведение зеленых объектов черной рамкой
imshow(image);
hold on;

% Вычисление минимального расстояния между краями зеленых объектов
minDistance = inf;
closestObjects = [];

% Перебор всех пар зеленых объектов
for i = 1:length(B)
    for j = i+1:length(B)
        boundary1 = B{i};
        boundary2 = B{j};
        
        % Перебор всех точек первого объекта
        for p1 = 1:size(boundary1, 1)
            % Перебор всех точек второго объекта
            for p2 = 1:size(boundary2, 1)
                % Расчет расстояния между точками
                distance = norm(boundary1(p1,:) - boundary2(p2,:));
                % Обновление минимального расстояния и сохранение объектов
                if distance < minDistance
                    minDistance = distance;
                    closestObjects = [i, j];
                end
            end
        end
    end
end

% Вывод результатов
fprintf('Минимальное расстояние между краями зеленых объектов: %f\n', minDistance);
fprintf('Объекты с минимальным расстоянием: %d и %d\n', closestObjects(1), closestObjects(2));
% Проведение линии между ближайшими объектами
boundary1 = B{closestObjects(1)};
boundary2 = B{closestObjects(2)};

% Нахождение крайних точек ближайших объектов
[minDist, minIndex1] = min(pdist2(boundary1, boundary2, 'euclidean'), [], 1);
[~, minIndex2] = min(minDist);

% Координаты ближайших точек на каждом объекте
point1 = boundary1(minIndex1(minIndex2), :);
point2 = boundary2(minIndex2, :);

% Рисование линии между ближайшими точками двух объектов
line([point1(2), point2(2)], [point1(1), point2(1)], 'Color', 'r', 'LineWidth', 2);
