function visualizeModifiedWhiskerSpectrogramForDay(data, options, fig_dir)
%visualizeWhiskerSpectrogramForDay -
%
% ToDo
%
% [����]
%�@�@visualizeWhiskerSpectrogramForDay(data, options, fig_dir)
%
%
% [����]
%�@�@data: ToDo
%
%�@�@options: ToDo
%
%
%=========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �e��萔�̐ݒ�
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Figure Window�̕�
FIG_XSize = 560;

% Figure Window�̍���
FIG_YSize = 720;

% �f�[�^�̃T���v�����O����
Fs = options.Fs;

% Cue, Reward�񎦎��̓d���i�P��: V�j
CUE_V = options.CUE_V;

% Lick�Z���T�[��臒l�i�P��: V�j
LICK_TH = options.LICK_TH;

% Cue�񎦎��ԁi�P��: �b�j
CUE_DUR = options.CUE_DUR;

% Reward Window���i�P��: �b�j
RWD_WIDTH = options.RWD_WIDTH;

% �g���C�A���O�ŏ��҂����ԁi�P��: �b�j
MIN_ITI = options.MIN_ITI;

% Whisking��͂̍ŏ����g�� �i�P��: Hz�j
MIN_FREQ = options.MIN_FREQ;

% Whisking��͂̍ő���g�� �i�P��: Hz�j
MAX_FREQ = options.MAX_FREQ;

% Color Order�̎擾
co = get(gca,'ColorOrder');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �t�H���_�쐬�����PDF���|�[�g�t�@�C���̍쐬
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~isempty(fig_dir)
    % �o�͐�t�H���_�����݂��Ȃ��ꍇ�͍쐬����
    if ~exist(fig_dir, 'dir')
        mkdir(fig_dir);
    end
    disp(fig_dir);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Figure Window�̐����ƃ��T�C�Y
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h1 = figure(1);
POS = get(h1, 'Position');
POS(3:4) = [FIG_XSize, FIG_YSize];
set(h1, 'Position', POS);
clf;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �e�g���C�A����Whisker movement spectrogram��`�悷��
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NumTrials = length(data.trials);
for k = 1:NumTrials
    trial = data.trials{k};
    %
    t = trial.values.Time;
    vis_mask = t <= (CUE_DUR+RWD_WIDTH+MIN_ITI);
    t = t(vis_mask);
    rwd = trial.values.Rwd(vis_mask);
    lick = trial.values.Lick(vis_mask);
    whsk = trial.values.Whisker(vis_mask);
    % ITI�̃}�X�N���쐬����
    iti_mask = t < 0;
    % ITI���̃x�[�X���C���p�x���v�Z����
    whsk_base = median(whsk(iti_mask));
    % Whisking�f�[�^�̃x�[�X���C���␳
    whsk_c = whsk-whsk_base;
        
    clf(h1);
    % For cue and reward
    subplot(7,2,1:2);
    if strcmp(trial.cue, 'Go')
        cue_color = co(1,:);
        cue_legend = 'Go';
    elseif strcmp(trial.cue, 'No Go')
        cue_color = co(2,:);
        cue_legend = 'No-Go';
    elseif strcmp(trial.cue, 'Omission')
        cue_color = co(3,:);
        cue_legend = 'Omission';
    end
    outcome = trial.outcome;
    if strcmp(trial.outcome, 'Lick')
        outcome = 'OH';
    elseif strcmp(trial.outcome, 'No Lick')
        outcome = 'OM';
    end
            
    cue = zeros(size(t));
    cue_mask = (t >= 0.0) & (t < CUE_DUR);
    cue(cue_mask) = 1;
    hold on;
    x_rect = [0, 0, CUE_DUR, CUE_DUR];
    y_rect = [-0.05, 1.05, 1.05, -0.05];
    patch(x_rect, y_rect, 'c' , 'EdgeColor', 'none', 'FaceAlpha', 0.1);
    x_rect = [CUE_DUR, CUE_DUR, CUE_DUR+RWD_WIDTH, CUE_DUR+RWD_WIDTH];
    y_rect = [-0.05, 1.05, 1.05, -0.05];
    patch(x_rect, y_rect, 'g' , 'EdgeColor', 'none', 'FaceAlpha', 0.1);
    plt1 = plot(t, rwd >= (CUE_V/2), 'm-');
    plt2 = plot(t, cue, '-', 'Color', cue_color);    
    hold off;
    xlim([min(t),max(t)]);
    ylim([-0.05,1.05]);
    legend([plt2, plt1], cue_legend,'Reward');
    set(gca,'YTick',[0,1]);
    set(gca,'YTickLabel',{'OFF', 'ON'});
    title(sprintf('Trial = %d (%s)', trial.trial_id, ...
        outcome));
    
    % For Licking
    subplot(7,2,3:4);
    hold on;
    x_rect = [0, 0, CUE_DUR, CUE_DUR];
    y_rect = [-2*LICK_TH, +2*LICK_TH, +2*LICK_TH, -2*LICK_TH];
    patch(x_rect, y_rect, 'c' , 'EdgeColor', 'none', 'FaceAlpha', 0.1);
    x_rect = [CUE_DUR, CUE_DUR, CUE_DUR+RWD_WIDTH, CUE_DUR+RWD_WIDTH];
    y_rect = [-2*LICK_TH, +2*LICK_TH, +2*LICK_TH, -2*LICK_TH];
    patch(x_rect, y_rect, 'g' , 'EdgeColor', 'none', 'FaceAlpha', 0.1);
    plot(t, lick, 'Color', [0,0.5,0], 'LineWidth', 1);
    xlim([min(t),max(t)]);
    ylim([-2*LICK_TH, 2*LICK_TH]);
    ylabel('Lick [V]');
    set(gca, 'YTick', [-2*LICK_TH,0,+2*LICK_TH]);
    
    % For Lick-timing
    lick_timing = trial.lick_timing;
    for h = 1:length(lick_timing)
        plot([lick_timing(h),lick_timing(h)],[-LICK_TH, +LICK_TH], 'k-', 'MarkerFaceColor','k', 'MarkerEdgeColor', 'none', 'LineWidth', 2);
    end
    
    % For Whisking
    whsk_filt = bandpass(whsk_c, [MIN_FREQ, MAX_FREQ], Fs);
    subplot(7,2,5:8);
    hold on;
    MIN_AMP = -10;
    MAX_AMP = 80;
    x_rect = [0, 0, CUE_DUR, CUE_DUR];
    y_rect = [MIN_AMP, MAX_AMP, MAX_AMP, MIN_AMP];
    patch(x_rect, y_rect, 'c' , 'EdgeColor', 'none', 'FaceAlpha', 0.1);
    x_rect = [CUE_DUR, CUE_DUR, CUE_DUR+RWD_WIDTH, CUE_DUR+RWD_WIDTH];
    y_rect = [MIN_AMP, MAX_AMP, MAX_AMP, MIN_AMP];
    patch(x_rect, y_rect, 'g' , 'EdgeColor', 'none', 'FaceAlpha', 0.1);
    plot(t, whsk_c, 'b-');
    hold off;
    xlim([min(t),max(t)]);
    ylim([MIN_AMP, MAX_AMP]);
    ylabel('Whisker [deg.]');

    % Compute whisker movement spectrogram
    [~, freq_spec, time_spec, whsk_pow] = spectrogram(whsk_filt, blackman(256), 256-5, 2^10, Fs, 'psd');
    
    % Show the original whisker movement spectrogram
    ax1 = subplot(7,2,9:14);
    mask_freq = (freq_spec <= MAX_FREQ+1e-6);
    whsk_pow_roi = whsk_pow(mask_freq,:);
    freq_spec_roi = freq_spec(mask_freq);
    time_spec = time_spec - 2;
    imagesc(time_spec, freq_spec_roi, whsk_pow_roi, [0,10]);
    colormap jet;
    colorbar;
    set(gca,'FontSize',14);
    axis xy;
    POS = get(gca,'Position');
    POS(1) = 0.144+0.055;
    POS(2) = 0.11-0.02;
    POS(3) = 0.746-0.11;
    set(gca,'Position',POS);
    xlabel('Time from cue onset [s]');
    ylabel('Frequency [Hz]');
    drawnow;
    if ~isempty(fig_dir)
       filename = sprintf('%s/trial%03d_spectrogram_revise', fig_dir, trial.trial_id);
       print('-painters', '-depsc', filename);
    end
    
    % For PSD during cue period
    whsk_cue = whsk_filt(cue_mask);
    cla(ax1);
    subplot(7,2,9:2:14);
    x_rect = [0, 0, MAX_FREQ, MAX_FREQ];
    y_rect = [0, 10, 10, 0];
    patch(x_rect, y_rect, 'c' , 'EdgeColor', 'none', 'FaceAlpha', 0.1);
    hold on;
    [psd_cue, freq_cue] = periodogram(whsk_cue, blackman(length(whsk_cue)), 256, Fs);
    mask_cue_freq = (freq_cue <= MAX_FREQ+5+1e-3);
    plot(freq_cue(mask_cue_freq) , psd_cue(mask_cue_freq),'k-');
    xlim([0,MAX_FREQ]);
    ylim([0,10]);
    set(gca, 'XTick', 0:5:MAX_FREQ);
    xlabel('Frequency [Hz]');
    ylabel('PSD [deg*deg/Hz]');
    title('Cue period');
    POS = get(gca,'Position');
    POS(2) = 0.11-0.04;
    set(gca,'Position',POS);
    hold off;
    % For PSD during reward window
    rwd_mask = (t > CUE_DUR) & (t <= CUE_DUR + RWD_WIDTH + 1e-8);
    whsk_rwd = whsk_filt(rwd_mask);
    subplot(7,2,10:2:14);
    x_rect = [0, 0, MAX_FREQ, MAX_FREQ];
    y_rect = [0, 10, 10, 0];
    patch(x_rect, y_rect, 'g' , 'EdgeColor', 'none', 'FaceAlpha', 0.1);
    hold on;
    [psd_rwd, freq_rwd] = periodogram(whsk_rwd, blackman(length(whsk_rwd)), 128, Fs);
    mask_rwd_freq = (freq_rwd <= MAX_FREQ+5+1e-3);
    plot(freq_rwd(mask_rwd_freq) , psd_rwd(mask_rwd_freq),'k-');
    xlim([0,MAX_FREQ]);
    ylim([0,10]);
    set(gca, 'XTick', 0:5:MAX_FREQ);
    xlabel('Frequency [Hz]');
    ylabel('PSD [deg*deg/Hz]');
    title('Reward window');
    POS = get(gca,'Position');
    POS(2) = 0.11-0.04;
    set(gca,'Position',POS);    
    hold off;
    drawnow;
    if ~isempty(fig_dir)
       filename = sprintf('%s/trial%03d_psd_revise', fig_dir, trial.trial_id);
       print('-painters', '-depsc', filename);
    end    
end
    
end
