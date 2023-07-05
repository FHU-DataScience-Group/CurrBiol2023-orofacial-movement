function visualizeModifiedWhiskerSpectrogramForDay02(data, options, fig_dir)
%visualizeWhiskerSpectrogramForDay -
%
% ToDo
%
% [書式]
%　　visualizeWhiskerSpectrogramForDay(data, options, fig_dir)
%
%
% [入力]
%　　data: ToDo
%
%　　options: ToDo
%
%
%=========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 各種定数の設定
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Figure Windowの幅
FIG_XSize = 560;

% Figure Windowの高さ
FIG_YSize = 100;

% データのサンプリング周期
Fs = options.Fs;

% Cue, Reward提示時の電圧（単位: V）
CUE_V = options.CUE_V;

% Lickセンサーの閾値（単位: V）
LICK_TH = options.LICK_TH;

% Toneの遅れ時間（単位: 秒）
TONE_DELAY_TIME = options.TONE_DELAY_TIME;


% Cue提示時間（単位: 秒）
CUE_DUR = options.CUE_DUR;

% Reward Window幅（単位: 秒）
RWD_WIDTH = options.RWD_WIDTH;

% トライアル前最小待ち時間（単位: 秒）
PRE_WAIT_DUR = options.PRE_WAIT_DUR;

% 最小ITI（単位: 秒）
MIN_ITI = options.MIN_ITI;

% Whisking解析の最小周波数 （単位: Hz）
MIN_FREQ = options.MIN_FREQ;

% Whisking解析の最大周波数 （単位: Hz）
MAX_FREQ = options.MAX_FREQ;

% Color Orderの取得
co = get(gca,'ColorOrder');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% フォルダ作成およびPDFレポートファイルの作成
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~isempty(fig_dir)
    % 出力先フォルダが存在しない場合は作成する
    if ~exist(fig_dir, 'dir')
        mkdir(fig_dir);
    end
    disp(fig_dir);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Figure Windowの生成とリサイズ
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h1 = figure(1);
POS = get(h1, 'Position');
POS(3:4) = [FIG_XSize, FIG_YSize];
set(h1, 'Position', POS);
clf;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 各トライアルのWhisker movement spectrogramを描画する
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
    % ITIのマスクを作成する
    iti_mask = t < 0;
    % ITI時のベースライン角度を計算する
    whsk_base = median(whsk(iti_mask));
    % Whiskingデータのベースライン補正
    whsk_c = whsk-whsk_base;
        
    clf(h1);
    POS(3:4) = [FIG_XSize, FIG_YSize];
    set(h1, 'Position', POS);
    % For cue and reward
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
    xlim([-PRE_WAIT_DUR/2, CUE_DUR+RWD_WIDTH+PRE_WAIT_DUR]);
    ylim([-0.05,1.05]);
    legend([plt2, plt1], cue_legend,'Reward');
    set(gca,'YTick',[0,1]);
    set(gca,'YTickLabel',{'OFF', 'ON'});
    title(sprintf('Trial = %d (%s)', trial.trial_id, ...
        outcome));
    if ~isempty(fig_dir)
       filename = sprintf('%s/trial%03d_spectrogram_cue', fig_dir, trial.trial_id);
       print('-painters','-depsc', filename);
    end    
    
    % For Licking
    clf(h1);
    hold on;
    x_rect = [0, 0, CUE_DUR, CUE_DUR];
    y_rect = [-2*LICK_TH, +2*LICK_TH, +2*LICK_TH, -2*LICK_TH];
    patch(x_rect, y_rect, 'c' , 'EdgeColor', 'none', 'FaceAlpha', 0.1);
    x_rect = [CUE_DUR, CUE_DUR, CUE_DUR+RWD_WIDTH, CUE_DUR+RWD_WIDTH];
    y_rect = [-2*LICK_TH, +2*LICK_TH, +2*LICK_TH, -2*LICK_TH];
    patch(x_rect, y_rect, 'g' , 'EdgeColor', 'none', 'FaceAlpha', 0.1);
    %plot(t, lick, 'Color', [0,0.5,0], 'LineWidth', 1);
    xlim([-PRE_WAIT_DUR/2, CUE_DUR+RWD_WIDTH+PRE_WAIT_DUR]);
    ylim([-2*LICK_TH, 2*LICK_TH]);
    ylabel('Licking');
    set(gca, 'YTick', [-2*LICK_TH,+2*LICK_TH]);
    set(gca, 'YTickLabel', {'',''});%[-2*LICK_TH,+2*LICK_TH]);
    
    % For Lick-timing
    lick_timing = trial.lick_timing;
    for h = 1:length(lick_timing)
        plot([lick_timing(h),lick_timing(h)],[-LICK_TH, +LICK_TH], 'k-', 'MarkerFaceColor','k', 'MarkerEdgeColor', 'none', 'LineWidth', 2);
    end
    if ~isempty(fig_dir)
       filename = sprintf('%s/trial%03d_spectrogram_lick', fig_dir, trial.trial_id);
       print('-painters','-depsc', filename);
    end    
    
    % For Whisking
    whsk_filt = bandpass(whsk_c, [MIN_FREQ, MAX_FREQ], Fs);
    clf(h1);
    POS(3:4) = [FIG_XSize, 2*FIG_YSize];
    set(h1, 'Position', POS);
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
    xlim([-PRE_WAIT_DUR/2, CUE_DUR+RWD_WIDTH+PRE_WAIT_DUR]);
    ylim([MIN_AMP, MAX_AMP]);
    ylabel('Whisker [deg.]');
    if ~isempty(fig_dir)
       filename = sprintf('%s/trial%03d_spectrogram_wm', fig_dir, trial.trial_id);
       print('-painters','-depsc', filename);
    end    

    % Compute whisker movement spectrogram
    [~, freq_spec, time_spec, whsk_pow] = spectrogram(whsk_filt, blackman(256), 256-5, 2^10, Fs, 'psd');
    
    % Show the original whisker movement spectrogram
    %ax1 = subplot(7,2,9:14);
    clf(h1);
    POS(3:4) = [FIG_XSize+55, 3*FIG_YSize];
    set(h1, 'Position', POS);
    time_spec = time_spec - PRE_WAIT_DUR;
    mask_time = (time_spec >= -1.01-1e-8) & (time_spec <= CUE_DUR + RWD_WIDTH + 2.0 +1e-8);
    time_spec_roi = time_spec(mask_time);
    mask_freq = (freq_spec <= MAX_FREQ+1e-6);
    whsk_pow_roi = whsk_pow(mask_freq, mask_time);
    freq_spec_roi = freq_spec(mask_freq);
    imagesc(time_spec_roi, freq_spec_roi, whsk_pow_roi, [0,10]);
    colormap jet;
    colorbar;
    set(gca,'FontSize',14);
    axis xy;
    %POS = get(gca,'Position');
    %POS(1) = 0.144+0.055;
    %POS(2) = 0.11-0.02;
    %POS(3) = 0.746-0.11;
    %set(gca,'Position',POS);
    xlabel('Time from cue onset [s]');
    ylabel('Frequency [Hz]');
    drawnow;
    if ~isempty(fig_dir)
       filename = sprintf('%s/trial%03d_spectrogram_wm_spec', fig_dir, trial.trial_id);
       print('-painters','-depsc', filename);
    end    
%     % For PSD during cue period
%     whsk_cue = whsk_filt(cue_mask);
%     cla(ax1);
%     subplot(7,2,9:2:14);
%     x_rect = [0, 0, MAX_FREQ, MAX_FREQ];
%     y_rect = [0, 10, 10, 0];
%     patch(x_rect, y_rect, 'c' , 'EdgeColor', 'none', 'FaceAlpha', 0.1);
%     hold on;
%     [psd_cue, freq_cue] = periodogram(whsk_cue, blackman(length(whsk_cue)), 256, Fs);
%     mask_cue_freq = (freq_cue <= MAX_FREQ+5+1e-3);
%     plot(freq_cue(mask_cue_freq) , psd_cue(mask_cue_freq),'k-');
%     xlim([0,MAX_FREQ]);
%     ylim([0,10]);
%     set(gca, 'XTick', 0:5:MAX_FREQ);
%     xlabel('Frequency [Hz]');
%     ylabel('PSD [deg*deg/Hz]');
%     title('Cue period');
%     POS = get(gca,'Position');
%     POS(2) = 0.11-0.04;
%     set(gca,'Position',POS);
%     hold off;
%     % For PSD during reward window
%     rwd_mask = (t > CUE_DUR) & (t <= CUE_DUR + RWD_WIDTH + 1e-8);
%     whsk_rwd = whsk_filt(rwd_mask);
%     subplot(7,2,10:2:14);
%     x_rect = [0, 0, MAX_FREQ, MAX_FREQ];
%     y_rect = [0, 10, 10, 0];
%     patch(x_rect, y_rect, 'g' , 'EdgeColor', 'none', 'FaceAlpha', 0.1);
%     hold on;
%     [psd_rwd, freq_rwd] = periodogram(whsk_rwd, blackman(length(whsk_rwd)), 128, Fs);
%     mask_rwd_freq = (freq_rwd <= MAX_FREQ+5+1e-3);
%     plot(freq_rwd(mask_rwd_freq) , psd_rwd(mask_rwd_freq),'k-');
%     xlim([0,MAX_FREQ]);
%     ylim([0,10]);
%     set(gca, 'XTick', 0:5:MAX_FREQ);
%     xlabel('Frequency [Hz]');
%     ylabel('PSD [deg*deg/Hz]');
%     title('Reward window');
%     POS = get(gca,'Position');
%     POS(2) = 0.11-0.04;
%     set(gca,'Position',POS);    
%     hold off;
%     drawnow;
%     if ~isempty(fig_dir)
%        filename = sprintf('%s/trial%03d_psd_revise', fig_dir, trial.trial_id);
%        print('-depsc', filename);
%     end    
% end
    
end

