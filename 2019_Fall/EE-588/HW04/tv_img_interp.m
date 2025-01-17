% tv_img_interp.m
% Total variation image interpolation.
% EE364a
% Defines m, n, Uorig, Known.

% Load original image.
figure('DefaultAxesFontSize',20);
Uorig = double(imread('tv_img_interp.png'));

[m, n] = size(Uorig);

% Create 50% mask of known pixels.
rand('state', 1029);
Known = rand(m,n) > 0.5;

%%%%% Put your solution code here
% Calculate and define Ul2 and Utv.

% Placeholder:
Ul2 = ones(m, n);
Utv = ones(m, n);
cvx_begin
  variable Ul2(m,n);
  % Assign known pixels
  Ul2(Known) == Uorig(Known);
  dist1 = Ul2(2:m,2:m)-Ul2(1:m-1,2:m);
  dist2 = Ul2(2:m,2:m)-Ul2(2:m,1:m-1);
  % vectorize
  minimize(norm([dist1(:); dist2(:)],2));
cvx_end


cvx_begin
  variable Utv(m,n);
  % Ensure known are equal
  Utv(Known) == Uorig(Known);
  dist1 = Utv(2:m,2:m)-Utv(1:m-1,2:m);
  dist2 = Utv(2:m,2:m)-Utv(2:m,1:m-1);
  % vectorize
  minimize(norm([dist1(:); dist2(:)],1));
cvx_end


%%%%%

% Graph everything.
figure(1); cla;
colormap gray;

subplot(221);
imagesc(Uorig)
title('Original image');
axis image;

subplot(222);
imagesc(Known.*Uorig + 256-150*Known);
title('Obscured image');
axis image;

subplot(223);
imagesc(Ul2);
title('l_2 reconstructed image');
axis image;

subplot(224);
imagesc(Utv);
title('Total variation reconstructed image');
axis image;
