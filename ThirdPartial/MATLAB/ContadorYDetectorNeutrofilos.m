% Leer la imagen
imagen = imread("muestraDeSangre.jpg");

% Redimensionar la imagen al tamaño deseado
imagenRedimensionada = imresize(imagen, 2);

% Convertir la imagen redimensionada al espacio de color HSV
% HSV se enfoca en las características perceptuales del color permitiendo 
% un mayor control y separación de las características cromáticas, la intensidad y la
% luminosidad de los propios colores.
imagenHSV = rgb2hsv(imagenRedimensionada);
% Realizar segmentación basada en color para extraer regiones de neutrófilos
% Ajustar el umbral para el canal de matiz sirve para controlar qué rango
% de colores considerar como neutrofilos
umbralMatiz = 0.2;
% Ajustar el umbral para el canal de saturación sirve para controlar qué nivel 
% de intensidad de color considerar como neutrofilos
umbralSaturacion = 0.5; 
% Ajustar el umbral para el canal de valor sirve para controlar qué nivel 
% de brillo considerar como neutrofilos
umbralValor = 0.5; 

mascaraNeutrofilos = (imagenHSV(:, :, 1) > umbralMatiz) & ... % Posición del color en la rueda cromática
                     (imagenHSV(:, :, 2) > umbralSaturacion) & ... % Pureza o intensidad del color
                     (imagenHSV(:, :, 3) > umbralValor); %  Brillo o la luminosidad del color

% Realizar operaciones morfológicas para mejorar los bordes de los neutrófilos
elementoEstructurante = strel('disk', 14); % Ajustar el tamaño del elemento estructurante
mascaraDilatada = imdilate(mascaraNeutrofilos, elementoEstructurante); % Operación de dilatación
mascaraErosionada = imerode(mascaraDilatada, elementoEstructurante); % Operación de erosión

% Realizar detección de bordes en los bordes de los neutrófilos mejorados
imagenBordes = edge(mascaraErosionada, 'Canny');

% Visualización de los neutrófilos detectados a partir de sus bordes
figure(1);
imshow(imagenBordes);
title('Visualización de los neutrófilos detectados a partir de su segmentación')

% Convertir la imagen de bordes a uint8
imagenBordes = uint8(imagenBordes);

% Aplicar análisis de componentes conectados para etiquetar e identificar los neutrófilos individuales
[imagenEtiquetada, numNeutrofilos] = bwlabel(imagenBordes);

% Contar el número de neutrófilos detectados dentro de un rango de radios determinado
radioMinimo = 10; % Radio mínimo para filtrar regiones pequeñas
radioMaximo = 30; % Radio máximo para filtrar regiones grandes
contadorNeutrofilos = 0;

% Visualización de los neutrófilos detectados: dibujar cuadros delimitadores y anotaciones
figure(2);
imshow(imagenRedimensionada);
hold on;

% Iterar a través de cada región de neutrófilos etiquetada
for i = 1:numNeutrofilos
    % Extraer las propiedades de la región de neutrófilos actual
    propiedadesRegion = regionprops(imagenEtiquetada == i, 'BoundingBox', 'EquivDiameter');
    cuadroDelimitador = propiedadesRegion.BoundingBox;
    diametro = propiedadesRegion.EquivDiameter;
    
    % Verificar si la región se encuentra dentro del rango de radios deseado
    if diametro >= radioMinimo && diametro <= radioMaximo
        contadorNeutrofilos = contadorNeutrofilos + 1;
        
        % Dibujar un cuadro delimitador alrededor del neutrófilo
        rectangle('Position', cuadroDelimitador, 'EdgeColor', 'g', 'LineWidth', 2);
        text(cuadroDelimitador(1), cuadroDelimitador(2) - 5, ...
             num2str(contadorNeutrofilos), 'Color', 'black', 'FontSize', 12, 'FontWeight', 'normal');
        drawnow; % Actualizar la figura
    end
end

hold off;

% Mostrar el recuento final de neutrófilos dentro del rango de radios deseado
disp(['Número total de neutrófilos detectados: ', num2str(contadorNeutrofilos)]);
title(['Neutrófilos detectados: ', num2str(contadorNeutrofilos)]);