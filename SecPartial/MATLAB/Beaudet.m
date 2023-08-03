close all; clear all; clc;

Iorig = imread("triangle.jpg");
Im = double(rgb2gray(Iorig));
h = ones(3)/9;
Im = imfilter(Im, h);
sx = [-1, 0, 1; -2, 0, 2; -1, 0, 1];
sy = [-1, -2, -1; 0, 0, 0; 1, 2, 1];
Ix = imfilter(Im, sx);
Iy = imfilter(Im, sy);
Ixx = imfilter(Ix, sx);
Iyy = imfilter(Iy, sy);
Ixy = imfilter(Ix, sy);
A = Ixx.*Iyy - (Ixy).^2;
B = (1 + Ix.*Ix + Iy.*Iy).^2;
B = (A./B);
B = (1000/max(max(B)))*B;
V1 = (B)>10;
pixel = 10;
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
            tmp = B(I1:I2, I3:I4);
            maxim = max(max(tmp));

            if(maxim == B(r, c))
                res(r, c) = 1;
            end
        end
    end
end

imshow(uint8(Im)), title('Operador Beaudet');
hold on;
[re, co] = find(res');
plot(re, co, '+');