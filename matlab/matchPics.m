function [ locs1, locs2] = matchPics( I1, I2 )
%MATCHPICS Extract features, obtain their descriptors, and match them!

%% Convert images to grayscale, if necessary
%When is it necessary to convert to greyscale?
I1 = convertIfRGB(I1);
I2 = convertIfRGB(I2);

%% Detect features in both images
det1 = detectFASTFeatures(I1);
det2 = detectFASTFeatures(I2);

%% Obtain descriptors for the computed feature locations
[desc1, locs1] = computeBrief(I1, det1.Location);
[desc2, locs2] = computeBrief(I2, det2.Location);



%% Match features using the descriptors
threshold = 10.0;
matches = matchFeatures(desc1, desc2, 'MatchThreshold', threshold, 'MaxRatio', 0.80);

locs1 = locs1(matches(:,1),:);
locs2 = locs2(matches(:,2),:);

%showMatchedFeatures(I1, I2, locs1, locs2, 'montage')
end

