I = imread("yulin.jpg");
im = rgb2gray(I);
[rows, cols] = size(im);
im = double(im);
imR = im;

for x=2:rows-1
    for y=2:cols-1
        imR(x, y) = 1/9*(im(x-1, y-1) + im(x-1, y) + im(x-1, y+1) ...
                       + im(x, y-1) + im(x, y) + im(x, y+1) ...
                       + im(x+1, y-1) + im(x+1, y) + im(x+1, y+1));
    end
end

imR = uint8(imR);
im = uint8(im);

figure(1), imshow(im), title("Imagen original:");
figure(2), imshow(imR), title("Imagen con filtro de suavizado lineal:");