A = imread("yulin.jpg");

Canny1(A, 255, 0);

function [Im_bordes] = Canny1(A, TH, TL)
    Im_original = rgb2gray(A);
    Im_mues = Im_original(1:1:end, 1:1:end);
    Im_mues = double(Im_mues);

    % 1. Filtrado.
    H = fspecial('gaussian', [5 5], 1.4);
    filtro = imfilter(Im_mues, H);
    figure;
    imshow(mat2gray(filtro));

    % 2. Calculo del gradiente.
    % Kernel h y v.
    Hx = [-1 0 1; -2 0 2; -1 0 1];
    Hy = [-1 -2 -1; 0 0 0; 1 2 1];

    % Calculo del gradiente en ambas direcciones.
    Gx = abs(imfilter(Im_mues, Hx));
    Gy = abs(imfilter(Im_mues, Hy));

    % 3. Calculo de la magnitud y la direccion.
    Im = sqrt(Gx.^2 + Gy.^2);
    teta = atand(Gy./Gx);
    figure;
    imshow(mat2gray(Im));

    % 4. Redondeo a direcciones.
    in = teta >= 0 & teta<22.5;
    teta(in) = 0; % Direccion horizontal.
    in = teta >= 157.5 & teta<=180;
    teta(in) = 0; % Direccion horizontal.
    in = teta >= 22.5 & teta<=67.5;
    teta(in) = 45; % Direccion diagonal.
    in = teta >= 67.5 & teta<=112.5;
    teta(in) = 90; % Direccion vertical.
    in = teta >= 112.5 & teta<=157.5;
    teta(in) = 135; % Direccion Diagonal.

    % 5. Eliminacion de no maximos.
    [M, N] = size(Im_mues);
    In = zeros(M-2, N-2);
   
    for i=2:M-1
        for j=2:N-1
            switch(teta(i, j))
                case 0 % Comparar vecinos en direccion horizontal
                    [~, m] = max([Im(i, j-1) Im(i, j) Im(i, j+1)]);

                    if m==2 % Si gradiente mayor que los vecinos.
                        In(i-1, j-1) = Im(i, j);
                    end

                case 45 % Comparar vecinos diagonales.
                    [~, m] = max([Im(i+1, j-1) Im(i, j) Im(i-1, j+1)]);

                    if m==2 % Si gradiente mayor que los vecinos.
                        In(i-1, j-1) = Im(i, j);
                    end

                case 90 % Comparar vecinos en direccion vertical.
                    [~, m] = max([Im(i-1, j) Im(i, j) Im(i+1, j)]);

                    if m==2 % Si gradiente mayor que los vecinos.
                        In(i-1, j-1) = Im(i, j);
                    end

                case 135 %C omparar vecinos diagonales.
                    [~, m] = max([Im(i-1, j-1) Im(i, j) Im(i+1, j+1)]);

                    if m==2 % Si gradiente mayor que los vecinos.
                        In(i-1, j-1) = Im(i, j);
                    end
            end
        end
    end

    figure;
    imshow(mat2gray(In));

    % 6. Umbralizacion con histeresis.
    [M, N] = size(In);
    Binaria = zeros(M, N);

    for i=1:M
        for j=1:N
            if In(i, j) >= TH
                Binaria(i, j) = 1;
            elseif In(i, j) > TL && In(i, j) >TH
                Binaria(i, j) = 0.5;
            end
        end
    end

    figure;
    imshow(mat2gray(Binaria));
    Itemp = zeros(M+2, N+2);
    Itemp(2:M+1, 2:N+1) = Binaria;

    for i=2:M
        for j=2:N+1
            if Itemp(i, j) == 0.5
                if (Itemp(i-1, j-1) == 1) || (Itemp(i-1, j) == 1) || (Itemp(i-1, j+1) == 1) || ...
                   (Itemp(i, j-1) == 1) || (Itemp(i, j+1) == 1) || (Itemp(i+1, j-1) == 1) || ...
                   (Itemp(i+1, j) == 1) || (Itemp(i+1, j+1) == 1)
                end

                Binaria(i-1, j-1) = 1;
            end
        end
    end
    Im_bordes = Binaria;
end