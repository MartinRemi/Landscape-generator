function [] = perspective( Me )

% a definir :

po = [-600 -300 1500];
pr = [1200 1200 10];
%po=[-10,0,800];
%pr=[500,500,800]; 
%po = [-600 -300 1500];
%pr = [1200 1200 10];
d = 100;
NBITER = 3;
light = [1000 0 1000];
pr_li = [-10 351 590];

% ---

Me = repeatDS(Me, NBITER);
tri = triangles(Me, po, light, pr_li, NBITER);
tri = sortrows(tri, -14); % trie selon la distance � l'observateur

Tr = CameraTransfo( po, pr, [0 0 1], d );
B =  TransformScene( tri, Tr );

figure(1);

hold on;
whitebg([0 0 0])
for i=1:size(tri,1)
    t = fill(B(3*i-2:3*i, 1), B(3*i-2:3*i, 2), tri(i,15:17));
    set(t,'EdgeColor', 'None'); % pour retirer le maillage
end
hold off;


end

