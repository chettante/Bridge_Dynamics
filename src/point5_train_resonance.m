clear all; close all; clc;

%% ============================================================
% 1) GENERAZIONE FORZANTE ARTIFICIALE (TRENO DI VAGONI) USANDO PULSTRAN
% ============================================================

L = 1;                  % lunghezza vagone [m]
D = 26;                  % distanza tra vagoni [m]
v = 100/3.6;             % velocità [m/s]

T_pulse  = L / v;        % durata impulso [s]
T_period = (L + D) / v;  % periodo treno impulsi [s]

fs = 1000;               % frequenza di campionamento [Hz]
dt = 1/fs;
T_total = 30;            % durata simulazione [s]
t = 0:dt:T_total-dt;
N = length(t);           % numero campioni

% Posizioni dei centri degli impulsi
t0 = 0:T_period:T_total;

% Definizione impulso rettangolare di durata T_pulse
h = @(t) rectpuls(t/T_pulse);

% Creazione treno di impulsi
f_t = pulstran(t, t0, h);

%% Plot della forzante nel tempo
figure;
plot(t, f_t, 'k');
grid on;
xlabel('Tempo [s]');
ylabel('Forzante unitaria');
title('Forzante nel tempo (treno di impulsi, pulstran)');

%% ============================================================
% 2) FFT DELLA FORZANTE
% ============================================================

k = 0:N-1;
freq = k*fs/N;

F = fft(f_t)/N;

%% ============================================================
% 3) CARICAMENTO MATRICI FEM
% ============================================================

load('../data/bridge_mkr.mat');

MFF = M(1:123, 1:123);
KFF = K(1:123, 1:123);
CFF = R(1:123, 1:123);

%% ============================================================
% 4) RISPOSTA IN FREQUENZA DEL SISTEMA
% ============================================================

i = sqrt(-1);
outA = zeros(1,N);
outB = zeros(1,N);

nodeA = 21;   % nodo A
nodeB = 12;   % nodo B

for k = 1:N
    ome = freq(k)*2*pi;

    % Forzante applicata SOLO al nodo A
    F_ext = zeros(123,1);
    F_ext(nodeA) = F(k);

    % Risoluzione dinamica
    A = -ome^2*MFF + i*ome*CFF + KFF;
    vect_x = A \ F_ext;

    % Estrazione nodi A e B
    outA(k) = vect_x(nodeA);
    outB(k) = vect_x(nodeB);
end

%% ============================================================
% 5) SPETTRI RISPOSTE (range 0–30 Hz)
% ============================================================

fmax = 30;

figure;
plot(freq, abs(F), 'k');
xlim([0 fmax]); grid on;
xlabel('Frequenza [Hz]'); ylabel('Ampiezza');
title('Spettro della forzante');

figure;
plot(freq, abs(outA), 'r');
xlim([0 fmax]); grid on;
xlabel('Frequenza [Hz]'); ylabel('Ampiezza');
title('Spettro risposta nodo A');

figure;
plot(freq, abs(outB), 'b');
xlim([0 fmax]); grid on;
xlabel('Frequenza [Hz]'); ylabel('Ampiezza');
title('Spettro risposta nodo B');

%% ============================================================
% 6) GRAFICO FINALE: SOVRAPPOSIZIONE SPETTRO FORZANTE, A, B
% ============================================================

figure;
hold on;
plot(freq, abs(F), 'k', 'LineWidth', 1.2);
plot(freq, abs(outA), 'r', 'LineWidth', 1.2);
plot(freq, abs(outB), 'b', 'LineWidth', 1.2);
xlim([0 fmax]);
grid on;
xlabel('Frequenza [Hz]');
ylabel('Ampiezza');
title('Confronto spettri: Forzante vs Nodo A vs Nodo B');
legend('Forzante', 'Nodo A', 'Nodo B');
hold off;
