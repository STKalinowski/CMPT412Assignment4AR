function [ bestH2to1, inliers] = computeH_ransac( locs1, locs2)
%COMPUTEH_RANSAC A method to compute the best fitting homography given a
%list of matching points.
%So the inliers type thing is just applying transformation to all the
%points and then creating a count? Inliers are teh ones within the
%threshold, keep largest H???
%Then after all the iterations, recompute H using all the inlier points
%Parameters
N = log(1-0.95)/log(1-(1-0.60)^4);
t = 5;

% locs1 = locs1.Location;
% locs2 = locs2.Location;
%Storage
inliers = [];
bestHCount = 0;
s = RandStream('mlfg6331_64');

a = size(locs2);
b = ones(a(1), 1);
disp(locs2);
locs2a = [locs2 b].';
%Ransac and get inlier points
if a(1) > 4
    
    for i = 1:680
        %Randomly get four points
        randIndx = datasample(s,1:size(locs1),4,'Replace', false);
        tempP1 = locs1(randIndx, :);
        tempP2 = locs2(randIndx, :);
    
        %Get h for the 4 points
        %tempH = computeH_norm(tempP1, tempP2);
        tempH = computeH(tempP1, tempP2);
        %Apply h to locs2 and then compare to loc1, keep the points within t
        res = tempH * locs2a;
        res = hom2cart(res.');
    
        %Count # of points left, if > bestHcount, update
        tempOut = (sqrt(sum( (locs1 - res).^2,2)) > t);
    
        tempIn = ~tempOut;
        check = sqrt(sum( (locs1 - res).^2,2));
        %disp(check);
        %disp([locs1 res check tempOut]);

        if size(tempIn(tempIn,:),1) > bestHCount
            bestHCount = size(tempIn(tempIn,:),1);
            inliers = tempIn;
        end
    
        end
end

%Now recalculate h with the set of inliers
if bestHCount < 4
    %just use all?
    
    disp("Sad");
    if size(locs1,1) == 0
        bestH2to1 = zeros(3);
    else
        bestH2to1 = computeH_norm(locs1, locs2);
    end
else
    bestH2to1 = computeH_norm(locs1(inliers, :), locs2(inliers, :));
end

%Q2.2.3
end

