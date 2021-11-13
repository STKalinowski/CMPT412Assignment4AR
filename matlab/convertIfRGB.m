function gray = convertIfRGB(img)
    if size(img, 3) == 3
        gray = rgb2gray(img);
    else
        gray = img;
    end
end

