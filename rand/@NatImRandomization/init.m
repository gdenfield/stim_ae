function r = init(r, params)
% Initialize randomization  
% LG 07/23/13

nTotal = params.totalImages;
nIm = params.imPerTrial;

fields = params.fields;
nField = length(fields);   % total number of conditions for each image

idx = zeros(nField, nTotal);

p = randperm(nField)';
idx(:, 1) = p;

for i=2:nTotal
    p = getNonRepPerm(r, nField) * p;
    idx(:, i) = p;
end

statIdx = reshape(permute(reshape(idx, nField, nIm, []), [1, 3, 2]), [], nIm);

A = reshape(1:nTotal, nIm, [])';
imNums = reshape(repmat(shiftdim(A, -1), [nField, 1, 1]), [], nIm);

nTrial = nField * nTotal / nIm;

for i = 1 : nTrial
    conditions(i).statIdx = statIdx(i, :);
    conditions(i).imNums = imNums(i, :);
end

r.conditions = conditions;
r = resetPool(r);