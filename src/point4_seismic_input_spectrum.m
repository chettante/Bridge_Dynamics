filename = '../data/seismic_displ.txt';

% Read entire file as a matrix
txt = readmatrix(filename);
t = txt(:,1);
y_O1 = txt(:,2);
y_O2 = txt(:,3);

dt = 0.01;
Fs = 1/dt;
N = length(t);

% Fast Fourier Transform
F1 = fft(y_O1);
F2 = fft(y_O2);

% spettro a due lati
P2_1 = abs(F1)/N;
P2_2 = abs(F2)/N;

% spettro monolaterale corretto
P1_1 = P2_1(1:N/2+1);
P1_2 = P2_2(1:N/2+1);

P1_1(2:end-1) = 2*P1_1(2:end-1);
P1_2(2:end-1) = 2*P1_2(2:end-1);

% frequency vector
f = (0:N/2)*(Fs/N);

% plot of the spectra of the vertical displacements
figure
plot(f, P1_1)
xlabel('Frequenza [Hz]'); ylabel('Ampiezza'); 
title('Spectrum of the y displacement of O1');
grid on
xlim([0 3])

figure
plot(f, P1_2)
xlabel('Frequenza [Hz]'); ylabel('Ampiezza'); 
title('Spectrum of the y displacement of O2');
grid on
xlim([0 3])



