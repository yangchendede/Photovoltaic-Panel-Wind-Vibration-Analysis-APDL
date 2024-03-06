clear;
%% define time step and some parameter
ww = 0:10:180;
freq = 312.5;
time = 90;
N = freq * time;
geometricScale = 7;
windspeedScale = 30/10;
timeScale = geometricScale / windspeedScale;
protoFreq = freq / timeScale;
dt = 1 / protoFreq;
timeNum = 2800;
t=dt:dt:(timeNum * dt);
t = 1:2800;
pressureNlist = [1:336];
loadN = numel(pressureNlist);
%% load pressure

%% calculte pressure should be applied
pressure = rand(loadN, timeNum)*1000;

%% load 336 net pressure to 336 element surface

% load pressure data order to apdl element mapping relation
temp = load("pressurenumbermapping.mat");
loadElementlist = temp.pressurenumbermaping;

% pressureNlist = [1:336];
clear temp;

%% open the file
% 打开文件准备写入，'w'表示写入模式，如果文件已存在会被覆盖
inputPath = strcat(['']);
filename = 'loadhistory.txt';
fileName = strcat(inputPath,'',filename);
fileID = fopen(fileName, 'w');
% 检查文件是否成功打开（fileID是否大于3）
if fileID == -1
    error('File cannot be opened');
end
fprintf(fileID, "\n!*********************!\n");
fprintf(fileID, "! define time-step load\n");
fprintf(fileID, "!*********************!\n");



% write time-step loads
for wangle = 1:1
    w = ww(wangle);
%     inputfile = 
%     load
timeNum = 20
    for tt = 1:timeNum
%         fprintf(fileID,'TIME,%12.6f\n',t(tt)); %set time step
        fprintf(fileID,'TIME,%5d\n',t(tt)); %set time step
        fprintf(fileID,'NSUBST,1,,,1\nKBC,0\n'); 
        %NSUBST: Specifies the number of substeps to be taken this load step.
        %KBC: Specifies ramped or stepped loading within a load step.
%         for pressurei = 1:loadN
        for pressurei = 8:8
            % SFE, Elem, LKEY, Lab, KVAL, VAL1, VAL2, VAL3, VAL4
%             fprintf(fileID,'SFE,%5d,%5d,PRES,1,%12.6f\n',loadElementlist(pressurei), 1,pressure(pressurei,tt));
            fprintf(fileID,'F,%d,FZ,%12.6f\n',105,pressure(pressurei,tt));
        end
        fprintf(fileID,'SOLVE\n');
%             fprintf(fileID,'LSWRITE\n');
    end
%     fprintf(fileID,'LSWRITE\n');
%     fprintf(fileID,'PSOLVE\n');
end

%% close the file
fclose(fileID);

