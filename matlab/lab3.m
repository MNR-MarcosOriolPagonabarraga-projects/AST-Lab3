clear all; 
clc;
close all;

%% REFERENCE GENERATION

A = 20;                 % Amplitude 
w = 5;                  % Frequency (rad/s)
phase = 45;             % Offset
t = 0:0.01:5;           % vector time = 5s

signal = ReferenceGenerator(t,A,w,phase);
file_2_1 = "Lab3_2.1.txt";
recording_path_2_1 = fullfile('data', file_2_1);

figure('Position', [100, 100, 800, 600]);

[desired_pos, actual_pos, t_sim] = load_recording(recording_path_2_1);

ax1 = subplot(2,1,1); 
hold on;
plot(t_sim, desired_pos, 'LineWidth', 1.5);
plot(t_sim, actual_pos, 'LineWidth', 1.5);
title('Reference Gerenated Position vs Arm Position');
xlabel('Time [s]'); 
ylabel('Position [º]');
legend('Reference', 'Actual');
grid on;

ax2 = subplot(2,1,2); 
plot(t_sim, desired_pos - actual_pos, 'LineWidth', 1.5);
xlabel('Time [s]'); 
ylabel('Position Error [º]');
grid on;
linkaxes([ax1,ax2],'x');

% Save Figure
saveas(gcf, 'report/img/Ex2_Response.png');
disp('Saved Ex2_Response.png');


%% 3.1 SYSTEM IDENTIFICATION (Data Processing)

files_3_1 = { ...
    'Lab3_3.1.1.txt', ...
    'Lab3_3.1.2.txt', ...
    'Lab3_3.1.3.txt', ...
    'Lab3_3.1.4.txt', ...
    'Lab3_3.1.5.txt' ...
};

w_exp = zeros(1, length(files_3_1));
gain_exp = zeros(1, length(files_3_1));
phase_exp = zeros(1, length(files_3_1));

disp('Processing System Identification files...');

% Loop through each file
for i = 1:length(files_3_1)
    filename = files_3_1{i};
    filepath = fullfile('data', filename);
    
    % Load data (assuming your updated load_recording handles the unique/cleaning)
    [des, act, t_s] = load_recording(filepath);
    
    % Remove DC offset for calculations
    des_ac = des - mean(des);
    act_ac = act - mean(act);
    
    f = figure('Position', [100, 100, 1000, 600], 'Visible', 'off');
    
    % Reference vs Actual
    ax1 = subplot(2,1,1);
    hold on;
    plot(t_s, des, 'LineWidth', 1.5);
    plot(t_s, act, 'LineWidth', 1.5);
    title('Reference Generator Position vs Arm Position');
    xlabel('Time [s]'); 
    ylabel('Position [º]');
    legend('Reference', 'Actual');
    grid on;
    
    % Position Error
    ax2 = subplot(2,1,2);
    plot(t_s, des - act, 'LineWidth', 1.5);
    xlabel('Time [s]'); 
    ylabel('Position Error [º]');
    grid on;
    linkaxes([ax1,ax2],'x');
    
    % Save the figure
    img_name = strrep(filename, '.txt', '.png'); 
    saveas(f, fullfile('report/img', img_name));
    disp(['Saved plot for ', filename]);
    close(f);

    % Find peaks to estimate period
    [pks, locs] = findpeaks(des_ac, t_s);
    if length(locs) > 1
        T_avg = mean(diff(locs));
        w_val = 2*pi / T_avg;
    else
        w_val = 0;
    end
    w_exp(i) = w_val;
    
    % Estimate Gain (Magnitude Output / Magnitude Input)
    amp_in = rms(des_ac) * sqrt(2);
    amp_out = rms(act_ac) * sqrt(2);
    gain_exp(i) = amp_out / amp_in;
    
    % Estimate Phase (Time delay)
    [acor, lag] = xcorr(act_ac, des_ac);
    [~, I] = max(acor);
    lagDiff = lag(I);
    timeDiff = lagDiff * mean(diff(t_s)); % Convert sample lag to time
    
    % Normalize phase to (-180, 180)
    ph_val = -w_val * timeDiff * (180/pi); 
    while ph_val <= -180
        ph_val = ph_val + 360; 
    end
    while ph_val > 180
        ph_val = ph_val - 360; 
    end
    
    phase_exp(i) = ph_val;
    
    fprintf('File %s: w=%.2f rad/s, Gain=%.2f, Phase=%.2f deg\n', ...
        filename, w_exp(i), gain_exp(i), phase_exp(i));
        
end
% Sort data by frequency (crucial for Bode plot lines)
[w_exp, sortIdx] = sort(w_exp);
gain_exp = gain_exp(sortIdx);
phase_exp = phase_exp(sortIdx);

rads2hz = 1/(2*pi);

% Plot Experimental Bode
figure('Position', [100, 100, 800, 600]);
ax1 = subplot(2,1,1);
semilogx(rads2hz*w_exp, 20*log10(gain_exp), 'r*-', 'LineWidth', 1.5, 'MarkerSize', 8);
xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)');
title('Experimental Bode Diagram');
grid on;

ax2 = subplot(2,1,2);
semilogx(rads2hz*w_exp, phase_exp, 'r*-', 'LineWidth', 1.5, 'MarkerSize', 8);
xlabel('Frequency (Hz)');
ylabel('Phase (º)');
grid on;
linkaxes([ax1,ax2],'x');

saveas(gcf, 'report/img/Ex3_1_ExperimentalBode.png');
disp('Saved Ex3_1_ExperimentalBode.png');


%% 3.2 MODEL FITTING

K = 1;      % Gain
tau = 0.1;  % Time constant

num = K; 
den = [tau, 1];

% Range of frequencies to plot the theoretical bode [rad/s]
w_min = 0.1; 
w_max = 100;
w_theoretical = logspace(log10(w_min), log10(w_max), 100);

% Theoretical bode
[gain_theo, phase_theo] = bode(num, den, w_theoretical);
% Convert to accessible arrays
gain_theo = squeeze(gain_theo);
phase_theo = squeeze(phase_theo);

% Plot Comparison
figure('Position', [100, 100, 800, 600]);
ax1 = subplot(2,1,1);
semilogx(rads2hz*w_exp, 20*log10(gain_exp), 'r*', 'MarkerSize', 8); 
hold on;
semilogx(rads2hz*w_theoretical, 20*log10(gain_theo), 'b-', 'LineWidth', 1.5);
xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)');
title(['Bode Estimation (K=', num2str(K), ', \tau=', num2str(tau), ')']);
legend('Experimental', 'Theoretical');
grid on;

ax2 = subplot(2,1,2);
semilogx(rads2hz*w_exp, phase_exp, 'r*', 'MarkerSize', 8);
hold on;
semilogx(rads2hz*w_theoretical, phase_theo, 'b-', 'LineWidth', 1.5);
xlabel('Frequency (Hz)');
ylabel('Phase (º)');
grid on;
linkaxes([ax1,ax2],'x');

saveas(gcf, 'report/img/Ex3_2_ModelFitting.png');
disp('Saved Ex3_2_ModelFitting.png');

%% 3.3 BANDWIDTH CALCULATION

bw_rad = 1/tau;
bw_hz = bw_rad * rads2hz;

fprintf('\nEstimated System Parameters:\n');
fprintf('K = %.2f\n', K);
fprintf('Tau = %.2f s\n', tau);
fprintf('Theoretical Bandwidth = %.2f rad/s (%.2f Hz)\n', bw_rad, bw_hz);