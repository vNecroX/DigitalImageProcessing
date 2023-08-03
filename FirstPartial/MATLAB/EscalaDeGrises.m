% Impresion de imagen
A = imread("yulin.jpg");    % Leer imagen
[M, N] = size(A);    % Dimensiones de la imagen;
disp(N);
N = N/3;
disp(N);
figure(1);    % Imprime la foto en figura 1
imshow(A);    % Muestra imagen

% Escala de grises  % (x1 + x2 + x3)/3
I = imread("yulin.jpg");

for i=1:M
    for j=1:N
        % R'= G' = B' = 0.2126R + 0.7152G + 0.0722B
        x = (I(i, j)*0.299 + I(i, j)*0.587 + I(i, j)*0.114);
        I(i, j, 1) = x;
        I(i, j, 2) = x;
        I(i, j, 3) = x;
    end
end

figure(2);
imshow(I);