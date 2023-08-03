% Funcion que permite generar los puntos del histograma acumulativo a
% partir del vector 1xN entregado por el bloque "2-D Histogram".
function union = concatena1(u)

% La funcion recibe en u el vector 1xN. Se genera el vector num que
% especifica el valor de la abscisa.
num = 1:256;

% Se inicializa la variable utilizada para la recursion a cero.
va = 0;

% Se aplica el modelo definido en la Ecuacion 3.2.
for v = 1:256
    H(v) = va + u(v);
    va = H(v);
end

% El valor del vector 1xN (u) se escala y se le resta un valor para generar
% el efecto grafico. Se escala porque normalmente el valor entregado por el
% bloque "2-D Histogram" esta normalizado, en este caso 200 es una buena 
% opcion para la visualizacion.
val = 288 - (H*200);

% Se empaquetan los datos que seran los puntos entregados al bloque "Draw 
% Markers" para graficarlos sobre una imagen sintetica como tapete.
union(:, 1) = num;
union(:, 2) = val;