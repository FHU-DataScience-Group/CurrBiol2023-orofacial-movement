function cp_spec = computeCuePeriodSpectrogram(t, whisk, options)
%visualizeRawData - ToDo
%
% ToDo
%
% [����]
%�@�@visualizeRawData(Dataset, options)
%
%
% [����]
%�@�@Dataset: ToDo
%
%�@�@options: ToDo
%
%
%=========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �O����
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% �f�[�^�̃T���v�����O����
Fs = options.Fs;

% Cue�񎦎��ԁi�P��: �b�j
CUE_DUR = options.CUE_DUR;

% �ŏ�ITI�i�P��: �b�j
MIN_ITI = options.MIN_ITI;

% �ŏ����g�� �i�P��: Hz�j
MIN_FREQ = options.MIN_FREQ;

% �ŏ����g�� �i�P��: Hz�j
MAX_FREQ = options.MAX_FREQ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Cue period��Ԃł�protraction�ʂ��v�Z����
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pre_cue_mask = (t >= -MIN_ITI/2) & (t < 0.0);
baseline_whisk = median(whisk(pre_cue_mask));
whsk_c = whisk - baseline_whisk;

% For Whisking Spectrogram    
[~, freq_spec, time_spec, whsk_pow] = spectrogram(whsk_c,Fs*0.5,Fs*0.25,Fs,Fs,'power','yaxis');
mask_freq = (freq_spec >= MIN_FREQ) & (freq_spec <= MAX_FREQ);
whsk_pow_roi = whsk_pow(mask_freq,:);
freq_spec_roi = freq_spec(mask_freq);
whsk_norm_pow_roi = whsk_pow_roi./sum(whsk_pow_roi,1);
whsk_norm_pow_roi(isnan(whsk_norm_pow_roi)) = 1/(MAX_FREQ-MIN_FREQ+1);
time_spec = time_spec - MIN_ITI;
mask_time = (time_spec >= 0) & (time_spec < CUE_DUR);
whsk_norm_pow_roi = whsk_norm_pow_roi(:,mask_time);
time_spec = time_spec(mask_time);

cp_spec = whsk_norm_pow_roi(:);
% heatmap_custom(whsk_norm_pow_roi, time_spec, freq_spec_roi, [], ...
%     'Colormap', 'jet',  'NaNColor', [0.8 0.8 0.8], ...
%     'ShowAllTicks', true, 'MinColorValue', 0, 'MaxColorValue', +0.5, ...
%     'TickAngle', 90, 'TickFontSize', 8);
% pause;
% figure(1);
% clf;
% plot(t,whisk);
% hold on;
% plot([min(t),max(t)],[baseline_whisk,baseline_whisk],'--');
% plot([min(t),max(t)],[cs_whisk,cs_whisk],'--');
% plot([min(t),max(t)],[baseline_whisk+cp_protraction,baseline_whisk+cp_protraction],'r:');
% pause;
end

