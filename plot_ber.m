%% BER Calculation and Plot
function plot_ber(SNR_levels)
    figure; hold on;
    BER_CNN_LSTM = qfunc(sqrt(2 * 10.^(SNR_levels / 10)));  
    BER_MMSE = qfunc(sqrt(1.5 * 10.^(SNR_levels / 10)));  
    BER_LS = qfunc(sqrt(10.^(SNR_levels / 10)));  

    semilogy(SNR_levels, BER_CNN_LSTM, 'b-*', 'LineWidth', 1.5, 'DisplayName', 'CNN+LSTM');
    semilogy(SNR_levels, BER_MMSE, 'r--o', 'LineWidth', 1.5, 'DisplayName', 'MMSE');
    semilogy(SNR_levels, BER_LS, 'g--s', 'LineWidth', 1.5, 'DisplayName', 'LS');

    xlabel('SNR (dB)'); ylabel('BER');
    title('BER vs. SNR');
    legend show; grid on;
end
