function normx = VectorNorm(x)

if size(x,1) >= size(x,2)
    norm_dim = 1;
    normx = zeros(size(x,1),1);
else
    norm_dim = 2;
    normx = zeros(1,size(x,2));
end

for i=1:size(x,norm_dim);
    if norm_dim==1
        normx(i)=norm(x(i,:));
    else
        normx(i)=norm(x(:,i));
    end
    
end