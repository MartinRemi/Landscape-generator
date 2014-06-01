function im=tpiRemplirTriangleImage(im, ZB, Sommets, Bary, Couleur)

% Remplit l'image im = [H W 3] avec 
% la couleur Couleur = [R G B] à l'intérieur 
% du triangle de sommmets Sommets = [S1.lig S1.col ; S2.lig S2.col ; S3.lig S3.col]
% si la profondeur de son barycentre Bary correspond à la valeur
% enregistrée dans le Z-Buffer ZB
Sommets=fliplr(Sommets);

S=sortrows(Sommets);
V1=S(2,:)-S(1,:);
V2=S(3,:)-S(1,:);
SigneDet=det([V1;V2])>0;

if SigneDet,
    % Point interm?diaire à gauche
    [COL, LIG]=bresenhamGauche(S(1,:),S(2,:));
    Lignes=LIG;
    ColonnesGauche=COL;
    [COL, LIG]=bresenhamGauche(S(2,:),S(3,:));
    N=size(LIG,2);
    Lignes=[Lignes LIG(2:N)];
    ColonnesGauche=[ColonnesGauche COL(2:N)];
    [ColonnesDroit, LIG]=bresenhamDroit(S(1,:),S(3,:));
else
 % Point interm?diaire à droite
    [COL, LIG]=bresenhamDroit(S(1,:),S(2,:));
    Lignes=LIG;
    ColonnesDroit=COL;
    [COL, LIG]=bresenhamDroit(S(2,:),S(3,:));
    N=size(LIG,2);
    Lignes=[Lignes LIG(2:N)];
    ColonnesDroit=[ColonnesDroit COL(2:N)];
    [ColonnesGauche, LIG]=bresenhamGauche(S(1,:),S(3,:));
end
%Lignes
%LIG
 for n=1:size(Lignes,2),
    for c=ColonnesGauche(n):ColonnesDroit(n),
        if abs(ZB(Lignes(n),c)-Bary)<0.5,
            im(Lignes(n),c,1)=Couleur(1);
            im(Lignes(n),c,2)=Couleur(2);
            im(Lignes(n),c,3)=Couleur(3);
        end
    end
 end

end

function [x y]=bresenham(x1,y1,x2,y2)

%Matlab optmized version of Bresenham line algorithm. No loops.
%Format:
%               [x y]=bham(x1,y1,x2,y2)
%
%Input:
%               (x1,y1): Start position
%               (x2,y2): End position
%
%Output:
%               x y: the line coordinates from (x1,y1) to (x2,y2)
%
%Usage example:
%               [x y]=bham(1,1, 10,-5);
%               plot(x,y,'or');
x1=round(S(1,2)); x2=round(S(2,2));
y1=round(S(1,1)); y2=round(S(2,1));
dx=abs(x2-x1);
dy=abs(y2-y1);
steep=abs(dy)>abs(dx);
if steep 
    t=dx;
    dx=dy;
    dy=t; 
end

%The main algorithm goes here.
if dy==0 
    q=zeros(dx+1,1);
else
    q=[0;diff(mod([floor(dx/2):-dy:-dy*dx+floor(dx/2)]',dx))>=0];
end

%and ends here.

if steep
    if y1<=y2 y=[y1:y2]'; else y=[y1:-1:y2]'; end
    if x1<=x2 x=x1+cumsum(q);else x=x1-cumsum(q); end
else
    if x1<=x2 x=[x1:x2]'; else x=[x1:-1:x2]'; end
    if y1<=y2 y=y1+cumsum(q);else y=y1-cumsum(q); end
end
end

function [x y]=bresenhamGauche(S1,S2)

%Matlab optmized version of Bresenham line algorithm. No loops.
%Format:
%               [x y]=bham(x1,y1,x2,y2)
%
%Input:
%               (x1,y1): Start position
%               (x2,y2): End position
%
%Output:
%               x y: the line coordinates from (x1,y1) to (x2,y2)
%
%Usage example:
%               [x y]=bham(1,1, 10,-5);
%               plot(x,y,'or');
x1=round(S1(2)); x2=round(S2(2));
y1=round(S1(1)); y2=round(S2(1));
dx=abs(x2-x1);
dy=abs(y2-y1);
steep=abs(dy)>abs(dx);
if steep 
    t=dx;
    dx=dy;
    dy=t; 
end

%The main algorithm goes here.
if dy==0 
    q=zeros(dx+1,1);
else
    q=[0;diff(mod([floor(dx/2):-dy:-dy*dx+floor(dx/2)]',dx))>=0];
end

%and ends here.

if steep
    if y1<=y2 y=[y1:y2]'; else y=[y1:-1:y2]'; end
    if x1<=x2 x=x1+cumsum(q);else x=x1-cumsum(q); end
else
    
    if x1<=x2 x=[x1:x2]'; else x=[x1:-1:x2]'; end
    if y1<=y2 y=y1+cumsum(q);else y=y1-cumsum(q); end
    xx(1,1)=x(1); yy(1,1)=y(1);
    N=size(q,1);
    for n=1:N
        if q(n)==1,
            xx=[xx; x(n)];
            yy=[yy; y(n)];
        end
    end
    x=xx; y=yy;
    
end
x=x'; y=y';
end


function [x y]=bresenhamDroit(S1,S2)

%Matlab optmized version of Bresenham line algorithm. No loops.
%Format:
%               [x y]=bham(x1,y1,x2,y2)
%
%Input:
%               (x1,y1): Start position
%               (x2,y2): End position
%
%Output:
%               x y: the line coordinates from (x1,y1) to (x2,y2)
%
%Usage example:
%               [x y]=bham(1,1, 10,-5);
%               plot(x,y,'or');
x1=round(S1(2)); x2=round(S2(2));
y1=round(S1(1)); y2=round(S2(1));

dx=abs(x2-x1);
dy=abs(y2-y1);
steep=abs(dy)>abs(dx);
if steep 
    t=dx;
    dx=dy;
    dy=t; 
end

%The main algorithm goes here.
if dy==0 
    q=zeros(dx+1,1);
else
    q=[0;diff(mod([floor(dx/2):-dy:-dy*dx+floor(dx/2)]',dx))>=0];
end

%and ends here.

if steep
    if y1<=y2 y=[y1:y2]'; else y=[y1:-1:y2]'; end
    if x1<=x2 x=x1+cumsum(q);else x=x1-cumsum(q); end
else
    
    if x1<=x2 x=[x1:x2]'; else x=[x1:-1:x2]'; end
    if y1<=y2 y=y1+cumsum(q);else y=y1-cumsum(q); end
    xx=[]; yy=[];
    N=size(q,1);
    for n=1:N
        if q(n)==1,
            xx=[xx; x(n)-1];
            yy=[yy; y(n)-1];
        end
    end
    xx=[xx; x(N)];
    yy=[yy; y(N)];
    x=xx; y=yy;
    
end
x=x'; y=y';

end