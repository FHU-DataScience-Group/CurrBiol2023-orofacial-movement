function visualizeWhiskerSpectrogramForDay(data, options, fig_dir)
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
FIG_YSize = 720;

% データのサンプリング周期
Fs = options.Fs;

% Cue, Reward提示時の電圧（単位: V）
CUE_V = options.CUE_V;

% Lickセンサーの閾値（単位: V）
LICK_TH = options.LICK_TH;

% Cue提示時間（単位: 秒）
CUE_DUR = options.CUE_DUR;

% Reward Window幅（単位: 秒）
RWD_WIDTH = options.RWD_WIDTH;

% トライアル前最小待ち時間（単位: 秒）
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
    plot(t, lick, 'Color', [0,0.5,0], 'LineWidth', 1.5);
    xlim([min(t),max(t)]);
    ylim([-2*LICK_TH, 2*LICK_TH]);
    ylabel('Lick [V]');
    set(gca, 'YTick', [-2*LICK_TH,0,+2*LICK_TH]);
    %set(gca, 'YTickLabel',{'','',''});
    
    % For Lick-timing
    lick_timing = trial.lick_timing;
    for h = 1:length(lick_timing)
        plot(lick_timing(h),+LICK_TH, 'v', 'MarkerFaceColor','k', 'MarkerEdgeColor', 'none');
    end
    
    % For Whisking
    subplot(7,2,5:8);
    plot(t, whsk_c, 'b-');
    MIN_AMP = -10;
    MAX_AMP = 80;
    hold on;
    x_rect = [0, 0, CUE_DUR, CUE_DUR];
    y_rect = [MIN_AMP, MAX_AMP, MAX_AMP, MIN_AMP];
    patch(x_rect, y_rect, 'c' , 'EdgeColor', 'none', 'FaceAlpha', 0.1);
    x_rect = [CUE_DUR, CUE_DUR, CUE_DUR+RWD_WIDTH, CUE_DUR+RWD_WIDTH];
    y_rect = [MIN_AMP, MAX_AMP, MAX_AMP, MIN_AMP];
    patch(x_rect, y_rect, 'g' , 'EdgeColor', 'none', 'FaceAlpha', 0.1);
    hold off;
    xlim([min(t),max(t)]);
    ylim([MIN_AMP, MAX_AMP]);
    ylabel('Whisker [deg.]');

    % For Naive Whisking Spectrogram
    ax1 = subplot(7,2,9:14);
    % [~, freq_spec, time_spec, whsk_pow] = spectrogram(whsk_c, blackman(256),  256-5, 10*256, Fs, 'psd');
    % [~, freq_spec, time_spec, whsk_pow] = spectrogram(whsk_c, blackman(256),  256-5, 10*256, Fs, 'psd');
    [~, freq_spec, time_spec, whsk_pow] = spectrogram(whsk_c, blackman(256), 256-5, 2^10, Fs, 'psd');
    mask_freq = (freq_spec <= MAX_FREQ+1e-3);
    whsk_pow_roi = whsk_pow(mask_freq,:);
    freq_spec_roi = freq_spec(mask_freq);
    time_spec = time_spec - 2;
    imagesc(time_spec, freq_spec_roi, whsk_pow_roi, [0,100]);
    %imagesc(time_spec, freq_spec_roi, whsk_pow_roi);
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
       filename = sprintf('%s/trial%03d_spectrogram_org', fig_dir, trial.trial_id);
       print('-depsc', filename);
    end
    
    % For Relative Whisking Spectrogram
    cla(ax1);
    total_pow_roi = sum(whsk_pow_roi,1);
    whsk_rel_pow_roi = whsk_pow_roi./total_pow_roi;
    imagesc(time_spec, freq_spec_roi, whsk_rel_pow_roi, [0, 0.05]);
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
       filename = sprintf('%s/trial%03d_spectrogram_rel', fig_dir, trial.trial_id);
       print('-depsc', filename);
    end

    % For Cutoff Whisking Spectrogram
    cla(ax1);
    whsk_pow_roi_cutoff = whsk_pow_roi .* (0.5*tanh(2*(freq_spec_roi-3.5))+0.5);
    imagesc(time_spec, freq_spec_roi, whsk_pow_roi_cutoff, [0, 10]);
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
       filename = sprintf('%s/trial%03d_spectrogram_cutoff', fig_dir, trial.trial_id);
       print('-depsc', filename);
    end
    % For Cutoff Relative Whisking Spectrogram
    cla(ax1);
    total_pow_roi_cutoff = sum(whsk_pow_roi_cutoff,1);
    whsk_rel_pow_roi_cutoff = whsk_pow_roi_cutoff./total_pow_roi_cutoff;
    zero_mask = total_pow_roi_cutoff < 1e-8;
    whsk_rel_pow_roi_cutoff(:,zero_mask) = 0;
    whsk_rel_pow_roi_cutoff = whsk_rel_pow_roi_cutoff .* (0.5*tanh(total_pow_roi_cutoff-0.1)+0.5);
    imagesc(time_spec, freq_spec_roi, whsk_rel_pow_roi_cutoff, [0, 0.04]);
    colormap jet;
    colorbar('Ticks',0:0.01:0.04);
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
       filename = sprintf('%s/trial%03d_spectrogram_cutoff_rel', fig_dir, trial.trial_id);
       print('-depsc', filename);
    end
    
    % For PSD during cue period
    whsk_cue = whsk_c(cue_mask);
    cla(ax1);
    ax1 = subplot(7,2,9:2:14);
    x_rect = [0, 0, MAX_FREQ, MAX_FREQ];
    y_rect = [0, 10, 10, 0];
    patch(x_rect, y_rect, 'c' , 'EdgeColor', 'none', 'FaceAlpha', 0.1);
    hold on;
    [psd_cue, freq_cue] = periodogram(whsk_cue, blackman(length(whsk_cue)), 256, Fs);
    psd_cue_cutoff = psd_cue .* (0.5*tanh(2*(freq_cue-3.5))+0.5);
    mask_cue_freq = (freq_cue <= MAX_FREQ+5+1e-3);
    plot(freq_cue(mask_cue_freq) , psd_cue_cutoff(mask_cue_freq),'k-');
    xlim([0,MAX_FREQ]);
    ylim([0,10]);
    xlabel('Frequency [Hz]');
    ylabel('PSD [deg*deg/Hz]');
    title('Cue period');
    POS = get(gca,'Position');
    POS(2) = 0.11-0.04;
    set(gca,'Position',POS);
    hold off;
    % For PSD during reward window
    rwd_mask = (t > CUE_DUR) & (t <= CUE_DUR + RWD_WIDTH + 1e-8);
    whsk_rwd = whsk_c(rwd_mask);
    ax2 = subplot(7,2,10:2:14);
    x_rect = [0, 0, MAX_FREQ, MAX_FREQ];
    y_rect = [0, 10, 10, 0];
    patch(x_rect, y_rect, 'g' , 'EdgeColor', 'none', 'FaceAlpha', 0.1);
    hold on;
    [psd_rwd, freq_rwd] = periodogram(whsk_rwd, blackman(length(whsk_rwd)), 128, Fs);
    psd_rwd_cutoff = psd_rwd .* (0.5*tanh(2*(freq_rwd-3.5))+0.5);
    mask_rwd_freq = (freq_rwd <= MAX_FREQ+5+1e-3);
    plot(freq_rwd(mask_rwd_freq) , psd_rwd_cutoff(mask_rwd_freq),'k-');
    xlim([0,MAX_FREQ]);
    ylim([0,10]);
    xlabel('Frequency [Hz]');
    ylabel('PSD [deg*deg/Hz]');
    title('Reward window');
    POS = get(gca,'Position');
    POS(2) = 0.11-0.04;
    set(gca,'Position',POS);    
    hold off;
    drawnow;
    if ~isempty(fig_dir)
       filename = sprintf('%s/trial%03d_psd_org', fig_dir, trial.trial_id);
       print('-depsc', filename);
    end
    
    % For relative PSD during cue period
    cla(ax1);
    subplot(7,2,9:2:14);
    x_rect = [0, 0, MAX_FREQ, MAX_FREQ];
    y_rect = [0, 0.5, 0.5, 0];
    patch(x_rect, y_rect, 'c' , 'EdgeColor', 'none', 'FaceAlpha', 0.1);
    hold on;
    
    freq_cue_mask = freq_cue(mask_cue_freq);
    psd_cue_cutoff_mask = psd_cue_cutoff(mask_cue_freq);    
    total_psd_cue_cutoff_mask = sum(psd_cue_cutoff_mask);
    rel_psd_cue_cutoff_mask = psd_cue_cutoff_mask/total_psd_cue_cutoff_mask;
    rel_psd_cue_cutoff_mask(rel_psd_cue_cutoff_mask<1e-6) = 0;
    rel_psd_cue_cutoff_mask = rel_psd_cue_cutoff_mask .* (0.5*tanh(1*(total_psd_cue_cutoff_mask-0.1))+0.5);
    plot(freq_cue_mask , rel_psd_cue_cutoff_mask, 'k-');
    xlim([0,MAX_FREQ]);
    ylim([0,0.5]);
    xlabel('Frequency [Hz]');
    ylabel('relative PSD');
    title('Cue period');
    POS = get(gca,'Position');
    POS(2) = 0.11-0.04;
    set(gca,'Position',POS);
    hold off;
    % For relative PSD during cue period
    cla(ax2);
    subplot(7,2,10:2:14);
    x_rect = [0, 0, MAX_FREQ, MAX_FREQ];
    y_rect = [0, 0.5, 0.5, 0];
    patch(x_rect, y_rect, 'g' , 'EdgeColor', 'none', 'FaceAlpha', 0.1);
    hold on;
    
    freq_rwd_mask = freq_rwd(mask_rwd_freq);
    psd_rwd_cutoff_mask = psd_rwd_cutoff(mask_rwd_freq);    
    total_psd_rwd_cutoff_mask = sum(psd_rwd_cutoff_mask);
    rel_psd_rwd_cutoff_mask = psd_rwd_cutoff_mask/total_psd_rwd_cutoff_mask;
    rel_psd_rwd_cutoff_mask(rel_psd_rwd_cutoff_mask<1e-6) = 0;
    rel_psd_rwd_cutoff_mask = rel_psd_rwd_cutoff_mask .* (0.5*tanh(1*(total_psd_rwd_cutoff_mask-0.1))+0.5);
    plot(freq_rwd_mask , rel_psd_rwd_cutoff_mask, 'k-');
    xlim([0,MAX_FREQ]);
    ylim([0,0.5]);
    xlabel('Frequency [Hz]');
    ylabel('relative PSD');
    title('Reward window');
    POS = get(gca,'Position');
    POS(2) = 0.11-0.04;
    set(gca,'Position',POS);    
    hold off;
    drawnow;
    if ~isempty(fig_dir)
       filename = sprintf('%s/trial%03d_psd_rel', fig_dir, trial.trial_id);
       print('-depsc', filename);
    end
end
    
end

