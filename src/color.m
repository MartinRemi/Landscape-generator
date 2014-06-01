function [ color ] = color( z, nz, normale, L, V, R, li_ambiant, d_li )

L = dot(L,d_li)*L;

% z : hauteur ; nz = normale en z
color = [64 190 64];
% note : mettre les couleurs entre 0 et 255 ici

i_d = 0.9;%diffuse
i_s = 0.3;%specular
alpha = 100;

if z <= 590 % mer
    color(1) = 5;
    color(2) = 229;
    color(3) = 255;
    alpha = 2;
    i_d = 0.8;
    i_s = 0.9;
    color(:) = color(:) + rand()*1;
elseif z <= 598% plage
    color(1) = 224;
    color(2) = 210;
    color(3) = 180;
    i_s = 0.1;
    color(:) = color(:) + rand()*10;
elseif z <= 700% herbe
    color(1) = 86;
    color(2) = 180;
    color(3) = 86;
    color(:) = color(:) + rand()*10;
elseif z <= 850 % montagne moyenne
    color(1) = 110;
    color(2) = 89;
    color(3) = 49;
    color(:) = color(:) + rand()*10;
elseif z >= 850 % montagne haute (neige)
    color(1) = 245;
    color(2) = 245;
    color(3) = 245;
    color(:) = color(:) + rand()*10;
    alpha = 5;
    i_s = 0.5;
end

limit_nz = 0.4;
if z > 700 && abs(nz) < limit_nz % montagne escarpée
    f = abs(nz)/limit_nz; % entre 0 et 1.0
    f = 10*f+rand();
    color(1) = 110+f;
    color(2) = 99+f;
    color(3) = 75+f;
    color(:) = color(:) + rand()*5;
end

color(:) = color(:)/255;

li_diffuse = i_d*abs(dot(L,normale));
li_specular = i_s*dot(R,V)^alpha;
color = color.*(li_specular+li_diffuse+li_ambiant);


color(find(color<0)) = 0; % valeurs entre 0 et 255
color(find(color>1.0)) = 1.0;

end

