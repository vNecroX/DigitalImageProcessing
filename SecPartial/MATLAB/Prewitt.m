clear all; clc;

A = imread("yulin.jpg");
imgr = escalagris(A);
figure('Name','Filtro Prewitt', 'NumberTitle', 'off')
subplot(2, 2, 1);
imshow(imgr), title('Grises Original');
filtrar_prewitt(imgr);

function gris = escalagris(img)
    [r, c, z] = size(img);

    for i=1:r
        for j=1:c
            gris(i, j) = img(i, j, 1)*0.2989 + img(i, j, 2)*0.5870 + img(i, j, 3)*0.1140;
        end
    end
end

function filtrar_prewitt(imgr)
    [m, n] = size(imgr);
    suave = double(imgr);
    Gx = zeros(size(suave));
    Gy = zeros(size(suave));
     
    for r=2:m-1
        for c=2:n-1
            Gx(r, c) = -1*suave(r-1, c-1) - 1*suave(r, c-1) - 1*suave(r+1, c-1) + ... 
                          suave(r-1, c+1) + suave(r, c+1) + suave(r+1, c+1);
            Gy(r, c) = -1*suave(r-1, c-1) - 1*suave(r-1, c) - 1*suave(r-1, c+1) + ...
                          suave(r+1, c-1) + suave(r+1, c) + suave(r+1, c+1);
        end
    end
    
    Gt = sqrt(Gx.^2 + Gy.^2);
    VmaxGt = max(max(Gt));
    GtN = (Gt/VmaxGt)*255;
    GtN = uint8(GtN);
    B = GtN > 100;
    VminGx = min(min(Gx));
    VminGy = min(min(Gy));
    GradOffx = Gx - VminGx;
    GradOffy = Gy - VminGy;
    VmaxGx = max(max(GradOffx));
    VmaxGy = max(max(GradOffy));
    GxN = (GradOffx/VmaxGx)*255;
    GyN = (GradOffy/VmaxGy)*255;
    GxN = uint8(GxN);
    GyN = uint8(GyN);
    subplot(2, 2, 2);
    imshow(GxN), title('Horizontal');
    subplot(2, 2, 3);
    imshow(GyN), title('Vertical');
    subplot(2, 2, 4);
    imshow(GtN), title('Combinado');
end