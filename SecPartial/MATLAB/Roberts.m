a = imread("yulin.jpg");
figure(1), imshow(a), title('Imagen Original');
c = rgb2gray(a);
[u, v] = size(c);
figure(2), imshow(c), title('Imagen Gris');
d = c;
e = c;
qr = double(c(:, :, 1));
mascaraH = [0 -1; 1 0];
mascaraV = [-1 0; 0 1];

for i=2:u-1
    for j=2:v-1
        ventanaH = qr(i:i+1, j-1:j);
        ventanaV = qr(i-1:i, j-1:j);
        prodH = ventanaH.*mascaraH;
        prodV = ventanaV.*mascaraV;
        d(i, j, :) = sum(sum(prodH));
        e(i, j, :) = sum(sum(prodV));
    end
end

figure(3), imshow(d), title('Filtro Roberts H');
figure(4), imshow(e), title('Filtro Roberts V');