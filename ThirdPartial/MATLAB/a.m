clear all; close all; clc;

ib = imread("test.png");
ib = imresize(ib, 0.5); % Factor by two
ib = rgb2gray(ib);
ib = imbinarize(ib, 0.5);
ib = imcomplement(ib); % Opposite
figure(1);
imshow(ib);

[m, n] = size(ib);
ibd = double(ib);

% PASO 1 SE ASIGNAN ETIQUETAS INICIALES, SE ASIGNAN LAS VARIABLES PARA
% ETIQUETAR LAS "COLISIONES"

e = 2;
k = 1;

for r=2:m-1
    for c=2:n-1
        if(ibd(r, c) == 1)
            if((ibd(r, c - 1) == 0) && (ibd(r - 1, c) == 0))
                ibd(r, c) = e;
                e = e + 1; 
            end
        
            if(((ibd(r, c - 1) > 1) && (ibd(r - 1, c) < 2)) || ((ibd(r, c - 1) < 2) && (ibd(r - 1, c) > 1)))
                if(ibd(r, c - 1) > 1)
                    ibd(r, c) = ibd(r, c - 1);
                end
    
                if(ibd(r - 1, c) > 1)
                    ibd(r, c) = ibd(r - 1, c);
                end
            end

            if((ibd(r, c - 1) > 1) && (ibd(r - 1, c) > 1))
                ibd(r, c) = ibd(r - 1, c);
    
                if((ibd(r, c - 1)) ~= (ibd(r - 1, c)))
                    ec1(k) = ibd(r - 1, c);
                    ec2(k) = ibd(r, c - 1);
                    k = k + 1;
                end
            end
        end
    end
end

% PASO 2 SE RESUELVEN COLISIONES

for ind=1:k-1
    if(ec1(ind) <= ec2(ind))
        for r=1:m
            for c=1:n
                if(ibd(r, c) == ec2(ind))
                    ibd(r, c) = ec1(ind);
                end
            end
        end
    end

    if(ec1(ind) > ec2(ind))
        for r=1:m
            for c=1:n
                if(ibd(r, c) == ec1(ind))
                    ibd(r, c) = ec2(ind);
                end
            end
        end
    end
end

w = unique(ibd);
t = length(w);

% PASO 3 RE-ETIQUETADO DE LA IMAGEN
% SE RE-ETIQUETAN LOS PIXELES CON LOS VALORES MINIMOS

areas = zeros(1, t);

for r=1:m
    for c=1:n
        for ix=2:t
            if(ibd(r, c) == w(ix))
                areas(ix) = areas(ix) + 1;
                ibd(r, c) = ix - 1;
            end
        end
    end
end

% SE PREPARAN LOS DATOS PARA DESPLIEGUE
for r=1:m
    for c=1:n
        for nind=1:t-1
            if(ibd(r, c) == nind)
                ibd(r, c) = areas(nind + 1);
            end
        end
    end
end

E = mat2gray(ibd); 
figure(2);
imshow(E);
str = ['EL NUMERO DE OBJETOS ES: ', num2str(t-1)];
title(str);