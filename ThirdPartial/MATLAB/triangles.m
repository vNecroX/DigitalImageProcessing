img = imread('triangles.png');
gray = rgb2gray(img);
filtered = imfilter(gray, fspecial('gaussian'));
edges = edge(filtered);
[boundaries, ~] = bwboundaries(edges, 'noholes');

imshow(img), hold on
for k = 1:length(boundaries)
    boundary = boundaries{k};
    plot(boundary(:,2), boundary(:,1), 'g', 'LineWidth', 2)

    % Classify based on sides amount
    num_points = size(boundary, 1);
    angles = atan2(diff(boundary(:, 1)), diff(boundary(:, 2)));
    angles = mod(angles, 2*pi);  % Convert angles to the range [0, 2*pi)
    angle_changes = angles(2:end) - angles(1:end-1);
    angle_changes = mod(angle_changes, 2*pi);  % Handle wrapping around 2*pi

    num_sides = sum(angle_changes > pi/4);  % Adjust threshold as needed
    if num_sides == 4
        text(boundary(1,2), boundary(1,1), 'Rectangle', 'Color', 'r');
    elseif num_sides == 3
        text(boundary(1,2), boundary(1,1), 'Triangle', 'Color', 'r');
    elseif num_sides > 4
        text(boundary(1,2), boundary(1,1), 'Polygon', 'Color', 'r');
    else
        text(boundary(1,2), boundary(1,1), 'Unknown', 'Color', 'r');
    end
end