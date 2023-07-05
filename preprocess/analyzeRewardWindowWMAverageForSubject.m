function stat = analyzeCuePeriodWMAverageForSubject(SubjectData, options, label)
%analyzeCuePeriodWMAverageForSubject - ToDo
%
% ToDo
%
% [書式]
%　　analyzeCuePeriodGrandAverage(Dataset, options, label)
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
%% 定数の設定
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 最大トライアル数を取得
MaxTrials = 100000;

% Figure Windowの幅
FIG_XSize = 500;

% Figure Windowの高さ
FIG_YSize = 300;

% 区間切り出しの丸め誤差補正（単位: 秒）
T_COR = (1/options.Fs)*0.1;

% Cue提示前表示区間（単位: 秒）
PRE_CUE_WINDOW = options.PRE_CUE_WINDOW;

% Cue提示後表示区間（単位: 秒）
POST_CUE_WINDOW = options.POST_CUE_WINDOW;

% Cue提示時間（単位: 秒）
CUE_DUR = options.CUE_DUR;

% Reward Window幅（単位: 秒）
RWD_WIDTH = options.RWD_WIDTH;

PRE_RWD_TIME = 0.5;

% Y軸の最大値
Y_MAX = 40.0;

% Y軸の最小値
Y_MIN = -10.0;

% Color Orderの取得
co = get(gca,'ColorOrder');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Figure Windowの設定
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h1 = figure(1);
POS = get(h1, 'Position');
POS(3:4) = [FIG_XSize, FIG_YSize];
set(h1, 'Position', POS);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Subject情報とData情報に切り分ける
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subject_id = SubjectData.subject_id;
exp_condition = SubjectData.exp_condition;
data = SubjectData.data;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% フォルダ作成およびPDFレポートファイルの作成
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~isempty(options.FIG_DIR)
    save_to_dir = strcat(options.FIG_DIR, '/GrandAverage/', label, '/reward_window');
    if ~exist(save_to_dir, 'dir')
        mkdir(save_to_dir);
    end
else
    save_to_dir = [];
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 解析対象となる時間範囲を設定する
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t = data{1}.trials{1}.values.Time;
rw_mask = (t >= CUE_DUR-PRE_RWD_TIME-T_COR);
pre_rw_mask = rw_mask & (t <= CUE_DUR+T_COR);
t_rw = t(rw_mask) - CUE_DUR;
rw_t_size = length(t_rw);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Hit と CR データのみを集計
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

idx_hit = 0;
wm_rw_hit = nan(rw_t_size, MaxTrials);
idx_cr = 0;
wm_rw_cr = nan(rw_t_size, MaxTrials);
idx_oh = 0;
wm_rw_oh = nan(rw_t_size, MaxTrials);

for d = 1:length(data)
    trials = data{d}.trials;
    for k = 1:length(trials)
        if strcmp(trials{k}.outcome, 'Hit')
            whisk = trials{k}.values.Whisker;
            wm_base = mean(whisk(pre_rw_mask));
            wm_cue = whisk(rw_mask) - wm_base;
            idx_hit = idx_hit + 1;
            wm_rw_hit(:,idx_hit) = wm_cue;
        elseif strcmp(trials{k}.outcome, 'CR')
            whisk = trials{k}.values.Whisker;
            wm_base = mean(whisk(pre_rw_mask));
            wm_cue = whisk(rw_mask) - wm_base;
            idx_cr = idx_cr + 1;
            wm_rw_cr(:,idx_cr) = wm_cue;
        elseif strcmp(trials{k}.outcome, 'Lick')
            whisk = trials{k}.values.Whisker;
            wm_base = mean(whisk(pre_rw_mask));
            wm_cue = whisk(rw_mask) - wm_base;
            idx_oh = idx_oh + 1;
            wm_rw_oh(:,idx_oh) = wm_cue;            
        end
    end
end
wm_rw_hit(:,idx_hit+1:end) = [];
wm_rw_cr(:,idx_cr+1:end) = [];
wm_rw_oh(:,idx_oh+1:end) = [];

mean_wm_rw_hit = mean(wm_rw_hit,2);
sem_wm_rw_hit = std(wm_rw_hit,0,2)/sqrt(size(wm_rw_hit,2));
mean_wm_rw_cr = mean(wm_rw_cr,2);
sem_wm_rw_cr = std(wm_rw_cr,0,2)/sqrt(size(wm_rw_cr,2));
mean_wm_rw_oh = nan;

clf;
hold on;

area([-CUE_DUR,0], [Y_MAX, Y_MAX], Y_MIN, 'FaceColor', 'c','FaceAlpha',0.1,'EdgeColor', 'none', 'LineStyle', 'none', 'ShowBaseLine', 'off');
area([0, min([max(t_rw), RWD_WIDTH])], [Y_MAX, Y_MAX], Y_MIN, 'FaceColor', 'g','FaceAlpha',0.1,'EdgeColor', 'none', 'LineStyle', 'none', 'ShowBaseLine', 'off');

ar1 = area(t_rw, [mean_wm_rw_hit-sem_wm_rw_hit, 2*sem_wm_rw_hit]);
set(ar1(1),'FaceColor','None', 'LineStyle', 'none', 'ShowBaseLine', 'off')
set(ar1(2),'FaceColor', co(1,:) ,'FaceAlpha',0.5,'EdgeColor', 'none', 'LineStyle', 'none', 'ShowBaseLine', 'off');
plt1 = plot(t_rw, mean_wm_rw_hit, '-', 'Color', co(1,:));

ar1 = area(t_rw, [mean_wm_rw_cr-sem_wm_rw_cr, 2*sem_wm_rw_cr]);
set(ar1(1),'FaceColor','None', 'LineStyle', 'none', 'ShowBaseLine', 'off')
set(ar1(2),'FaceColor', co(2,:) ,'FaceAlpha',0.5,'EdgeColor', 'none', 'LineStyle', 'none', 'ShowBaseLine', 'off');
plt2 = plot(t_rw, mean_wm_rw_cr, '-', 'Color', co(2,:));

xlim([min(t_rw),max(t_rw)]);
ylim([Y_MIN, Y_MAX]);
xlabel('Time from reward window onset (s)');
ylabel('Whisker angle (degree)');
title(sprintf('%s: %s (%s)', label, subject_id, exp_condition),'FontSize', 16);
legend([plt1, plt2], 'Hit', 'CR', 'Location', 'northeastoutside');

if ~isempty(save_to_dir)
    filename = strcat(save_to_dir, '/', subject_id, '_', exp_condition, '_hit_cr');
    print('-painters', '-depsc', filename);
    print('-dpdf', filename);
end

if size(wm_rw_oh,2) > 1
    mean_wm_rw_oh = mean(wm_rw_oh,2);
    sem_wm_cue_oh = std(wm_rw_oh,0,2)/sqrt(size(wm_rw_oh,2));
    ar1 = area(t_rw, [mean_wm_rw_oh-sem_wm_cue_oh, 2*sem_wm_cue_oh]);
    set(ar1(1),'FaceColor','None', 'LineStyle', 'none', 'ShowBaseLine', 'off')
    set(ar1(2),'FaceColor', co(3,:) ,'FaceAlpha',0.5,'EdgeColor', 'none', 'LineStyle', 'none', 'ShowBaseLine', 'off');
    plt3 = plot(t_rw, mean_wm_rw_oh, '-', 'Color', co(3,:));
    legend([plt1, plt2, plt3], 'Hit', 'CR', 'OH', 'Location', 'northeastoutside');
    if ~isempty(save_to_dir)
        filename = strcat(save_to_dir, '/', subject_id, '_', exp_condition, '_hit_cr_oh');
        print('-painters', '-depsc', filename);
        print('-dpdf', filename);
    end
end

stat.t_rw = t_rw;
stat.mean_wm_rw_hit = mean_wm_rw_hit;
stat.mean_wm_rw_cr = mean_wm_rw_cr;
stat.mean_wm_rw_oh = mean_wm_rw_oh;

end

