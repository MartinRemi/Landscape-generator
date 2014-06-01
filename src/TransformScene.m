function [ B ] = TransformScene( tri, Tr )
% prend tous les points de triangle et les converti en coordonées 2D
    A = zeros(3*size(tri, 1), 4);
    for i=1:size(tri, 1)
        A(3*i-2, :) = [tri(i,1),tri(i,2),tri(i,3),1];
        A(3*i-1, :) = [tri(i,4),tri(i,5),tri(i,6),1];
        A(3*i,   :) = [tri(i,7),tri(i,8),tri(i,9),1];
    end

    B = zeros(size(A,1), 3);
    Paul = zeros(4);
    for i=1:size(B,1)
        Paul = Tr*A(i, :)';
        B(i, :) = Paul(1:3)./Paul(4);
    end

end

