function [ Tr ] = CameraTransfo( po, pr, k, d )
% donne la matrice de transformation en perspective
% origine: po, point regardé: pr, vecteur "up": k

    k = [0 0 1];
    w = (po - pr);
    w = w/norm(w);
    u = cross(k, w)';
    u = u./norm(u);
    v = cross(u, w);

    % Perspective
    P = eye(4);
    P(4,3)=1/d;
    %P(3,3) = 0;

    % Translation
    T = eye(4,4);
    T(1,4) = po(1);
    T(2,4) = po(2);
    T(3,4) = po(3);

    % Rotation
    R = [
    u(1),v(1),w(1),0;
    u(2),v(2),w(2),0;
    u(3),v(3),w(3),0;
    0,0,0,1;];

    % Transform
    Tr = eye(4);
    Tr = P*inv(R)*inv(T);
end

