close all; clear all; clc;

Iorig = imread("triangle.jpg");
Im = double(rgb2gray(Iorig));
h = ones(3)/9;
Im = imfilter(Im, h);
d1 = [0, -0.5, 0; -0.5, 0, 0.5; 0, 0.5, 0];
d2 = [0, 1, 0; 1, -4, 1; 0, 1, 0];
I1 = imfilter(Im, d1);
I2 = imfilter(Im, d2);
c = 4;
V = (I2 - c*abs(I1));
V = (1000/max(max(V)))*V;
V1 = (V)>250;
pixel = 40;
[n, m] = size(V1);
res = zeros(n, m);

for r=1:n
    for c=1:m
        if(V1(r, c))
            I1 = [r - pixel, 1];
            I1 = max(I1);
            I2 = [r + pixel, n];
            I2 = min(I2);
            I3 = [c - pixel, 1];
            I3 = max(I3);
            I4 = [c + pixel, m];
            I4 = min(I4);
            tmp = V(I1:I2, I3:I4);
            maxim = max(max(tmp));

            if(maxim == V(r, c))
                res(r, c) = 1;
            end
        end
    end
end

imshow(uint8(Im)), title('Operador Wang & Brady');
hold on;
[re, co] = find(res');
plot(re, co, '+');