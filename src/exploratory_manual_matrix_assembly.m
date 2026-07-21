% codice matrici [E_k]

load('bridge_mkr.mat');   %Load file containing structural matrices
%print the obtained matrices
K 
M 
R  %%sarebbe la matrice D

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GET NODES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CONNECTIONS OF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BEAMS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Read .inp file to know the strucure of the bridge
filename = 'bridge.inp';

% Read entire file as text
txt = fileread(filename);

% --- Extract only the BEAMS block ---
expr = '\*BEAMS(.*?)\*ENDBEAMS';
block = regexp(txt, expr, 'tokens', 'dotall');
block = block{1}{1};

% Split into individual lines
lines = strsplit(block, '\n');

A = [];
B = [];

for i = 1:numel(lines)
    line = strtrim(lines{i});
    
    % Skip empty lines or non-numeric lines
    if isempty(line) || startsWith(line, '*')
        continue;
    end
    
    % Extract numbers from the line
    nums = sscanf(line, '%f');
    
    % Each beam line has at least 3 numbers: ID, A, B
    if numel(nums) >= 3
        A(end+1,1) = nums(2);   % second column
        B(end+1,1) = nums(3);   % third column
    end
end

% Show the results
A
B

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%COMPUTE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%MATRIX E
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%AND COMPUTE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%EQ AT SLIDE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%28 of FEM pptx
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Mnew_sum = zeros(126, 126);
Knew_sum = zeros(126, 126);
Ek = zeros(6, 126);   %Initialize  E as a 6x126 matrix full of zeros (line/column 1 --> i =1)
Ek
%iterate to create matrix E for each beam
for i = 1:67
    Ek(1, A(i)*3-3+1) = 1;
    Ek(2, A(i)*3-3+2) = 1;
    Ek(3, A(i)*3-3+3) = 1;

    Ek(4, B(i)*3-3+1) = 1;
    Ek(5, B(i)*3-3+2) = 1;
    Ek(6, B(i)*3-3+3) = 1;

    Mkg = M(i,i);         %Mkg is the k-th element of M's diagonal
    Mknew = Ek'*Mkg*Ek;   %apply Ek
    size(Mknew)
    Mnew_sum = Mnew_sum + Mknew; %sommatoria


    Kkg = K(i,i);         %Kkg is the k-th element of K's diagonal
    Kknew = Ek'*Kkg*Ek;   %apply Ek 
    size(Kknew)
    Knew_sum = Knew_sum + Kknew; %sommatoria
end


Mnew_sum
Knew_sum
D = 0.15 * Mnew_sum + 9e-5*Knew_sum;
size(D)
%Now I have transformed M, K and D matrices,

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Read seismic file and compute the matrice R  (page 37 of pptx)
%since no external force is applyed other than the sismic movement which is
%applied to the constraits O1 and O2 we have Fk^G = 0 for all k

%partiziono le matrici Mnew_sum, Knew_sum and R (which is D) to separate
%constraints coordinates from the free coordinates 
MFF = Mnew_sum(1:120, 1:120);
MFC = Mnew_sum(1:120, 121:126);
MCF = Mnew_sum(121:126, 1:120);
MCC = Mnew_sum(121:126, 121:126);

KFF = Knew_sum(1:120, 1:120);
KFC = Knew_sum(1:120, 121:126);
KCF = Knew_sum(121:126, 1:120);
KCC = Knew_sum(121:126, 121:126);

DFF = D(1:120, 1:120);
DFC = D(1:120, 121:126);
DCF = D(121:126, 1:120);
DCC = D(121:126, 121:126);

% carica il file
data = load('seismic_displ.txt');

% colonne
t  = data(:,1);      % tempo
y1 = data(:,2);      % spostamento hinge 1
y2 = data(:,3);      % spostamento hinge 2

% vettore spostamenti vincolati
% ordine: [hinge 1; hinge 2]
xc = [y1.'; y2.'];   % 2 x Nt

dt = t(2) - t(1);

% velocità
xc_dot = gradient(xc, dt);

% accelerazione
xc_ddot = gradient(xc_dot, dt);

%Now eq 1 of page 37 can be used to compute  Xf, xfdot and xfddot

%Now eq 2 can be used to compute R














