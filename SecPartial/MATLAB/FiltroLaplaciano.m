I = imread("yulin.jpg");
im = rgb2gray(I);
[rows, cols] = size(im);
im = double(im);
imR = im;

mask = [ 0   0 -1   0  0;
         0  -1 -2  -1  0;
        -1  -2  16 -2 -1;
         0  -1 -2  -1  0;
         0   0 -1   0  0];

for x=3:rows-2
    for y=3:cols-2
        summ = 0;

        for i=-2:2
            for j=-2:2
                summ = summ + (im(x+i, y+j)*mask(3+i, 3+j));
            end
        end
        
        imR(x, y) = summ;
    end
end

imR = uint8(imR);
im = uint8(im);

figure(1), imshow(im), title("Imagen original:");
figure(2), imshow(imR), title("Imagen con filtro Laplaciano:");