function testZBuffer

% Image finale
im=zeros(200,200,3);

% Z-Buffer
ZB=zeros(200,200);

% Triangle 1
P11=[40 40];
P12=[70 95];
P13=[40 80];  %%%%
Bary1=50;
Couleur1=[1 1 0.5]; % Jaune

% Triangle 2
P21=[40 40];
P22=[70 95];
P23=[30 140];
Bary2=40;
Couleur2=[1 0.5 1]; % Magenta

% Triangle 3
P31=[70 30];
P32=[110 55];
P33=[40 160];
Bary3=10; % ou 10 ou 50
Couleur3=[0.5 1 1]; % Cyan

% Triangle 4
P41=[140 160];
P42=[70 95];
P43=[40 80]; %%%%%%
Bary4=50; % ou 10 ou 50
Couleur4=[1 1 1]; % Blanc


% Remplissage du Z-Buffer
ZB=tpiRemplirTriangleBuffer(ZB, [P11; P12; P13], Bary1);
ZB=tpiRemplirTriangleBuffer(ZB, [P21; P22; P23], Bary2);
ZB=tpiRemplirTriangleBuffer(ZB, [P31; P32; P33], Bary3);
ZB=tpiRemplirTriangleBuffer(ZB, [P41; P42; P43], Bary4);

% Remplissage de l'image
im=tpiRemplirTriangleImage(im, ZB, [P11; P12; P13], Bary1, Couleur1);
im=tpiRemplirTriangleImage(im, ZB, [P21; P22; P23], Bary2, Couleur2);
im=tpiRemplirTriangleImage(im, ZB, [P31; P32; P33], Bary3, Couleur3);
im=tpiRemplirTriangleImage(im, ZB, [P41; P42; P43], Bary4, Couleur4);

% Affichage
figure(1)
image(im)

end

