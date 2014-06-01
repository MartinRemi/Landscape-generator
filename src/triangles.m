function [ tri ] = triangles(Me, po, li, pr_li, nbiter)

    tri = zeros( (size(Me,1)-1)*(size(Me, 2)-1)*2, 17 );

    % 1:3 pt1
    % 4:6 pt2
    % 7:9 pt3
    % 10:12 bary
    % 13 normale en z
    % 14 distance a po
    % 15:17 color (r g b)

    % échelle
    xscale = 100/(2^nbiter);
    yscale = 100/(2^nbiter);
    %xscale = (13-1)*100/size(Me, 1);
    %yscale = (10-1)*100/size(Me, 2);

    id = 1;
    for i=1:size(Me, 1)-1
        for j=1:size(Me, 2)-1
            tri = triangles_part(tri, xscale, yscale, id, i, j, Me, po, li, pr_li, 0);
            id = id+1;
            tri = triangles_part(tri, xscale, yscale, id, i, j, Me, po, li, pr_li, 1);
            id = id+1;
        end
    end

    i = 1;
    for j=1:size(Me, 2)-1
        tri = triangles_part_2(tri, xscale, yscale, id, i, j, Me, po, li, pr_li, 0, 1);
        id = id+1;
        tri = triangles_part_2(tri, xscale, yscale, id, i, j, Me, po, li, pr_li, 1, 1);
        id = id+1;
    end

    j = 1;
    for i=1:size(Me, 1)-1
        tri = triangles_part_2(tri, xscale, yscale, id, i, j, Me, po, li, pr_li, 0, 0);
        id = id+1;
        tri = triangles_part_2(tri, xscale, yscale, id, i, j, Me, po, li, pr_li, 1, 0);
        id = id+1;
    end

    
    %bateau(tri, xscale, yscale, id, i, j, Me, po, li, pr_li, 1, 0);

end

function [ tri ] = triangles_part(tri, xscale, yscale, id, i, j, Me, po, li, pr_li, a)
		tri(id, 2) = i * xscale; % pt1 
        tri(id, 1) = j * yscale;
        tri(id, 3) = Me(i,j);
        
        if a == 0
            tri(id, 5) = (i+1) * xscale; % pt2
            tri(id, 4) = j * yscale;
            tri(id, 6) = Me(i+1,j);
        else
            tri(id, 5) = i * xscale; % pt2
            tri(id, 4) = (j+1) * yscale;
            tri(id, 6) = Me(i,j+1);  
        end
        
        tri(id, 8) = (i+1) * xscale; % pt3
        tri(id, 7) = (j+1) * yscale;
        tri(id, 9) = Me(i+1,j+1);
        
        tri(id, 10) = (tri(id, 1) + tri(id, 4) + tri(id, 7))/3; % barycentre
        tri(id, 11) = (tri(id, 2) + tri(id, 5) + tri(id, 8))/3;
        tri(id, 12) = (tri(id, 3) + tri(id, 6)+ tri(id, 9))/3;
        
        % normale :
        a = [tri(id, 1) tri(id, 2) tri(id, 3)];
        b = [tri(id, 4) tri(id, 5) tri(id, 6)];
        c = [tri(id, 7) tri(id, 8) tri(id, 9)];
        normale = cross(b-a, c-a);
        normale = normale/norm(normale);
        tri(id, 13) = normale(3); % normale en projetée sur z 
        
        % vecteurs utiles:
        L = li-tri(id,10:12); % vecteur barycentre -> lumière
        V = po-tri(id,10:12); % vecteur bary -> oeil
        R = 2*dot(normale,L)*normale-L;
        L = L/norm(L);
        DIR_LIGHT = li-pr_li;
        DIR_LIGHT = DIR_LIGHT/norm(DIR_LIGHT);
        V = V/norm(V);
        R = R/norm(R);
        
        % distance a po:
        tri(id, 14) = (po(1)-tri(id,10))*(po(1)-tri(id,10))+(po(2)-tri(id, 11))*(po(2)-tri(id, 11))+(po(3)-tri(id, 12))*(po(3)-tri(id, 12));
        tri(id, 14) = sqrt(tri(id, 14));
        
        % couleur
        col = color(tri(id,12), tri(id,13), normale, L, V, R, 0.5, DIR_LIGHT); % couleur de base
        
        tri(id, 15:17) = col(1:3); 
        
        
        if i == 900 && j == 900
            tri(id, 15:17) = [1 0 0];
        end
        
        % distance a li:
        tri(id, 18) = dist(li,tri(id,10:12));
        tri(id, 19) = 0; % pas nappe
        
end

function [ tri ] = triangles_part_2(tri, xscale, yscale, id, i, j, Me, po, li, pr_li, a, b)
    z_li = 500;
    if b == 0
        j=1;
		tri(id, 2) = i * xscale; % pt1 
        tri(id, 1) = j * yscale;
        tri(id, 3) = Me(i,j);
        
        if a == 0
            tri(id, 5) = (i+1) * xscale; % pt2
            tri(id, 4) = j * yscale;
            tri(id, 6) = Me(i+1,j);
        else
            tri(id, 5) = i * xscale; % pt2
            tri(id, 4) = j * yscale;
            tri(id, 6) = z_li;  
        end
        
        tri(id, 8) = (i+1) * xscale; % pt3
        tri(id, 7) = j * yscale;
        tri(id, 9) = z_li;
    else
        i=1;
        tri(id, 2) = i * xscale; % pt1 
        tri(id, 1) = j * yscale;
        tri(id, 3) = Me(i,j);
        
        if a == 0
            tri(id, 5) = i * xscale; % pt2
            tri(id, 4) = j * yscale;
            tri(id, 6) = z_li;
        else
            tri(id, 5) = i * xscale; % pt2
            tri(id, 4) = (j+1) * yscale;
            tri(id, 6) = Me(i,j+1);  
        end
        
        tri(id, 8) = i * xscale; % pt3
        tri(id, 7) = (j+1) * yscale;
        tri(id, 9) = z_li;
    end
        
        tri(id, 10) = (tri(id, 1) + tri(id, 4) + tri(id, 7))/3; % barycentre
        tri(id, 11) = (tri(id, 2) + tri(id, 5) + tri(id, 8))/3;
        tri(id, 12) = (tri(id, 3) + tri(id, 6) + tri(id, 9))/3;
        
        % normale :
        a = [tri(id, 1) tri(id, 2) tri(id, 3)];
        b = [tri(id, 4) tri(id, 5) tri(id, 6)];
        c = [tri(id, 7) tri(id, 8) tri(id, 9)];
        normale = cross(b-a, c-a);
        normale = normale/norm(normale);
        tri(id, 13) = normale(3); % normale en projetée sur z 
        
        % vecteurs utiles:
        L = li-tri(id,10:12); % vecteur barycentre -> lumière
        V = po-tri(id,10:12); % vecteur bary -> oeil
        R = 2*dot(normale,L)*normale-L;
        L = L/norm(L);
        DIR_LIGHT = li-pr_li;
        DIR_LIGHT = DIR_LIGHT/norm(DIR_LIGHT);
        V = V/norm(V);
        R = R/norm(R);
        
        % distance a po:
        tri(id, 14) = (po(1)-tri(id,10))*(po(1)-tri(id,10))+(po(2)-tri(id, 11))*(po(2)-tri(id, 11))+(po(3)-tri(id, 12))*(po(3)-tri(id, 12));
        tri(id, 14) = sqrt(tri(id, 14));
        % couleur
        
        tri(id, 15:17) = [90/255 69/255 29/255]; 
        
        % distance a li:
        tri(id, 18) = dist(li,tri(id,10:12));
        tri(id, 19) = 1; 
        
end

function [ tri ] = bateau(tri, xscale, yscale, id, i, j, Me, po, li, pr_li, a, b)

    x = 20;
    y = 10;
    z = 590;

    tri(id, 2) = x * xscale; % pt1 
    tri(id, 1) = y * yscale;
    tri(id, 3) = z;

    tri(id, 5) = x * xscale; % pt2
    tri(id, 4) = (y+100) * yscale;
    tri(id, 6) = z+300;  

    tri(id, 8) = (x+100) * xscale; % pt3
    tri(id, 7) = y * yscale;
    tri(id, 9) = z+100;
    
    % ---
    
    tri(id, 10) = (tri(id, 1) + tri(id, 4) + tri(id, 7))/3; % barycentre
        tri(id, 11) = (tri(id, 2) + tri(id, 5) + tri(id, 8))/3;
        tri(id, 12) = (tri(id, 3) + tri(id, 6)+ tri(id, 9))/3;
        
        % normale :
        a = [tri(id, 1) tri(id, 2) tri(id, 3)];
        b = [tri(id, 4) tri(id, 5) tri(id, 6)];
        c = [tri(id, 7) tri(id, 8) tri(id, 9)];
        normale = cross(b-a, c-a);
        normale = normale/norm(normale);
        tri(id, 13) = normale(3); % normale en projetée sur z 
        
        % vecteurs utiles:
        L = li-tri(id,10:12); % vecteur barycentre -> lumière
        V = po-tri(id,10:12); % vecteur bary -> oeil
        R = 2*dot(normale,L)*normale-L;
        L = L/norm(L);
        DIR_LIGHT = li-pr_li;
        DIR_LIGHT = DIR_LIGHT/norm(DIR_LIGHT);
        V = V/norm(V);
        R = R/norm(R);
        
        % distance a po:
        tri(id, 14) = (po(1)-tri(id,10))*(po(1)-tri(id,10))+(po(2)-tri(id, 11))*(po(2)-tri(id, 11))+(po(3)-tri(id, 12))*(po(3)-tri(id, 12));
        tri(id, 14) = sqrt(tri(id, 14));
        
        % couleur
        tri(id, 15:17) = [1.0 0 0];
        
        % distance a li:
        tri(id, 18) = dist(li,tri(id,10:12));
        tri(id, 19) = 0; % pas nappe
end
