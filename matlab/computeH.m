function [ H2to1 ] = computeH( x1, x2 )
%COMPUTEH Computes the homography between two sets of points
    inSize = size(x1);
    A = [];


    for i = 1:inSize(1)
       a1 = [ -x2(i,1), -x2(i,2), -1, 0, 0, 0, x1(i,1)*x2(i,1), x1(i,1)*x2(i,2), x1(i, 1)];
       a2 = [ 0, 0, 0, -x2(i,1), -x2(i,2), -1, x1(i,2)*x2(i,1), x1(i,2)*x2(i,2), x1(i, 2)];
       A = [A;a1;a2];
    end
    
    A = double(A);
    [~, S, V] = svd(A);
    
    %Get the row of V of the smallest S index.
    %The index that is smallest then get the ith column of V
    smIndex = 1;
    smValue = S(1,1);
    s = size(S);

    if s(1) < s(2)
        dimS = s(1);
    else
        dimS = s(2);
    end
    for i = 2:dimS
        if smValue > S(i,i)
            smValue = S(i,i);
            smIndex = i;
        end
    end

    H2to1 = V(:, smIndex);
    H2to1 = reshape(H2to1,[3,3]).';
end
%2 = x
%3 = y