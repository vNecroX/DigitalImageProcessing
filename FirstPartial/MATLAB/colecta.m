% Funcion que genera los puntos a partir del vector 1xN que se obtiene del
% bloque "Histogram"
function data = colecta(u)

% La funcion recibe en u el vector 1xN. Se genera el vector num que
% especifica el valor de la abscisa.
num = 1:256;

% El valor del vector 1xN (u) se escala y se le resta un valor para generar
% el efecto grafico. Esto se hace debido a qu el valor entregado por el
% bloque "Histogram" esta normalizado (0-1), en este caso se le dio una
% ganancia de 5000.
val = 288 - (u*5000);

% Se empaquetan los datos en la variable data, los cuales seran puntos
% entregados al bloque "Draw Markers" para graficarlos sobre una imagen
% sintetica como fondo.
data(:, 1) = num;
data(:, 2) = val;