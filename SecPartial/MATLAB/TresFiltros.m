I = imread("yulin.jpg");
im = rgb2gray(I);
[rows, cols] = size(im);
im = double(im);
imLinear = im;
imGaussian = im;
imLaplacian = im;

GaussianMask = [0 1 2 1 0;
                1 3 5 3 1;
                2 5 9 5 2;
                1 3 5 3 1;
                0 1 2 1 0]/57;

LaplacianMask = [ 0   0 -1   0  0;
                  0  -1 -2  -1  0;
                 -1  -2  16 -2 -1;
                  0  -1 -2  -1  0;
                  0   0 -1   0  0];

for x=2:rows-1
    for y=2:cols-1
        imLinear(x, y) = 1/9*(im(x-1, y-1) + im(x-1, y) + im(x-1, y+1) ...
                            + im(x, y-1) + im(x, y) + im(x, y+1) ...
                            + im(x+1, y-1) + im(x+1, y) + im(x+1, y+1));
    end
end

for x=3:rows-2
    for y=3:cols-2
        summGaussian = 0;
        summLaplacian = 0;

        for i=-2:2
            for j=-2:2
                summGaussian = summGaussian + (im(x+i, y+j)*GaussianMask(3+i, 3+j));
                summLaplacian = summLaplacian + (im(x+i, y+j)*LaplacianMask(3+i, 3+j));
            end
        end
        
        imGaussian(x, y) = summGaussian;
        imLaplacian(x, y) = summLaplacian;
    end
end

im = uint8(im);
imLinear = uint8(imLinear);
imGaussian = uint8(imGaussian);
imLaplacian = uint8(imLaplacian);

subplot(2,2,1), imshow(im), title("Imagen original:");
subplot(2,2,2), imshow(imLinear), title("Imagen con filtro de suavizado lineal:");
subplot(2,2,3), imshow(imGaussian), title("Imagen con filtro Gaussiano:");
subplot(2,2,4), imshow(imLaplacian), title("Imagen con filtro Laplaciano:");