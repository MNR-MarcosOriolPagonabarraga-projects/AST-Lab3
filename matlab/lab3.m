% LAB3

clear all; 
clc;

%% REFERENCE GENERATION 
% 1. Create a sine wave

% Signal parameters 
A = 20;                 % Amplitude 
w = 5;                  % Frequency (rad/s)
phase = 45;             % Offset
t = 0:0.01:5;           % vector time = 5s

signal = ReferenceGenerator(t,A,w,phase);

file = "Lab3_2.1.txt";
recording = "data/" + file;
figure(2);
plot(t, signal, 'LineWidth',1.5);
xlabel('Time [s]');
ylabel('Ángulo [deg]');
title(['Reference sinusoidal signal', file]);
grid on;

% 2. Plot values of reference position and actual position
% Extract Data
[desired_pos, actual_pos, t_sim] = load_recording(recording);

% Plot Data
ax1 = subplot(2,1,1); 
hold on;
plot(t_sim, desired_pos);
plot(t_sim, actual_pos);
xlabel('Time [s]'); 
ylabel('Actuator Position [º]');
legend('Reference', 'Actual');
ax2 = subplot(2,1,2); 
plot(t_sim, desired_pos-actual_pos);
xlabel('Time [s]'); 
ylabel('Position Error[º]');
linkaxes([ax1,ax2],'x');

%% 2.2 Extract Data

% Plot Data
figure(1);
subplot(2,1,1); 
plot(t_sim, desired_pos, t_sim, actual_pos);
xlabel('Time [s]'); ylabel('Actuator Position [º]');
legend('Reference', 'Actual');
subplot(2,1,2); plot(t_sim, desired_pos-actual_pos);
xlabel('Time [s]'); ylabel('Position Error[º]');

%% 3.1
% 1 radian per second approximately 0.159155 Hz
rads2hz = 0.159155; % in Hz.

% Experimental data
w_exp = []; % [rad/s]
gain_exp = [];
time_delay = []; %[s]
fase_exp = (-180/pi)*time_delay.*w_exp; % [º]

figure(2);
subplot(2,1,1);
semilogx(rads2hz*w_exp,20*log10(gain_exp),'r*');
xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)');
subplot(2,1,2);
semilogx(rads2hz*w_exp,fase_exp, 'r*');
xlabel('Frequency (Hz)');
ylabel('Phase (º)');
linkaxes([ax1,ax2],'x');

%% 3.2 
% 1 radian per second approximately 0.159155 Hz
rads2hz = 0.159155;
% Theoretical transfer function
K = 1;
tau = 0.1;
num = K; den = [tau, 1];
% Range of frequencies to plot the theoretical bode [rad/s]
w_min= 1; w_max= 100;
% Vector of frequencies between w_min y w_max with 100 point logarithmic equispaced
w_theoretical=logspace(log10(w_min), log10(w_max), 100);
% Theoretical bode
[gain_theo, phase_theo]=bode(num,den,w_theoretical);
% Experimental data
w_exp = []; % [rad/s]
gain_exp = [];
time_delay = []; %[s]
fase_exp = (-180/pi)*time_delay.*w_exp; % [º]
figure;
ax1 = subplot(2,1,1);
semilogx(rads2hz*w_exp,20*log10(gain_exp),'r*', rads2hz*w_theoretical, 20*log10(gain_theo));
xlabel('Frequency (Hz)');ylabel('Magnitude (dB)');
ax2 = subplot(2,1,2);
semilogx(rads2hz*w_exp,fase_exp, 'r*', rads2hz*w_theoretical, phase_theo);
xlabel('Frequency (Hz)');
ylabel('Phase (º)');
linkaxes([ax1,ax2],'x');


