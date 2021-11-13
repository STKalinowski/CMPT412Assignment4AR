function [ composite_img ] = compositeH( H2to1, template, img )
%COMPOSITE Create a composite image after warping the template image on top
%of the image using the homography

% Note that the homography we compute is from the image to the template;
% x_template = H2to1*x_photo
% For warping the template to the image, we need to invert it.
H2to1 = inv(H2to1);
%% Create mask of same size as template

mask = double(ones(size(template(:,:,1))));

%% Warp mask by appropriate homography
maskWarped = warpH(mask, H2to1, size(img));

%% Warp template by appropriate homography
templateWarped = warpH(template, H2to1, size(img));

%% Use mask to combine the warped template and the image
composite_img = img.*uint8(~maskWarped) + templateWarped.*uint8(maskWarped);

end