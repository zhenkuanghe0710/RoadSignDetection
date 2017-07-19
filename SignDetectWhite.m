function outputW = SignDetectWhite(Io, outputR)
% Adjust contract
R = Io(:,:,1);
G = Io(:,:,2);
B = Io(:,:,3);
R = imadjust(R, [0.3 0.7], [0,1]);
G = imadjust(G, [0.3 0.7], [0,1]);
B = imadjust(B, [0.3 0.7], [0,1]);
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
MM = MDMap < 1;
label = bwlabel(MM);
lmax = max(max(label));
countChosen = 0;
countRight = 0;
% Filter the result
outputW = outputR;
for i = 1:lmax
    [r,c] = find(label == i);
    if length(r) > 100 && length(r) <3000
        countChosen = countChosen + 1;
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
        imc = imclose(imtbw, se);        
        count0 = length(find(imc(:)==0));
        count1 = length(find(imc(:)==1));
        [w,l,p] = size(I);
        if f_v > 50 && l_v < l-50 && f_h > 50 && l_h < w-50
            if ( (count0/count1<0.09) && (count0/count1>0.01) && (long>wide) && (wide/long>0.5) ) || ((wide/long>0.4) && (long>wide) && (long*wide>3800) && (long*wide<4000))  
                    outputW(f_h-2:f_h, f_v:l_v, 1) = 1;
                    outputW(f_h-2:f_h, f_v:l_v, 2) = 0;
                    outputW(f_h-2:f_h, f_v:l_v, 3) = 0;
                    outputW(l_h:l_h+2, f_v:l_v, 1) = 1;
                    outputW(l_h:l_h+2, f_v:l_v, 2) = 0;
                    outputW(l_h:l_h+2, f_v:l_v, 3) = 0;
                    outputW(f_h:l_h, f_v-2:f_v, 1) = 1;
                    outputW(f_h:l_h, f_v-2:f_v, 2) = 0;
                    outputW(f_h:l_h, f_v-2:f_v, 3) = 0;
                    outputW(f_h:l_h, l_v:l_v+2, 1) = 1;
                    outputW(f_h:l_h, l_v:l_v+2, 2) = 0;
                    outputW(f_h:l_h, l_v:l_v+2, 3) = 0;                    
                    countRight = countRight + 1; 
            end
        end
    end
end
% If not match adjust to higher contract to detect
if countRight == 0 && countChosen >= 12;
    outputW = SignDetectWhiteMoreContrast(Io, outputR); 
end
return