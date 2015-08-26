function [counts, uns] = count_unique(ids)
uns= unique(ids);
counts = arrayfun(@(x)sum(ids == x), uns);
end