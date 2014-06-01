function [ Ms ] = repeatDS( Me, x )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

nbRand = 50;
Ms = Me;

for i=1:x
    Ms = diamondSquare(Ms, nbRand);
    nbRand = nbRand / 2;
end

for i=1:size(Ms, 1)
    for j=1:size(Ms, 2)
        if Ms(i, j) < 590
            Ms(i, j) = 590;
        end
    end
end

end

