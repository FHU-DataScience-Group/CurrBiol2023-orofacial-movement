function stat = analyzeRewardWindowProtractionForSubject(SubjectData, options, label)
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

% Reward Windowベースライン測定区間（単位: 秒）
PRE_RWD_WINDOW = 0.5;

% Cue提示時間（単位: 秒）
CUE_DUR = options.CUE_DUR;

% Reward Window幅（単位: 秒）
RWD_WIDTH = options.RWD_WIDTH;

% Y軸の最大値
Y_MAX = 20.0;

% Y軸の最小値
Y_MIN = -5.0;

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
    save_to_dir = strcat(options.FIG_DIR, '/Setpoint/', label, '/reward_window');
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

idx_hit = 0;
prot_rw_hit = nan(MaxTrials, 5);
idx_oh = 0;
prot_rw_oh = nan(MaxTrials, 5);

for d = 1:length(data)
    trials = data{d}.trials;
    for k = 1:length(trials)
        outcome = trials{k}.outcome;
        if strcmp(outcome, 'Hit')
            t = trials{k}.values.Time;
            whisk = trials{k}.values.Whisker;
            baseline_mask = (t >= CUE_DUR - (PRE_RWD_WINDOW + T_COR)) & (t < CUE_DUR - T_COR);
            whisk_baseline = median(whisk(baseline_mask));
            whisk_c = whisk - whisk_baseline;
            rwd_mask = (t >= CUE_DUR + T_COR) & (t <= CUE_DUR +RWD_WIDTH + T_COR);
            whisk_rwd = whisk_c(rwd_mask);
            whisk_rwd_seg = reshape(whisk_rwd, [length(whisk_rwd)/5,5]);
            idx_hit = idx_hit + 1;
            prot_rw_hit(idx_hit,:) = median(whisk_rwd_seg,1);
        elseif strcmp(outcome, 'Lick')
            t = trials{k}.values.Time;
            whisk = trials{k}.values.Whisker;
            baseline_mask = (t >= CUE_DUR - (PRE_RWD_WINDOW + T_COR)) & (t < CUE_DUR - T_COR);
            whisk_baseline = median(whisk(baseline_mask));
            whisk_c = whisk - whisk_baseline;
            rwd_mask = (t >= CUE_DUR + T_COR) & (t <= CUE_DUR +RWD_WIDTH + T_COR);
            whisk_rwd = whisk_c(rwd_mask);
            whisk_rwd_seg = reshape(whisk_rwd, [length(whisk_rwd)/5,5]);
            idx_oh = idx_oh + 1;
            prot_rw_oh(idx_oh,:) = median(whisk_rwd_seg,1);
        end
    end
end

prot_rw_hit(idx_hit+1:end,:) = [];
prot_rw_oh(idx_oh+1:end,:) = [];

figure(h1);
clf(h1);
mean_prot_rw_hit = [0, mean(prot_rw_hit,1)];
sem_prot_rw_hit = [0, std(prot_rw_hit,0,1)/sqrt(size(prot_rw_hit,1))];

if idx_oh >= 1
    mean_prot_rw_oh = [0, mean(prot_rw_oh,1)];
    sem_prot_rw_oh = [0, std(prot_rw_oh,0,1)/sqrt(size(prot_rw_oh,1))];
else
    mean_prot_rw_oh = [0, mean(prot_rw_oh,1)];
    sem_prot_rw_oh = nan(size(mean_prot_rw_oh));
end

plt1 = errorbar(0:0.2:1, mean_prot_rw_hit, sem_prot_rw_hit, '-', 'Color', co(1,:), 'LineWidth', 2);
hold on;
plt2 = errorbar(0:0.2:1, mean_prot_rw_oh, sem_prot_rw_oh, '-', 'Color', co(3,:), 'LineWidth', 2);
legend([plt1, plt2], {'Hit', 'OH'}, 'Location', 'northeastoutside');
xlabel('Time from reward window onset (s)');
ylabel('Change in set-point (degree)');
xlim([0,1.1]);
ylim([Y_MIN, Y_MAX]);
pval = nan(1,5);
for d = 1:5
    [~,pval(d)] = ttest2(prot_rw_hit(:,d),prot_rw_oh(:,d));
    if pval(d) < 1e-3
        text(0.2*d,18, '***', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
    elseif pval(d) < 1e-2
        text(0.2*d,18, '**', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
    elseif pval(d) < 5e-2
        text(0.2*d,18, '*', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
    else
        text(0.2*d,18, 'N.S.', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
    end
end


if ~isempty(save_to_dir)
    filename = strcat(save_to_dir, '/', subject_id, '_', exp_condition, '_hit_oh');
    print('-painters', '-depsc', filename);
    print('-dpdf', filename);
end

stat.t_rwd = 0:0.2:1;
stat.mean_prot_rw_hit = mean_prot_rw_hit;
stat.mean_prot_rw_oh = mean_prot_rw_oh;

end

