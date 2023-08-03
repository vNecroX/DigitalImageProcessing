% Impresion de imagen

A = imread("yulin.jpg");    
[M, N] = size(A);    % Dimensiones de la imagen;
disp(N);
N = N/3;
disp(N);
figure(1);   
imshow(A);   

% Optimizacion de codigo, Escala de grises
pesos = [0.2989 0.5870 0.1140];
Apesos = A(:, :, 1)*pesos(1) + A(:, :, 2)*pesos(2) + A(:, :, 3)*pesos(3);
figure(2); 
imshow(Apesos);

% Binarizacion, Blanco y negro
for i=1:M
    for j=1:N
        if Apesos(i, j) <= 128
            Apesos(i, j) = 0;
        else
            Apesos(i, j) = 255;
        end
    end
end

figure(3);
imshow(Apesos);