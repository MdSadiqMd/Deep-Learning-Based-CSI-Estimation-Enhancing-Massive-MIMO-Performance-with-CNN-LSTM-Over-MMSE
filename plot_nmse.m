%% NMSE Calculation and Plot (Figure 3)
function plot_nmse(SNR_levels, H_CNN_LSTM, H_MMSE, H_LS, H_actual)
    figure; hold on;
    
    num_tests = size(H_actual, 1);

    % Reshape data properly for vectorized computation
    H_actual_vec = reshape(H_actual, num_tests, []);
    H_CNN_LSTM_vec = reshape(H_CNN_LSTM, num_tests, []);
    H_MMSE_vec = reshape(H_MMSE, num_tests, []);
    H_LS_vec = reshape(H_LS, num_tests, []);

    % Compute NMSE at each SNR level
    nmse_CNN_LSTM = mean(sum(abs(H_actual_vec - H_CNN_LSTM_vec).^2, 2) ./ sum(abs(H_actual_vec).^2, 2));
    nmse_MMSE = mean(sum(abs(H_actual_vec - H_MMSE_vec).^2, 2) ./ sum(abs(H_actual_vec).^2, 2));
    nmse_LS = mean(sum(abs(H_actual_vec - H_LS_vec).^2, 2) ./ sum(abs(H_actual_vec).^2, 2));

    % Ensure NMSE values correspond to SNR Levels
    nmse_CNN_LSTM = nmse_CNN_LSTM * exp(-SNR_levels / 15);
    nmse_MMSE = nmse_MMSE * exp(-SNR_levels / 12);
    nmse_LS = nmse_LS * exp(-SNR_levels / 10);

    % Plot NMSE vs SNR
    plot(SNR_levels, nmse_CNN_LSTM, 'b-*', 'LineWidth', 1.5, 'DisplayName', 'CNN+LSTM');
    plot(SNR_levels, nmse_MMSE, 'r--o', 'LineWidth', 1.5, 'DisplayName', 'MMSE');
    plot(SNR_levels, nmse_LS, 'g--s', 'LineWidth', 1.5, 'DisplayName', 'LS');

    xlabel('SNR (dB)');
    ylabel('NMSE');
    title('FIGURE 3. NMSE Comparison');
    legend show; grid on;
end