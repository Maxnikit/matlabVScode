syms s;
S=(1*(s^3))+(2*(s^2))+(2*s)+(1)==0;
% Оценка устойчивости динамической системы через корневой метод
coefficients = [1, 2, 2, 1]; % Коэффициенты полинома характеристического уравнения
rootsOfSystem = roots(coefficients); % Вычисление корней характеристического уравнения

% График корней на комплексной плоскости
figure;
plot(real(rootsOfSystem), imag(rootsOfSystem), 'rx');
xlabel('Real Part');
ylabel('Imaginary Part');
title('Root Locus of the System');
grid on;
axis equal;

% Проверка устойчивости системы
if all(real(rootsOfSystem) < 0)
    stability = 'Система устойчива.';
else
    stability = 'Система неустойчива.';
end
disp(stability);
% Adding X and Y axes to the graph
ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';

% Plotting arrows from the origin to each root
hold on; % Ensure that we don't overwrite the existing plot
for i = 1:length(rootsOfSystem)
    quiver(0, 0, real(rootsOfSystem(i)), imag(rootsOfSystem(i)), 'MaxHeadSize', 0.5, 'AutoScale', 'off', 'Color', 'b');
end
hold off;
