function stat = analyzeRewardWindowSpecAverageForSubject(SubjectData, options, label)
%analyzeCuePeriodWMAverageForSubject - ToDo
%
% ToDo
%
% [����]
%�@�@analyzeCuePeriodGrandAverage(Dataset, options, label)
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
%% �萔�̐ݒ�
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% �ő�g���C�A�������擾
MaxTrials = 100000;

% Figure Window�̕�
FIG_XSize = 500;

% Figure Window�̍���
FIG_YSize = 300;

% ��Ԑ؂�o���̊ۂߌ덷�␳�i�P��: �b�j
T_COR = (1/options.Fs)*0.1;

% Cue�񎦑O�\����ԁi�P��: �b�j
PRE_CUE_WINDOW = options.PRE_CUE_WINDOW;

% Cue�񎦎��ԁi�P��: �b�j
CUE_DUR = options.CUE_DUR;

% Reward Window���i�P��: �b�j
RWD_WIDTH = options.RWD_WIDTH;

% Y���̍ő�l
Y_MAX = 0.25;

% Y���̍ŏ��l
Y_MIN = 0.0;

% Whisking��͂̍ŏ����g�� �i�P��: Hz�j
MIN_FREQ = options.MIN_FREQ;

% Whisking��͂̍ő���g�� �i�P��: Hz�j
MAX_FREQ = options.MAX_FREQ;

% �f�[�^�̃T���v�����O����
Fs = options.Fs;

% Color Order�̎擾
co = get(gca,'ColorOrder');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Figure Window�̐ݒ�
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h1 = figure(1);
POS = get(h1, 'Position');
POS(3:4) = [FIG_XSize, FIG_YSize];
set(h1, 'Position', POS);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Subject����Data���ɐ؂蕪����
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subject_id = SubjectData.subject_id;
exp_condition = SubjectData.exp_condition;
data = SubjectData.data;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �t�H���_�쐬�����PDF���|�[�g�t�@�C���̍쐬
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~isempty(options.FIG_DIR)
    save_to_dir = strcat(options.FIG_DIR, '/GrandAverageSpectrogram/', label, '/reward_window');
    if ~exist(save_to_dir, 'dir')
        mkdir(save_to_dir);
    end
else
    save_to_dir = [];
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ��͑ΏۂƂȂ鎞�Ԕ͈͂�ݒ肷��
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t = data{1}.trials{1}.values.Time;
rwd_mask = (t > CUE_DUR+T_COR) & (t <= CUE_DUR+RWD_WIDTH+T_COR);
pre_cue_mask = (t >= -(PRE_CUE_WINDOW+T_COR)) & (t <= 0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Hit �� CR �f�[�^�݂̂��W�v
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

idx_hit = 0;
wm_rwd_hit = nan(23, MaxTrials);
idx_cr = 0;
wm_rwd_cr = nan(23, MaxTrials);
idx_oh = 0;
wm_rwd_oh = nan(23, MaxTrials);

for d = 1:length(data)
    trials = data{d}.trials;
    for k = 1:length(trials)
        if strcmp(trials{k}.outcome, 'Hit')
            whisk = trials{k}.values.Whisker;
            wm_base = mean(whisk(pre_cue_mask));
            wm_c = whisk - wm_base;            
            wm_filt = bandpass(wm_c, [MIN_FREQ, MAX_FREQ], Fs);
            wm_rwd = wm_filt(rwd_mask) - wm_base;
            [psd_rwd, freq_rwd] = periodogram(wm_rwd, blackman(length(wm_rwd)), 512, Fs);
            freq_mask = (freq_rwd >= 3) & (freq_rwd <= 12);
            freq_rwd_roi = freq_rwd(freq_mask);
            psd_rwd_roi = psd_rwd(freq_mask);
            psd_rwd_norm_roi = psd_rwd_roi / sum(psd_rwd_roi);
            idx_hit = idx_hit + 1;
            wm_rwd_hit(:,idx_hit) = psd_rwd_norm_roi;
        elseif strcmp(trials{k}.outcome, 'CR')
            whisk = trials{k}.values.Whisker;
            wm_base = mean(whisk(pre_cue_mask));
            wm_c = whisk - wm_base;            
            wm_filt = bandpass(wm_c, [MIN_FREQ, MAX_FREQ], Fs);
            wm_rwd = wm_filt(rwd_mask) - wm_base;
            [psd_rwd, freq_rwd] = periodogram(wm_rwd, blackman(length(wm_rwd)), 512, Fs);
            freq_mask = (freq_rwd >= 3) & (freq_rwd <= 12);
            freq_rwd_roi = freq_rwd(freq_mask);
            psd_rwd_roi = psd_rwd(freq_mask);
            psd_rwd_norm_roi = psd_rwd_roi / sum(psd_rwd_roi);
            idx_cr = idx_cr + 1;
            wm_rwd_cr(:,idx_cr) = psd_rwd_norm_roi;
        elseif strcmp(trials{k}.outcome, 'Lick')
            whisk = trials{k}.values.Whisker;
            wm_base = mean(whisk(pre_cue_mask));
            wm_c = whisk - wm_base;            
            wm_filt = bandpass(wm_c, [MIN_FREQ, MAX_FREQ], Fs);
            wm_rwd = wm_filt(rwd_mask) - wm_base;
            [psd_rwd, freq_rwd] = periodogram(wm_rwd, blackman(length(wm_rwd)), 512, Fs);
            freq_mask = (freq_rwd >= 3) & (freq_rwd <= 12);
            freq_rwd_roi = freq_rwd(freq_mask);
            psd_rwd_roi = psd_rwd(freq_mask);
            psd_rwd_norm_roi = psd_rwd_roi / sum(psd_rwd_roi);
            idx_oh = idx_oh + 1;
            wm_rwd_oh(:,idx_oh) = psd_rwd_norm_roi;            
        end
    end
end
wm_rwd_hit(:,idx_hit+1:end) = [];
wm_rwd_cr(:,idx_cr+1:end) = [];
wm_rwd_oh(:,idx_oh+1:end) = [];

mean_wm_rwd_hit = mean(wm_rwd_hit,2);
sem_wm_rwd_hit = std(wm_rwd_hit,0,2)/sqrt(size(wm_rwd_hit,2));
mean_wm_rwd_cr = mean(wm_rwd_cr,2);
sem_wm_rwd_cr = std(wm_rwd_cr,0,2)/sqrt(size(wm_rwd_cr,2));
mean_wm_rwd_oh = nan;

clf;
hold on;

%area([0,CUE_DUR], [Y_MAX, Y_MAX], Y_MIN, 'FaceColor', 'c','FaceAlpha',0.1,'EdgeColor', 'none', 'LineStyle', 'none', 'ShowBaseLine', 'off');
%area([CUE_DUR, min([max(t_cue), CUE_DUR+10])], [Y_MAX, Y_MAX], Y_MIN, 'FaceColor', 'g','FaceAlpha',0.1,'EdgeColor', 'none', 'LineStyle', 'none', 'ShowBaseLine', 'off');

%ar1 = area(freq_cue_roi, [mean_wm_cue_hit-sem_wm_cue_hit, 2*sem_wm_cue_hit]);
%set(ar1(1),'FaceColor','None', 'LineStyle', 'none', 'ShowBaseLine', 'off')
%set(ar1(2),'FaceColor', co(1,:) ,'FaceAlpha',0.5,'EdgeColor', 'none', 'LineStyle', 'none', 'ShowBaseLine', 'off');
%plt1 = plot(freq_cue_roi, mean_wm_cue_hit, '-', 'Color', co(1,:));
errorbar(freq_rwd_roi, mean_wm_rwd_hit, sem_wm_rwd_hit, '-', 'Color', co(1,:));
plt1 = plot(freq_rwd_roi, mean_wm_rwd_hit, '-', 'Color', co(1,:));

%ar1 = area(t_cue, [mean_wm_cue_cr-sem_wm_cue_cr, 2*sem_wm_cue_cr]);
%set(ar1(1),'FaceColor','None', 'LineStyle', 'none', 'ShowBaseLine', 'off')
%set(ar1(2),'FaceColor', co(2,:) ,'FaceAlpha',0.5,'EdgeColor', 'none', 'LineStyle', 'none', 'ShowBaseLine', 'off');
errorbar(freq_rwd_roi, mean_wm_rwd_cr, sem_wm_rwd_cr , '-', 'Color', co(2,:));
plt2 = plot(freq_rwd_roi, mean_wm_rwd_cr, '-', 'Color', co(2,:));

xlim([min(freq_rwd_roi), max(freq_rwd_roi)]) % min(t_cue),max(t_cue)]);
ylim([Y_MIN, Y_MAX]);
xlabel('Frequency (Hz)');
ylabel('Relative PSD (A.U.)');
title(sprintf('%s: %s (%s)', label, subject_id, exp_condition),'FontSize', 16);
legend([plt1, plt2], 'Hit', 'CR', 'Location', 'northeastoutside');

if ~isempty(save_to_dir)
    filename = strcat(save_to_dir, '/', subject_id, '_', exp_condition, '_hit_cr');
    print('-depsc', filename);
end

if size(wm_rwd_oh,2) > 1
    mean_wm_rwd_oh = mean(wm_rwd_oh,2);
    sem_wm_cue_oh = std(wm_rwd_oh,0,2)/sqrt(size(wm_rwd_oh,2));
    %ar1 = area(t_cue, [mean_wm_cue_oh-sem_wm_cue_oh, 2*sem_wm_cue_oh]);
    %set(ar1(1),'FaceColor','None', 'LineStyle', 'none', 'ShowBaseLine', 'off')
    %set(ar1(2),'FaceColor', co(3,:) ,'FaceAlpha',0.5,'EdgeColor', 'none', 'LineStyle', 'none', 'ShowBaseLine', 'off');
    errorbar(freq_rwd_roi, mean_wm_rwd_oh, sem_wm_cue_oh, '-', 'Color', co(3,:));
    plt3 = plot(freq_rwd_roi, mean_wm_rwd_oh, '-', 'Color', co(3,:));
    legend([plt1, plt2, plt3], 'Hit', 'CR', 'OH', 'Location', 'northeastoutside');
    if ~isempty(save_to_dir)
        filename = strcat(save_to_dir, '/', subject_id, '_', exp_condition, '_hit_cr_oh');
        print('-depsc', filename);
    end
end

stat.freq_rwd_roi = freq_rwd_roi;
stat.mean_wm_rwd_hit = mean_wm_rwd_hit;
stat.mean_wm_rwd_cr = mean_wm_rwd_cr;
stat.mean_wm_rwd_oh = mean_wm_rwd_oh;

end

