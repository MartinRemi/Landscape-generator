function [ d ] = dist( p, a )
x = p-a;
x = x*x';
d = abs(sum(x));
d = sqrt(d);
end

