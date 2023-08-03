im = imread("a.jpg");
[F, C] = size(im);
C = C/3;

for i=1:F
    for j=1:C
        % R'= G' = B' = 0.2126R + 0.7152G + 0.0722B
        x = (im(i, j)*0.299 + im(i, j)*0.587 + im(i, j)*0.114);
        im(i, j, 1) = x;
        im(i, j, 2) = x;
        im(i, j, 3) = x;
    end
end

figure(1);
imshow(im);

pixmax = 256;
Tam = zeros(pixmax);

for rxp=1:F
    for ryp=1:C
        rxyp = im(rxp, ryp);

        for val=1:pixmax
            if rxyp==val
                Tam(val) = Tam(val) + 1;
            end
        end
    end
end

stem(Tam);

% Histograma acumulativo
H = 1:256;
v0 = 0;

for ru=1:255
    H(ru) = v0 + Tam(ru);
    v0 = H(ru);
end

stem(H);

% Histograma ecualizado(lineal)
inh = 1:256;

for rxs=1:F
    for rys=1:C
        ac = im(rxs, rys);
        if ac==val
            inh(rxs, rys) = Tam(ac + 1)*(255/F*C);
        end
    end
end

subplot(3, 2, 1), stem(Tam), title('A');
subplot(3, 2, 2), stem(H), title('B');
subplot(3, 2, 3), stem(inh), title('C');