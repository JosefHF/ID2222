E = csvread('example1.dat');

col1 = E(:,1);
col2 = E(:,2);

%Converting Edge list to adjacency matrix
max_ids = max(max(col1,col2));
As= sparse(col1, col2, 1, max_ids, max_ids);
A = full(As);
graph_a = graph(A);
%Create the affinity matrix Af
%A(i,j) = 0 if i and j not connected
%A(i,j) = exp(abs(x_i,x_j)/(2*sigma^2))
sigma = 1;
for i=1:size(A,1)
    for j=1:size(A,1)
        if A(i,j) == 1
            Af(i,j) = 0;
        end
        if A(i,j) == 0
            Af(i,j) = exp(-(abs(i-j)/(2*sigma^2)));
        end
    end
end

%Define the diagonal matrix
D = diag(sum(Af,2));

%Construct L
L = D^(-1/2) * Af * D^(-1/2);

%Getting k largest eigenvalues and vectors
k = 4;
[X,d] = eigs(L,k);

%Form matrix Y by normalizing each of Xs rows
Y = X/(sum(X.^2).^(1/2));
Y = bsxfun(@rdivide,X,Y);

%Use kmeans
[idx,C] = kmeans(Y,k,'MaxIter',100);
figure;
hold on;
pl = plot(graph_a);
highlight(pl,find(idx==1),'NodeColor','r')
highlight(pl,find(idx==2),'NodeColor','g')
highlight(pl,find(idx==3),'NodeColor','b')
highlight(pl,find(idx==4),'NodeColor','c')