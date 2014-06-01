function [ M ] = normalizeM( M )
M = M - min(M(:));
M = M ./max(M(:));
end

