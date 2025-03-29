%% Channel Estimation Function
function [H_pred_CNN_LSTM, H_pred_MMSE, H_pred_LS] = estimate_channel(net, test_data, K, NT, NR)
    num_tests = size(test_data, 1);
    
    % CNN+LSTM Prediction
    preds = predict(net, reshape(test_data, num_tests, []));
    H_pred_CNN_LSTM = reshape(preds, num_tests, K, NT, NR);
    
    % LS Estimation
    H_pred_LS = test_data;
    
    % MMSE Estimation
    noise_var = 0.01;
    H_pred_MMSE = test_data ./ (1 + noise_var);
end
