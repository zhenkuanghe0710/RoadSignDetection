function outputW = SignDetectWhiteMoreContrast(Io, outputR)
% Adjust contract
R = Io(:,:,1);
G = Io(:,:,2);
B = Io(:,:,3);
R = imadjust(R, [0.5 0.6], [0,1]);
G = imadjust(G, [0.5 0.6], [0,1]);
B = imadjust(B, [0.5 0.6], [0,1]);
I = cat(3,R,G,B);
% Generatie invert C.
IC = ones(3);
MeanVector = [1 1 1];
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
MM = MDMap < 0.5;
% Close the MDMap use the shape "|"
fo = [1;1;1;1;1];
MMW = imclose(MM,fo);
label = bwlabel(MMW);
lmax = max(max(label));
countRight = 0;
outputW = outputR;
% Filter the result
for i = 1:lmax
    [r,c] = find(label == i);
    if length(r) > 100 && length(r) <3000
        out = label == i;
        sum_v = sum(out);
        sum_h = sum(out');
        f_v = find(sum_v, 1, 'first');
        l_v = find(sum_v, 1, 'last');
        f_h = find(sum_h, 1, 'first');
        l_h = find(sum_h, 1, 'last');
        long = l_h - f_h;
        wide = l_v - f_v;       
        imtbw = MM(f_h:l_h, f_v:l_v);
        se = strel('square',3);
        imcl = imdilate(imtbw, se);       
        count0c = length(find(imcl(:)==0));
        count1c = length(find(imcl(:)==1));       
        count0 = length(find(imtbw(:)==0));
        count1 = length(find(imtbw(:)==1));       
        [w,l,p] = size(I);       
        if long > wide && wide / long > 0.5 && wide / long < 0.95
            if f_v > 50 && l_v < l-50 && f_h > 50 && l_h < w-50
                if ((count0c / count1c) <0.3 && (count0 /count1) > 0.3)
                   if long * wide > 300
                       countRight = countRight + 1;
                       FP = [f_v l_v f_h l_h];
                   end
                end
            end
        end
    end
end
if countRight == 1
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
% If no match result, adjust lower contract to detect 
else
    outputW = SignDetectWhiteLessContrast(Io, outputR); 
end
return