%% use matlab to build the apdl model

%% read column nodes number
clear;
load("panelCenterCoordination.mat");
load("cablenodeCoordination.mat");
load("panelnodeall.mat");
load("columnnodeall.mat");
panelw = 1.134;
panell = 2.28;
cablenumber = 6;
linknumber = 30;
%% read pressure nodes coordination

%% open the file

% 打开文件准备写入，'w'表示写入模式，如果文件已存在会被覆盖
inputPath = strcat(['']);
filename = 'geometry.txt';
fileName = strcat(inputPath,'',filename);
fileID = fopen(fileName, 'w');

% 检查文件是否成功打开（fileID是否大于3）
if fileID == -1
    error('File cannot be opened');
end
%% write the node

fprintf(fileID, "\n/PREP7\n");
fprintf(fileID, "\n!*********************!\n");
fprintf(fileID, "!   build the node\n");
fprintf(fileID, "!*********************!\n");

% write the column nodes
arrayX = columnnodex;
arrayY = columnnodey;
arrayZ = zeros(1,numel(columnnodey));
for nodeNumber = 1:numel(columnnodey)
    fprintf(fileID, 'N,%5d,%12.6f,%12.6f,%12.6f\n', nodeNumber,arrayX(nodeNumber),arrayY(nodeNumber),arrayZ(nodeNumber));
end

% write the panel nodes
arrayX = panelx_all;
arrayY = panely_all;
arrayZ = zeros(1,numel(panely_all));
for nodeNumber = 1:numel(panely_all)
    fprintf(fileID, 'N,%5d,%12.6f,%12.6f,%12.6f\n', nodeNumber+100,arrayX(nodeNumber),arrayY(nodeNumber),arrayZ(nodeNumber));
end

% cable use some of panel nodes



%% write the element

fprintf(fileID, "\n!*********************!\n");
fprintf(fileID, "!  build the element\n");
fprintf(fileID, "!*********************!\n");

% define the element options
fprintf(fileID, "TYPE,1             !单元类型1，杆单元\n");
fprintf(fileID, "MAT,2              !材料类型2\n");
fprintf(fileID, "SECNUM,2           !截面类型2，拉索\n");
fprintf(fileID, "REAL,2             !实常数2\n");

% define the element entity of cable
fprintf(fileID, "!define the element entity of cable\n");
cablenodei = [1, [143:184],3, [143:184]+42*2, 5, [143:184]+42*5, 7, [143:184]+42*7, 9, [143:184]+42*10, 11, [143:184]+42*12];
cablenodej = [[143:184],2, [143:184]+42*2, 4, [143:184]+42*5, 6, [143:184]+42*7, 8, [143:184]+42*10, 10, [143:184]+42*12, 12];
for cableNo = 1: numel(cablenodej)
    fprintf(fileID, "EN,%5d,%5d,%5d\n",cableNo,cablenodei(cableNo),cablenodej(cableNo));
end

% define the element options
fprintf(fileID, "TYPE,3             !单元类型3，壳单元  \n");
fprintf(fileID, "MAT,3              !材料类型1，Q345\n");
fprintf(fileID, "REAL,3             !实常数3\n");
fprintf(fileID, "SECNUM,3           !截面类型3\n");

% define the element entity of panel
%give four node to establish a rectangular, so basicrect1 represent an
%basic rectangular. Than build all rectangular basicrect5.  
basicrect1 = [101,102,144,143]';
basicrect2 = [basicrect1, basicrect1+1];
basicrect3 = [basicrect2, basicrect2+42, basicrect2+42*2, basicrect2+42*3];
basicrect4 = basicrect3;
for i = 1:13
    basicrect4 = [basicrect4, basicrect3+3*i];
end
basicrect5 = [basicrect4, basicrect4+210,basicrect4+210*2];

rect = basicrect5;
for rectNo = 1:size(rect,2)
    fprintf(fileID, "EN,%5d,%5d,%5d,%5d,%5d\n",rectNo+300,rect(1,rectNo), rect(2,rectNo), rect(3,rectNo), rect(4,rectNo));
end
% write the pressure nodes
% apply surface force, do not need pressure nodes

%% Remove redundant points, nodes, elements...
fprintf(fileID, "\n!*********************!\n");
fprintf(fileID, "!  Remove redundant points, nodes, elements\n");
fprintf(fileID, "!*********************!\n");

fprintf(fileID, "nummrg,elem\n");
fprintf(fileID, "nummrg,node\n");
fprintf(fileID, "nummrg,kp\n");




%% close the file
fclose(fileID);
