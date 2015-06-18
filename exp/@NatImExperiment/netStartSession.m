function [e,retInt32,retStruct,returned] = netStartSession(e, params)
% Configures and loads alpha map and all textures to be used throughout the
% experiment
%
% authors: eywalker, leon

% load experiment params
location = params.stimulusLocation;                 % center of the stimulus
bgColor = params.bgColor;                           % stimulus background color: RGB with each in range [0, 255]
diskSize = params.diskSize;                         % stimulus window diameter
fadeFactor = params.fadeFactor;                     % edge falloff for window, the edge falls off from diskSize to diskSize*fadeFactor with cosine fall off

imgPathPtrn = params.imgPathPtrn;              % path pattern to the directory with image sets (.mat). 
                                                    % Note that this should be a pattern with %d to be substituted

nTex = params.texFileNumber;                        % texture .mat file number to be used for the session
scFactor = params.texScaleFactor;                   % scaling factor for the texture - has to be an integer

% nFirst = params.firstTexNumber; %first texture to pick from texture struc.
% nLast = nFirst + nIm * nGS - 1; %last texture to pick from texture struc.
% params.lastTexNumber = nLast;

% create alpha blend mask
win = get(e,'win');
rect = Screen('Rect',win);
halfWidth = ceil(diff(rect([1 3])) / 2);
halfHeight = ceil(diff(rect([2 4])) / 2);

[X,Y] = meshgrid((-halfWidth:halfWidth-1) - location(1), ...
             (-halfHeight:halfHeight-1) - location(2));

alphaLum = repmat(shiftdim(bgColor, -2), ...
                  2*halfHeight,2*halfWidth);

% create blending map with cosine fade out
normXY = sqrt(X.^2 + Y.^2);              
disk = (normXY < diskSize/2);
blend = normXY < fadeFactor*diskSize/2 & normXY >= diskSize/2;
mv = fadeFactor*diskSize/2 - diskSize/2;
blend = (0.5*cos((normXY-diskSize/2)*pi/mv)+.5).*blend;
alphaBlend = 255 * (1-blend-disk);
e.alphaMask = Screen('MakeTexture',win,cat(3,alphaLum,alphaBlend));

% Enable alpha blending with proper blend-function. We need it
% for drawing of our alpha-mask (gaussian aperture)
win = get(e,'win');
Screen('BlendFunction',win,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);


%load texture structure

%imgPathPtrn='z:/users/eywalker/DeepLayer/LeonTextures%d.mat';
file = sprintf(imgPathPtrn, nTex);
% [~, fname, ext] = fileparts(file);
% fname = [fname ext];

f = load(file);
params.sourcefile = file;

%create textures
N = length(f.textures); % total number of images
params.totalImages = N;
fields = {'original', 'conv1', 'conv2', 'conv3', 'conv4'};
params.fields = fields;

e.textures = zeros(length(fields), N);
sm = ones(scFactor); %for scaling the pixels by scFactor

params.imgnum = [f.textures.imgnum];

% for each image and for each filtered version, generate texture and store
% the texture reference number
for i = 1:N
    for j = 1:length(fields)
        e.textures(j,i) = Screen('MakeTexture', win, kron(double(f.textures(i).(fields{j})), sm));
    end
end


% define stimulus position
e.textureSize = scFactor*size(f.textures(1).(fields{1}), 1); % this assumes a square texture...
centerX = mean(rect([1 3])) + location(1);
centerY = mean(rect([2 4])) + location(2);
% compute bounding box for the texture to be drawn in
e.destRect = [-e.textureSize -e.textureSize e.textureSize e.textureSize] / 2 ...
        + [centerX centerY centerX centerY];
    

% initialize parent
[e, retInt32, retStruct, returned] = initSession(e, params);
