function [ locs1, locs2] = matchPicsSurf( I1, I2 )
%MATCHPICS Extract features, obtain their descriptors, and match them!

%% Convert images to grayscale, if necessary
%When is it necessary to convert to greyscale?
I1 = convertIfRGB(I1);
I2 = convertIfRGB(I2);

%% Detect features in both images
det1 = detectSURFFeatures(I1);
det2 = detectSURFFeatures(I2);

%% Obtain descriptors for the computed feature locations
[desc1, locs1] = extractFeatures(I1, det1.Location, 'Method', 'SURF');
[desc2, locs2] = extractFeatures(I2, det2.Location, 'Method', 'SURF');



%% Match features using the descriptors
threshold = 0.85;
matches = matchFeatures(desc1, desc2, 'MatchThreshold', threshold, 'Unique',true, 'MaxRatio', 0.70);

locs1 = locs1(matches(:,1),:);
locs2 = locs2(matches(:,2),:);

%showMatchedFeatures(I1, I2, locs1, locs2, 'montage')
end