function [ Ms ] = diamondSquare( Me, nbRand)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

Ms = zeros(2 * size(Me, 1) - 1, 2 * size(Me, 2) - 1);


sizeMs1 = size(Ms, 1);
sizeMs2 = size(Ms, 2);
% recopie des valeurs initiales
for i=1:size(Me, 1)
    for j=1:size(Me, 2)
        Ms(2*i - 1, 2 * j - 1) = Me(i, j);
    end
end

% On remplit les valeurs ajoutés au centre des carrés existants (étape
% diamond)
for i=1:(size(Me, 1) - 1)
    for j=1:(size(Me, 2) - 1)
        Ms(2*i, 2 * j) = (Me(i, j) + Me(i+1, j) + Me(i, j+1) + Me(i+1, j+1)) / 4;
        Ms(2*i, 2 * j) = Ms(2*i, 2 * j) + rand(1) * nbRand - (nbRand/2);
    end
end

% On remplit les autre (étape square)
for i=1:sizeMs1
    for j=1:sizeMs2
        cpt = 0;
        if Ms(i, j) == 0
            if i-1 >= 1
                Ms(i, j) = Ms(i, j) + Ms(i-1, j);
                cpt = cpt+1;
            end
            if j-1 >= 1
                Ms(i, j) = Ms(i, j) + Ms(i, j-1);
                cpt = cpt+1;
            end
            if j+1 <= sizeMs2
                Ms(i, j) = Ms(i, j) + Ms(i, j+1);
                cpt = cpt+1;
            end
            if i+1 <= sizeMs1
                Ms(i, j) = Ms(i, j) + Ms(i+1, j);
                cpt = cpt+1;
            end
            Ms(i, j) = Ms(i, j) / cpt;
            Ms(i, j) = Ms(i, j) + rand(1) * nbRand - nbRand/2;
        end
    end
end

end

