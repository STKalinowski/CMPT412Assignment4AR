%Q2.1.4
close all;
clear all;

cv_cover = imread('../data/cv_cover.jpg');
cv_desk = imread('../data/cv_desk.png');


[locs1, locs2] = matchPicsSurf(cv_cover, cv_desk);


%figure;
%showMatchedFeatures(cv_cover, cv_desk, locs1, locs2, 'montage');
%title('Showing all matches');


%### ###
%Get H
h = computeH_ransac(locs1.Location, locs2.Location);
%h = reshape(h2to1,[3,3]).';
s = RandStream('mlfg6331_64');
randIndx = datasample(s,1:size(locs1),10,'Replace', false);
randPoints = locs2(randIndx, :).Location;
refrence = locs1(randIndx, :).Location;
a = size(randPoints);
b = ones(a(1), 1);
randPointsB = [randPoints b].';
disp(randPointsB);
res = h * randPointsB;
res = hom2cart(res.');
disp(res);
disp(refrence);

figure;
imshow(cv_cover);
hold on;
axis on
disp(randPoints(2,:));
for i = 1:size(res)
    plot(res(i,1), res(i,2), 'r+', 'MarkerSize', 20);
end

figure;
imshow(cv_desk);

hold on;
axis on
disp(res(2,:));
for i = 1:size(randPoints)
    plot(randPoints(i,1), randPoints(i,2), 'r+', 'MarkerSize', 20);
end

figure;
imshow(warpH(cv_cover, inv(h), size(cv_desk)));
%Get 10 random points

%Display points on original and after 
% 
% %To cart
% a = size(locs2);
% b = ones(a(1), 1);
% locs2a = [locs2 b].';
% 
% 
% %H*loc2 should = loc1???
% results = h * locs2a;
% d1 = hom2cart(results.');
% %### ###
% h2to1 = computeH_ransac(locs1, locs2);
% results2 = h2to1 * locs2a;
% d2 = hom2cart(results2.');
% 
% % disp(locs1);
% % disp(d1);
% % disp(d2);
% t1 = locs1 - d1;
% t1 = sum(abs(t1), 2);
% t2 = locs1 - d2;
% t2 = sum(abs(t2),2);
% % disp(sum(t1));
% % disp(sum(t2));
% figure;
% imshow(warpH(cv_cover, inv(h2to1), size(cv_desk)))

