% Read the image
image = imread('yulin.jpeg');  % Replace 'image.jpg' with the actual image file name

% Apply Gaussian filter with a specified standard deviation
sigma = 1;  % Adjust the standard deviation as desired
filtered_image = imgaussfilt(image, sigma);

figure(1), imshow(image);
figure(2), imshow(filtered_image);

% Save the image to a file
filename = 'y.jpg';  % Specify the desired file name and extension
imwrite(filtered_image, filename);