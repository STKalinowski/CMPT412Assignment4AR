% Your solution to Q2.1.5 goes here!
threshold = 10.0;
cv_img = imread('../data/cv_cover.jpg');

disp(cv_img);
imshow(cv_img);
for i = 0:36
    %% Rotate image
    rot_img = imrotate(cv_img, 10*i);
    disp(i);
    imshow(rot_img, []);

    
end
