function [H2to1] = computeH_norm(x1, x2)

%% Compute centroids of the points
a = size(x1);
centroid1 = double(sum(x1) / a(1));
centroid2 = double(sum(x2) / a(1));

%% Shift the origin of the points to the centroid
%With the center point, move that to 0, apply same transformation to the
%other poitns
centTrans1 = [1 0 -centroid1(1); 0 1 -centroid1(2); 0 0 1];
centTrans2 = [1 0 -centroid2(1); 0 1 -centroid2(2); 0 0 1];

%% Normalize the points so that the average distance from the origin is equal to sqrt(2).
%Scale it so average distnace is squareroot(2)
d1 = double(mean( sqrt(x1.^2)));
d2 = double(mean( sqrt(x2.^2)));
scale1 = [sqrt(2)/d1(1) sqrt(2)/d1(2)];
scale2 = [sqrt(2)/d2(1) sqrt(2)/d2(2)];


normTrans1 = [scale1(1) 0 0; 0 scale1(2) 0; 0 0 1];
normTrans2 = [scale2(1) 0 0; 0 scale2(2) 0; 0 0 1];

%% similarity transform 1
T1 =  normTrans1*centTrans1;

%% similarity transform 2
T2 = normTrans2 * centTrans2;

%% Compute Homography
%Convert points to homeographic
b = size(x2);
c = ones(b(1), 1);
x1a = [x1 c].';
x2a = [x2 c].';
%Apply transformation
normX1 = [T1*x1a].';
normX2 = [T2*x2a].';

hofNorm = computeH(normX1(:,1:2), normX2(:,1:2));

%% Denormalization
H2to1 = inv(T1)*hofNorm*T2;

