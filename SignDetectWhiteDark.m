function outputW = SignDetectWhiteDark(I, outputR)
% Generatie invert C.
load('WhiteDark.mat');
IC = inv(covWhiteDark);
MeanVector = (mWhiteDark);
% Get the number of rows and coloums of the image.
[r,c,p] = size(I);
% Calculate the metrix of image with each pixel - the mean of each color
% row.
imc(:,:,1) = I(:,:,1) - MeanVector(1);
imc(:,:,2) = I(:,:,2) - MeanVector(2);
imc(:,:,3) = I(:,:,3) - MeanVector(3);
% Use the loop to calculate the Map.
for i = 1:r
    for j = 1:c
        Pix = [imc(i,j,1) imc(i,j,2) imc(i,j,3)];
        Map(i,j) = Pix * IC * Pix';
    end
end
% Calculate the Mahalanobis Distance Map.
MDMap = sqrt(Map);
% Use the threshold to generate the Thresholded Mahalanobis Distance Map.
MM = MDMap < 2;
% Close the MDMap use the shape "square"
fo = strel('square',5);
MMW = imclose(MM,fo);
label = bwlabel(MMW);
lmax = max(max(label));
countRight = 0;
outputW = outputR;
% Filter the result
for i = 1:lmax
    [r,c] = find(label == i);
    if length(r) > 200 && length(r) <5000
        out = label == i;
        sum_v = sum(out);
        sum_h = sum(out');
        f_v = find(sum_v, 1, 'first');
        l_v = find(sum_v, 1, 'last');
        f_h = find(sum_h, 1, 'first');
        l_h = find(sum_h, 1, 'last');
        long = l_h - f_h;
        wide = l_v - f_v;   
        countRight = countRight + 1;
        FP = [f_v l_v f_h l_h];                
    end
end
if countRight == 1
    if long / wide > 0.5
       outputW(FP(3)-2:FP(3), FP(1):FP(2), 1) = 1;
       outputW(FP(3)-2:FP(3), FP(1):FP(2), 2) = 0;
       outputW(FP(3)-2:FP(3), FP(1):FP(2), 3) = 0;
       outputW(FP(4):FP(4)+2, FP(1):FP(2), 1) = 1;
       outputW(FP(4):FP(4)+2, FP(1):FP(2), 2) = 0;
       outputW(FP(4):FP(4)+2, FP(1):FP(2), 3) = 0;
       outputW(FP(3):FP(4), FP(1)-2:FP(1), 1) = 1;
       outputW(FP(3):FP(4), FP(1)-2:FP(1), 2) = 0;
       outputW(FP(3):FP(4), FP(1)-2:FP(1), 3) = 0;
       outputW(FP(3):FP(4), FP(2):FP(2)+2, 1) = 1;
       outputW(FP(3):FP(4), FP(2):FP(2)+2, 2) = 0;
       outputW(FP(3):FP(4), FP(2):FP(2)+2, 3) = 0;
    end
end
return