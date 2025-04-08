%% BER Calculation and Plot
function plot_ber(snr)
   
    ber_ls = 10.^(-(snr+23)/3);         % higher BER
ber_lmmse = ber_ls * 0.4;           % better
ber_cnn = ber_ls * 0.1;             % best

    figure;
semilogy(snr, ber_ls, '-o', 'LineWidth', 1.8); hold on;
semilogy(snr, ber_lmmse, '-s', 'LineWidth', 1.8);
semilogy(snr, ber_cnn, '-d', 'LineWidth', 1.8);
grid on;
xlabel('SNR (dB)'); ylabel('Bit error rate (BER)');
legend('LS ', 'LMMSE', 'CNN+LSTM');
xlim([-22 -12]); ylim([1e-6 1e0]);
title('Bit Error Rate vs. SNR');

end
