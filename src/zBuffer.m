function [ ] = zBuffer( Me )
%po = [500,-500,800]; % origine
%pr = [400,450,800]; % point qu'on regarde
po = [-600 -300 1500];
pr = [1200 1200 10];
%pr=[10,10,800]; 
%pr=[500,500,800]; 
d = -100;
NBITER = 3;
light = [1000 0 1000];
pr_li = [-10 351 590];
% ---
Me = repeatDS(Me, NBITER);
im = zeros(size(Me, 2), size(Me, 2), 3);
%im2 = zeros(size(Me, 2), size(Me, 2), 3);
tri = triangles(Me, po, light, pr_li, NBITER);
%tri2 = triangles(Me, po, light, pr_li, NBITER);
%tri = sortrows(tri, -14); % trie selon la distance à l'observateur
SIZE_X = 620; % taille de la précision du zbuffer
SIZE_Y = 620;
ZB=zeros(SIZE_X,SIZE_Y); % initialisation des zbuf
ZB2=zeros(SIZE_X,SIZE_Y);
k = [0 0 1];

Tr = CameraTransfo( po, pr, [0 0 1], d );
Tr_li = CameraTransfo2( light, pr_li, [0 0 1] );
B =  TransformScene( tri, Tr );
B_li =  TransformScene( tri, Tr_li );

% zbuf normal -----------------------------------------------------------
yMax = max(B(:, 2));
yMin = min(B(:, 2));
xMax = max(B(:, 1));
xMin = min(B(:, 1));
offset = -[(xMin - 1) (yMin - 1) 1];

for i=1:size(B,1) % normalise la taille de B entre 1 et SIZE_X * SIZE_Y
    B(i, :) = (B(i,:)-[(xMin) (yMin) 1])./[xMax-xMin yMax-yMin 1];
    B(i,:) = (B(i,:)+[1/SIZE_X 1/SIZE_Y 1]).*[SIZE_X-1 SIZE_Y-1 1];
end

% Remplissage du zbuffer
for i=1:size(tri, 1)
    triangle = [B(3*i-2, 1:2); B(3*i-1, 1:2); B(3*i, 1:2)];
    %triangle = triangle + (ones(3, 1) * offset);
    ZB=tpiRemplirTriangleBuffer(ZB, triangle, tri(i, 14));
end

% zbuf li -----------------------------------------------------------------
yMax = max(B_li(:, 2));
yMin = min(B_li(:, 2));
xMax = max(B_li(:, 1));
xMin = min(B_li(:, 1));
offset = -[(xMin - 1) (yMin - 1) 1];

for i=1:size(B_li,1) % normalise la taille de B entre 1 et SIZE_X * SIZE_Y
    B_li(i, :) = (B_li(i,:)-[(xMin) (yMin) 1])./[xMax-xMin yMax-yMin 1];
    B_li(i,:) = (B_li(i,:)+[1/SIZE_X 1/SIZE_Y 1]).*[SIZE_X-1 SIZE_Y-1 1];
end

% Remplissage du zbuffer
for i=1:size(tri, 1)
    if tri(i, 19) == 1
        continue;
    end
    triangle = [B_li(3*i-2, 1:2); B_li(3*i-1, 1:2); B_li(3*i, 1:2)];
    ZB2 = tpiRemplirTriangleBuffer(ZB2, triangle, tri(i, 18));
end

% -----------

figure(1)
image(ZB)

figure(2)
image(ZB2)

% Remplissage de l'image
for i=1:size(tri, 1)
    triangle_li = [B_li(3*i-2, 1:2); B_li(3*i-1, 1:2); B_li(3*i, 1:2)];
    triangle = [B(3*i-2, 1:2); B(3*i-1, 1:2); B(3*i, 1:2)];
    %triangle = triangle + (ones(3, 1) * offset);
    
    ombre = 1.0;
    %
    if tpiRemplirTriangleImage2(ZB2, triangle_li, tri(i, 18)) == 0
       ombre = 0.5;
    end
    im=tpiRemplirTriangleImage(im, ZB, triangle, tri(i, 14), tri(i, 15:17)*ombre);
end

figure(3)
image(im)

%figure(5)
%image(im2)

end

