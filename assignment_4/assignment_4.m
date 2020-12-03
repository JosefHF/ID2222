E = csvread('example2.dat');
k = 4;

col1 = E(:,1);
col2 = E(:,2);
max_ids = max(max(col1,col2));
As= sparse(col1, col2, 1, max_ids, max_ids); 
A = full(As);

sigma = 1;

AfMatrix = Affinity(A,sigma);

%Sum every row of the Matrix and create a vector with the sums
sums = sum(AfMatrix);

%Create the diagonal matrix D
D = diag(sums);

%Create the Laplacian Matrix
L = D^(-1/2) * AfMatrix * D^(-1/2);

%Find the k largest eigenvectors of L and construct X
[X,d] = eigs(L, k);

%Renormalize X to have unit length
Y = zeros(size(X));
for i=1:size(X,1)
    Y(i,:) = X(i,:)./(sum(X(i,:).^2)^(1/2));
end

%Run K-means on Y.
%Assign node s_i to the cluster in row_i return by k-means
idx = kmeans(Y,k);

%Plot graph
graph_A = graph(A);
h = plot(graph_A);

%View in a specific dimension, i.e 2 or 3.
view(3)

%Highlight the nodes corresponding to a cluster
colors = ['g','r','b','y','m','c','w','k'];
for i=1:length(unique(idx))
    highlight(h,find(idx == i),'NodeColor',colors(i));
end

