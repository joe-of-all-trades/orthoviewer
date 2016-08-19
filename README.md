# orthoviewer
Orthoviewer displays orthogonal views of an image stack

Example: 

close all
clear
load mri

D = squeeze(D);

D2 = zeros(size(D).*[4 4 1], 'uint8');

% Resize image data to make it larger
for ii = 1: size(D,3)
    D2(:, :, ii) = imresize(D(:, :, ii), 4);
end

D3 = zeros(size(D2).*[1 1 4], 'uint8');
for ii = 1 : size(D2, 2)
    D3(:, ii, :) = imresize(squeeze(D2(:, ii, :)),...
        [ size(D2,1), size(D2, 3)*4 ]);
end

orthoviewer(D3)
