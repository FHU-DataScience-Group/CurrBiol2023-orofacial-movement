function spec= computeSpectrogram_BP_rel(t, whisk, options, stim_timing)
%visualizeRawData - ToDo
%
% ToDo
%
% [書式]
%　　visualizeRawData(Dataset, options)
%
%
% [入力]
%　　Dataset: ToDo
%
%　　options: ToDo
%
%
%=========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 前処理
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% データのサンプリング周期
Fs = options.Fs; %200Hz

% Reward Window幅（単位: 秒）
RWD_WIDTH = 1;


% 最小ITI（単位: 秒）
MIN_ITI = options.MIN_ITI;

% 最小周波数 （単位: Hz）
MIN_FREQ = options.MIN_FREQ;

% 最小周波数 （単位: Hz）
MAX_FREQ = options.MAX_FREQ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


pre_cue_mask = (t >= stim_timing-.5) & (t < stim_timing);
baseline_whisk = median(whisk(pre_cue_mask));
whsk_c = whisk - baseline_whisk;

whsk_BP = bandpass(whsk_c,[4,20],Fs);

% For Whisking Spectrogram        
[~, freq_spec, time_spec, whsk_pow] =spectrogram(whsk_BP, blackman(256), 256-20, 256, Fs, 'psd');       
mask_freq = (freq_spec >= MIN_FREQ) & (freq_spec <= MAX_FREQ);
whsk_pow_roi = whsk_pow(mask_freq,:);
freq_spec_roi = freq_spec(mask_freq);
whsk_norm_pow_roi = whsk_pow_roi./sum(whsk_pow_roi,1);
whsk_norm_pow_roi(isnan(whsk_norm_pow_roi)) = 1/(MAX_FREQ-MIN_FREQ+1);
time_spec = time_spec - MIN_ITI;
mask_time = (time_spec >= stim_timing) & (time_spec < stim_timing+1);
whsk_norm_pow_roi = whsk_norm_pow_roi(:,mask_time);
time_spec = time_spec(mask_time);
spec = whsk_norm_pow_roi(:);




end

