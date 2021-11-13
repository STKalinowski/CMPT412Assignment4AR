% Q3.3.1
bookVid = loadVid('../data/book.mov');
sourceVid = loadVid('../data/ar_source.mov');
cv_img = imread('../data/cv_cover.jpg');

output = VideoWriter('../data/output.avi');
open(output);
%loop through, apply same as in harry
%then save final result.
%Do some initial testing to get the right parameters
%Just do one initially then do it like every 100 frames to get the most
%robust parameters for the homography
last3H = [];
last3In = [];
disp(size(sourceVid.'));

for i = 1:size(sourceVid.')

    %Extract features and match
    [locs1, locs2] = matchPicsSurf( cv_img, bookVid(i).cdata);
%     disp(i);
%     disp(size(locs1));


     %showMatchedFeatures(cv_img, bookVid(52).cdata, locs1, locs2, 'montage');
    
    %Compute Homography

    [h, inliers] = computeH_ransac(locs1, locs2);
    if size(last3In,2) < 3
        last3H = [last3H ; h];
        last3In = [last3In size(inliers,1)];
    else
        last3H(1:3,:) = [];
        last3H = [last3H ; h];
        last3In(:,1) = [];
        last3In = [last3In size(inliers,1)];
    end

    [~, index] = max(last3In.');
    top = (index-1)*3+1;
    bot = (index-1)*3+3;
    h = last3H(top:bot,:);

    %[~,index] = max(last3(:,2));

    %Crop and scale image to template
    crop = sourceVid(i).cdata(50:310, 180:470, :);
    crop = imresize(crop, [size(cv_img, 1) size(cv_img,2)]);

    %display warped image
    comp = compositeH(h, crop, bookVid(i).cdata);
    writeVideo(output,comp);

end
close(output);
disp("Done!");
%Book video is longer then the source do we just black screen or something?