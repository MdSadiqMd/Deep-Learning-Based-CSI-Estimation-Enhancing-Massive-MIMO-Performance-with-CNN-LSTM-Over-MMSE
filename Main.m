clc; clear; close all;

%% Parameters
NT = 32;  % Number of transmitter antennas (URA)
NR = 4;   % Number of receiver antennas (ULA)
K = 234;  % Number of usable subcarriers
SNR_levels = [-20 -10 0 10 20 30];
num_samples = 200;
fs = 100e6; % Bandwidth 100 MHz
fc = 28e9;  % Carrier frequency 28 GHz

%% Generate Training Data
data = zeros(num_samples, K, NT, NR);
labels = zeros(num_samples, K, NT, NR);

for i = 1:num_samples
    H = (randn(K, NT, NR) + 1j * randn(K, NT, NR)) / sqrt(2);
    noise_power = 10^(-SNR_levels(randi(length(SNR_levels)))/10);
    noise = sqrt(noise_power / 2) * (randn(K, NT, NR) + 1j * randn(K, NT, NR));
    Y = H + noise;
    
    data(i, :, :, :) = real(Y);
    labels(i, :, :, :) = real(H);
end

%% Define CNN + LSTM Model
layers = [
    featureInputLayer(K * NT * NR, 'Normalization', 'none')
    fullyConnectedLayer(1024)
    reluLayer
    dropoutLayer(0.3)
    lstmLayer(256, 'OutputMode', 'last')
    fullyConnectedLayer(K * NT * NR)
    regressionLayer
];

options = trainingOptions('adam', ...
    'MaxEpochs', 100, ...
    'MiniBatchSize', 64, ...
    'InitialLearnRate', 1e-4, ...
    'ValidationFrequency', 100, ...
    'ExecutionEnvironment', 'cpu', ...
    'Plots', 'training-progress');

% Train Network
%net = trainNetwork(reshape(data, num_samples, []), reshape(labels, num_samples, []), layers, options);
load net.mat
%% Generate Test Data
num_tests = 500;
test_data = zeros(num_tests, K, NT, NR);
test_labels = zeros(num_tests, K, NT, NR);

for i = 1:num_tests
    H = (randn(K, NT, NR) + 1j * randn(K, NT, NR)) / sqrt(2);
    noise_power = 10^(-SNR_levels(randi(length(SNR_levels)))/10);
    noise = sqrt(noise_power / 2) * (randn(K, NT, NR) + 1j * randn(K, NT, NR));
    Y = H + noise;
    
    test_data(i, :, :, :) = real(Y);
    test_labels(i, :, :, :) = real(H);
end

%% Perform Channel Estimation
[H_pred_CNN_LSTM, H_pred_MMSE, H_pred_LS] = estimate_channel(net, test_data, K, NT, NR);

%% Plot Performance Metrics
plot_nmse(SNR_levels, H_pred_CNN_LSTM, H_pred_MMSE, H_pred_LS, test_labels);
plot_gain(SNR_levels, H_pred_CNN_LSTM, H_pred_MMSE, H_pred_LS, test_labels);
plot_ber(SNR_levels);

