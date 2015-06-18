function P = getNonRepPerm(r, n)
    P = zeros(n);
    rows = 1:n;
    cols = rows;
    
    for i=1:n
        if length(rows) == 2
            coin = randi(2);
            if rows(1) ~= cols(coin) && rows(2) ~= cols(3-coin)
                P(rows(1), cols(coin)) = 1;
                P(rows(2), cols(3-coin)) = 1;
            else
                P(rows(1), cols(3-coin)) = 1;
                P(rows(2), cols(coin)) = 1;
            end
            break;
        end
        ri = randsample(rows, 1);
        rows = setdiff(rows, ri);
        colTmp = setdiff(cols, ri);
        ci = randsample(colTmp, 1);
        cols = setdiff(cols, ci);
        P(ri, ci) = 1;
    end
end