close all;
clear all;
clc;

% Leer la imagen
A = imread("yulin.jpg");
img = imresize(A, [600 900]);
% Convertir la imagen a escala de grises
grayImg = rgb2gray(img);
% Agregar ruido de sal y pimienta
noisyImg = grayImg;
salt_pepper = rand(size(grayImg));
noisyImg(salt_pepper < 0.05) = 0;
noisyImg(salt_pepper > 0.95) = 255;

[m, n] = size(noisyImg);

% Median filter to noisy image
median = zeros(m, n);
median = uint8(median);

for i=1:m
    for j=1:n
        xmin = max(1, i-1);
        xmax = min(m, i+1);
        ymin = max(1, j-1);
        ymax = min(n, j+1);

        temp = noisyImg(xmin:xmax, ymin:ymax);
        median(i, j) = med(temp(:));
    end
end

% Box filter to noisy image
boxImg = noisyImg;
boxImg = double(boxImg);

for x=2:m-1
    for y=2:n-1
        boxImg(x, y) = 1/9*(boxImg(x-1, y-1) + boxImg(x-1, y) + boxImg(x-1, y+1) ...
                          + boxImg(x, y-1) + boxImg(x, y) + boxImg(x, y+1) ...
                          + boxImg(x+1, y-1) + boxImg(x+1, y) + boxImg(x+1, y+1));
    end
end

boxImg = uint8(boxImg);

% Gaussian filter to noisy image
gaussianMask = [0 1 2 1 0;
                1 3 5 3 1;
                2 5 9 5 2;
                1 3 5 3 1;
                0 1 2 1 0]/57;

im = double(noisyImg);
gaussianImg = im;

for x=3:m-2
    for y=3:n-2
        summ = 0;

        for i=-2:2
            for j=-2:2
                summ = summ + (im(x+i, y+j)*gaussianMask(3+i, 3+j));
            end
        end
        
        gaussianImg(x, y) = summ;
    end
end

gaussianImg = uint8(gaussianImg);

% Laplacian filter to noisy image
laplacianMask = [ 0   0 -1   0  0;
                  0  -1 -2  -1  0;
                 -1  -2  16 -2 -1;
                  0  -1 -2  -1  0;
                  0   0 -1   0  0];

im = double(noisyImg);
laplacianImg = im;

for x=3:m-2
    for y=3:n-2
        summ = 0;

        for i=-2:2
            for j=-2:2
                summ = summ + (im(x+i, y+j)*laplacianMask(3+i, 3+j));
            end
        end
        
        laplacianImg(x, y) = summ;
    end
end

laplacianImg = uint8(laplacianImg);

% Mostrar las imágenes
figure(1);
subplot(1, 2, 1), imshow(grayImg), title('Imagen Gris');
subplot(1, 2, 2), imshow(noisyImg), title('Imagen con ruido Sal & Pimienta');
figure(2);
subplot(1, 2, 1), imshow(median), title('Filtro Mediana');
subplot(1, 2, 2), imshow(boxImg), title('Filtro Box');
figure(3);
subplot(1, 2, 1), imshow(gaussianImg), title('Filtro Gaussiano');
subplot(1, 2, 2), imshow(laplacianImg), title('Filtro Laplaciano');

% Functions  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //  //

function [res] = med(m)
    % Ordena el vector de menor a mayor
    vec_sorted = sort(m);
    % Obtiene el tamaño del vector
    n = length(vec_sorted);
    % Obtiene el índice del elemento central del vector
    if mod(n, 2) == 1
    % Si el vector tiene un número impar de elementos, el índice del elemento central es (n+1)/2
    index = (n+1)/2;
    else
    % Si el vector tiene un número par de elementos, el índice del elemento central es el promedio de los dos índices centrales
    index = [n/2, n/2+1];
    end

    % Calcula el valor de la mediana
    res = mean(vec_sorted(index));
end