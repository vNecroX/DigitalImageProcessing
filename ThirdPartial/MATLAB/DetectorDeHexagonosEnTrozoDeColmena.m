image = imread("g.jpg");      % gg.png
image = imresize(image, 2);   % Redimensionar la imagen al doble de su tamaño original 0.6
figure(1);
imshow(image);
title('Imagen Original');

grayImage = rgb2gray(image);  % Convertir la imagen RGB a escala de grises
enhancedImage = histeq(grayImage);  % Mejorar el contraste utilizando histograma ecualizado
edgeImage = edge(enhancedImage, 'Canny');  % Aplicar el algoritmo de detección de bordes Canny

% Realizar etiquetado de componentes conectados en la imagen de bordes para identificar objetos distintos 
% y obtener el número total de componentes
[labeledImage, numComponents] = bwlabel(edgeImage);

% Aplicar la segmentación binaria a los bordes detectados, aqui los bordes son segmentados como regiones 
% blancas y por su parte el fondo de la imagen es de color negro 
binaryImage = labeledImage > 0;

% Propiedades de región (área, excentricidad, cuadro delimitador) para cada componente etiquetado
stats = regionprops(binaryImage, 'Area', 'Eccentricity', 'BoundingBox');
areas = [stats.Area];  % Extraer los valores de área para cada componente etiquetado
eccentricities = [stats.Eccentricity];  % Extraer los valores de excentricidad para cada componente etiquetado

disp(areas);
disp(eccentricities);

% Ajustar las condiciones con base a las propiedades de los hexágonos, esto con el fin de encontrar los 
% índices de los componentes que cumplen las condiciones de área y excentricidad para los hexágonos.
% Area dada por la propia imagen con proporcion a la cantidad de hexagonos
% Excentricidad cercana a 0 se acerca a un circulo, cercana a 1 se acerca a un objeto con forma irregular
hexIndices = find(areas > 100 & eccentricities < 0.99); 

numHexs = length(hexIndices);  % Obtener el número de hexágonos

% Inicializar una matriz para almacenar las coordenadas centrales de los hexágonos
hexsCoordinates = zeros(numHexs, 2);

for i = 1:numHexs
    boundingBox = stats(hexIndices(i)).BoundingBox;  % Obtener el cuadro delimitador del hexágono

    % Calcular la coordenada central del hexágono
    center = [boundingBox(1) + boundingBox(3)/2, boundingBox(2) + boundingBox(4)/2];  

    hexsCoordinates(i, :) = center;  % Almacenar la coordenada central en la matriz hexsCoordinates
end

% Clustering DBSCAN (Density-Based Spatial Clustering of Applications with Noise) es un algoritmo 
% de agrupamiento o clustering basado en la densidad espacial de los puntos en un conjunto de datos
epsilon = 5;  % Ajustar el valor de épsilon en función de la proximidad de los hexágonos
minPts = 1;  % Ajustar el número mínimo de puntos requeridos para formar un clúster

% Aplicar el clustering DBSCAN a las coordenadas de los hexágonos utilizando los parámetros especificados
[idx, ~] = dbscan(hexsCoordinates, epsilon, minPts);  

% Eliminar índices de clúster duplicados y actualizar el número de hexágonos
uniqueClusters = unique(idx);  % Obtener los índices de clúster únicos
hexsClustersCount = length(uniqueClusters);  % Obtener la cantidad de clústeres únicos

figure(2);
imshow(binaryImage);
hold on;

% Generar colores distinguibles para los clústeres en función del número de clústeres
clusterColors = generateColors(hexsClustersCount);  

% Dibujar rectángulos alrededor de los hexágonos detectados
for i = 1:numHexs
    clusterIdx = find(uniqueClusters == idx(i));  % Obtener el índice del clúster al que pertenece el hexágono
    
    % Si el índice es diferente de -1, significa que idx(i) pertenece a un cluster
    if clusterIdx ~= -1
        boundingBox = stats(hexIndices(i)).BoundingBox;  % Obtener el cuadro delimitador del hexágono

        % Dibujar un rectángulo alrededor del hexágono con el color correspondiente al clúster
        rectangle('Position', boundingBox, 'EdgeColor', clusterColors(clusterIdx, :), 'LineWidth', 2);

        pause(0.015); % Retardo
    end
end

hold off;

title(['Imagen Original con detección de Hexágonos. (Número de Hexágonos detectados: ', num2str(numHexs), ')']);
disp(['Número de Hexágonos detectados: ', num2str(numHexs)]);

function colors = generateColors(numColors)
    % Generar colores distinguibles utilizando el espacio de color HSV
    saturation = 0.8;  % Establecer el valor de saturación para los colores
    brightness = 0.8;  % Establecer el valor de brillo para los colores
    step = 1 / numColors;  % Calcular el tamaño del paso para generar los colores
    
    colors = zeros(numColors, 3);  % Inicializar una matriz para almacenar los colores generados

    for i = 1:numColors
        hue = mod(i * step, 1);  % Calcular el valor de tonalidad en función del paso y el índice

        % Convertir el color HSV a RGB y almacenarlo en la matriz colors
        colors(i, :) = hsv2rgb([hue, saturation, brightness]);  
    end
end