function mainZhenkuangHe(im)

I = imresize(im2double(imread(im)), 0.5);

% Convert to Irgb
Irgb(:,:,1) = I(:,:,1)./(I(:,:,1)+I(:,:,2)+I(:,:,3)); 
Irgb(:,:,2) = I(:,:,2)./(I(:,:,1)+I(:,:,2)+I(:,:,3)); 
Irgb(:,:,3) = I(:,:,3)./(I(:,:,1)+I(:,:,2)+I(:,:,3));

% Do the Yellow detect (Use Irgb)
outputY = SignDetectYellow(Irgb, I);

% Do the Green detect (Use Irgb)
outputG = SignDetectGreen(Irgb, outputY);

% Do the Red detect (Use Irgb)
outputR = SignDetectRed(Irgb, outputG);

% Do the White detect (Use Ioriginal)
outputW = SignDetectWhite(I, outputR);

% Get the total output
output = outputW;

% Display the result image
figure, imshow(output);
