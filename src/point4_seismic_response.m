clear all

% Extraction of sismic displacement vectors
filename = '../data/seismic_displ.txt';
txt = readmatrix(filename);
t = txt(:,1);                  % time vector
y_O1 = txt(:,2);               % displacement of constraint O1
y_O2 = txt(:,3);               % displacement of constraint O2

dt = t(2) - t(1);              % sampling period    0.01 s
fs = 1/dt;                     % sampling frequency 100 Hz
N = length(t);                 % number of samples
k = 0:N-1;                     % vector of samples
freq = k*fs/N;                 % frequencies considered

% Spectrum of the two sismic signals
F1 = fft(y_O1)/N;              % divided by N to obtain the magnitude
F2 = fft(y_O2)/N;

% Spectrum representation of constraint O1 displacement
figure(1)
plot(freq, abs(F1)), grid on, xlim([0 5])
xlabel('Frequenza [Hz]'); ylabel('Ampiezza [m]');
title('Spectrum of the y displacement of O1');

% Spectrum representation of constraint O2 displacement
figure(2)
plot(freq, abs(F2)), grid on, xlim([0 5])
xlabel('Frequenza [Hz]'); ylabel('Ampiezza [m]');
title('Spectrum of the y displacement of O2');

% Load and partition of the structural matrices from FEM software
load('../data/bridge_mkr.mat');

MFF = M(1:123, 1:123);
KFF = K(1:123, 1:123);
CFF = R(1:123, 1:123);

MFC = M(1:123, 124:126);
KFC = K(1:123, 124:126);
CFC = R(1:123, 124:126);

MCF = M(124:126, 1:123);
KCF = K(124:126, 1:123);
CCF = R(124:126, 1:123);

MCC = M(124:126, 124:126);
KCC = K(124:126, 124:126);
CCC = R(124:126, 124:126);

% FRF to obtain the effect of the seismic displacement to the nodes A and B
i=sqrt(-1);
for k=1:length(freq)
    xc01=[0;
        F1(k);
        0];
    xc02=[0;
        0;
        F2(k)];
    ome=freq(k)*2*pi;
    vect_f_FC01=-(-ome^2*MFC+i*ome*CFC+KFC)*xc01;
    A=-ome^2*MFF+i*ome*CFF+KFF;
    vect_x_F01=A\vect_f_FC01;

    vect_f_FC02=-(-ome^2*MFC+i*ome*CFC+KFC)*xc02;
    A=-ome^2*MFF+i*ome*CFF+KFF;
    vect_x_F02=A\vect_f_FC02;

    y_A1 = vect_x_F01(21);
    y_B1 = vect_x_F01(12);
    y_A2 = vect_x_F02(21);
    y_B2 = vect_x_F02(12);
    y_A = y_A1 + y_A2;
    y_B = y_B1 + y_B2;
    y_ddA = - ome^2*y_A;
    y_ddB = - ome^2*y_B;

    out1(k)=y_A;
    out2(k)=y_B;
    out3(k)=y_ddA;
    out4(k)=y_ddB;
end

% Spectrum representation of y_A
figure(3)
plot(freq,abs(out1));
grid on, xlim([0 3])
title('spectrum y_A');
xlabel('Freq. [Hz]'); ylabel('Amplitude [m]');

% Spectrum representation of y_B
figure(4)
plot(freq,abs(out2));
grid on, xlim([0 3])
title('spectrum y_B');
xlabel('Freq. [Hz]'); ylabel('Amplitude [m]');

% Spectrum representation of y_ddA
figure(5)
plot(freq,abs(out3));
grid on, xlim([0 30])
title('spectrum y_ddA');
xlabel('Freq. [Hz]'); ylabel('Amplitude [m]');

% Spectrum representation of y_ddB
figure(6)
plot(freq,abs(out4));
grid on, xlim([0 30])
title('spectrum y_ddB');
xlabel('Freq. [Hz]'); ylabel('Amplitude [m]');

% Time history
y_A_t = ifft(out1*N,'symmetric');
y_B_t = ifft(out2*N,'symmetric');
y_ddA_t=ifft(out3*N,'symmetric');
y_ddB_t=ifft(out4*N,'symmetric');

% Time history of y_A
figure(7)
plot(t,y_A_t);
grid on
title('time history of A');
xlabel('Time. [s]'); ylabel('Displacement [m]');

% Time history of y_B
figure(8)
plot(t,y_B_t);
grid on
title('time history of B');
xlabel('Time. [s]'); ylabel('Displacement [m]');

% Time history of y_ddA
figure(9)
plot(t,y_ddA_t);
grid on
title('time history of y_ddA');
xlabel('Time. [s]'); ylabel('Acceleration [m/s^2]');

% Time history of y_ddB
figure(10)
plot(t,y_ddB_t);
grid on
title('time history of y_ddB');
xlabel('Time. [s]'); ylabel('Acceleration [m/s^2]');

% Comparison of the time history signals
figure(11)
plot(t, y_O1);
hold on 
plot(t, y_O2);
hold on
plot(t, y_A_t);
hold on 
plot(t, y_B_t);
grid on
title('time histories');
xlabel('Time. [s]'); ylabel('Displacement [m]');
legend('y_O_1(t)', 'y_O_2(t)', 'y_A(t)', 'y_B(t)')
hold off

