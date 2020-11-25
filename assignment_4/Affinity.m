function Af = Affinity(A, sigma)
    Af = zeros(size(A,1),size(A,1));
    for i=1:size(A,1)
        for j=1:size(A,1)
            if i == j
                Af(i,j) = 0;
            else
                Af(i,j) = exp(-(abs(i-j)/(2*sigma^2)));
            end
        end
    end
end 