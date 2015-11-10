function out = getsmo(in, ptsmooth)
% 

count = (ptsmooth - 1)/2;

n = length(in);
out = zeros(size(in));
out(1:count) = in(1:count);
out(n-1:n) = in(n-1:n);

for i = (count+1):n-count;
    out(i) = mean(in(i-count:i+count));
end