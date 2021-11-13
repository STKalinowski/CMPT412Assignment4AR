% Your solution to Q2.1.5 goes here!
threshold = 10;
cv_img = imread('../data/cv_cover.jpg');
holdCountFast = [];
holdCountSurf = [];
holdDegree = [];

%% Read the image and convert to grayscale, if necessary
cv_img = convertIfRGB(cv_img);
rot_img = cv_img;

%% Compute the features and descriptors
origDetFast = detectFASTFeatures(cv_img);
[descOrigFast, locOrigFast] = computeBrief(cv_img, origDetFast.Location);

origDetSurf = detectSURFFeatures(cv_img);
[descOrigSurf, locOrigSurf] = extractFeatures(cv_img, origDetSurf, 'Method', 'SURF');



for i = 0:36
    %% Rotate image
    rot_img = imrotate(cv_img, 10*i);
    
    %% Compute features and descriptors
    rotDetFast = detectFASTFeatures(rot_img);
    [descRotFast, locRotFast] = computeBrief(rot_img, rotDetFast.Location);

    rotDetSurf = detectSURFFeatures(rot_img);
    [descRotSurf, locRotSurf] = extractFeatures(rot_img, rotDetSurf, 'Method','SURF');
    
    %% Match features
    matchesFast = matchFeatures(descRotFast, descOrigFast, 'MatchThreshold', threshold, 'MaxRatio', 0.75);
    matchesSurf = matchFeatures(descRotSurf, descOrigSurf, 'MatchThreshold', threshold);%threshold);
    
    a = size(matchesFast);
    a = a(1);
    b = size(matchesSurf);
    b = b(1);
    
    %% Update histogram
    if i ~= 36 && i~=0
        holdCountFast = [holdCountFast, a];
        holdCountSurf = [holdCountSurf, b];
        holdDegree = [holdDegree 10*i];
    end
    
    %% Visual of three orientations
    %How to show in a new figure?
    if i == 8 || i == 17 || i == 27
        loc1 = locOrigSurf(matchesSurf(:,2),:);
        loc2 = locRotSurf(matchesSurf(:,1),:);
        
%         loc1 = locOrigFast(matchesFast(:,2),:);
%         loc2 = locRotFast(matchesFast(:,1),:);
        figure
        showMatchedFeatures(cv_img, rot_img, loc1, loc2, 'montage');
        title(['Visual of Orientation ', num2str(i*10)]);
    end
    
end

%% Display histogram
figure;
subplot(1,2,1);
%hFast = histogram(holdCountFast);
hFast = bar(holdDegree, holdCountFast);
%disp(hFast);
title('Matches Brief');
ylabel('Number of matches');
xlabel('Count');
subplot(1,2,2);
%hSurf = histogram(holdCountSurf );
hSurf = bar(holdDegree, holdCountSurf );
%disp(hSurf);
title('Matches Surf');
ylabel('Number of matches');
xlabel('Count');


