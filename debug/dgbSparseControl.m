% Script to test TrialBasedExperiment
% AE 2007-10-08

warning off TrialBasedExperiment:netStartTrial
warning off TrialBasedExperiment:netEndTrial
warning off StimulationData:setTrialParam
warning off StimulationData:setParam

T = SparseCodingControlExperiment;
T = set(T,'debug',true);
T = openWindow(T);

constants.subject = 'DEBUG';
constants.eyeControl = 0;
constants.stimulusTime = 500;

constants.bgColor = [64; 64; 64];
constants.fixSpotColor = [255; 0; 0];
constants.fixSpotLocation = [0; 0];
constants.fixSpotSize = 10;

constants.location = [50; 50];
constants.diskSize = 200;
constants.fadeFactor = 1.3;

constants.imagePath = '/lab/users/philipp/sparsecoding/stimuli';
constants.imageStats = [1,2,3];
constants.modFunction = '1';

constants.rewardProb = 1;

constants.delayTime = 1000;
constants.postStimulusTime = 250;
constants.rewardAmount = 0;
constants.date = datestr(now,'YYYY-mm-dd_HH-MM-SS');
constants.joystickThreshold = 10000;
constants.fixationRadius = 1000;
constants.passive = true;
constants.acquireFixation = 10;
constants.allowSaccades = false;

trials = struct;

T = netStartSession(T,constants);

for i = 1:20
    
    fprintf('trial #%d\n',i)

    T = netStartTrial(T,trials);
    T = netSync(T,struct('counter',0));
    T = netSync(T,struct('counter',1));
    T = netInitTrial(T);
    
%    T = netAcquireFixation(T,struct);
    pause(0.5)
    
    T = netShowStimulus(T,struct);
    
    T = netTrialOutcome(T,struct('correctResponse',true));
    T = netEndTrial(T);

    pause(0.5)
end

T = netEndSession(T);
T = cleanUp(T);

