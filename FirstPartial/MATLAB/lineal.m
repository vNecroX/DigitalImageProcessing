function ecualizar = lineal(u)

[F, C] = size(u);
pixmax = 256;
Tam = zeros(pixmax);

for rxp=1:F
    for ryp=1:C
        rxyp=u(rxp, ryp);

        for val=1:pixmax
            if rxyp==val
                Tam(val)=Tam(val) + 1;
            end
        end
    end
end

inh = 1:256;

for rxs=1:F
    for rys=1:C
        ac = u(rxs, rys);
        if ac==val
            inh(rxs, rys) = Tam(ac + 1)*(255/F*C);
        end
    end
end

val = 288 - inh;
ecualizar(:, 1) = inh;
ecualizar(:, 2) = val;