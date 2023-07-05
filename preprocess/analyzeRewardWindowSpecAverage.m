function analyzeRewardWindowSpecAverage(Dataset, options, label)
%analyzeCuePeriodGrandAverage - ToDo
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

% 実験マウス数を取得
MaxN = length(Dataset);

% Figure Windowの幅
FIG_XSize = 500;

% Figure Windowの高さ
FIG_YSize = 300;

% Figure Windowの幅
FIG2_XSize = 400;

% Figure Windowの高さ
FIG2_YSize = 500;

% CUE提示前区間の設定（単位: 秒）
PRE_CUE = 1.0;

% CUE提示後区間の設定（単位: 秒）
POST_CUE = 0.1;

% Cue提示時間（単位: 秒）
CUE_DUR = options.CUE_DUR;

% Y軸の最大値
Y_MAX = 0.25;

% Y軸の最小値
Y_MIN = 0.0;

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
%% フォルダ作成
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
%%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subject_id = cell(1,MaxN);
stat = cell(1,MaxN);
for n = 1:MaxN
    if strcmp(Dataset{n}.exp_condition, 'Normal')
        subject_id{n} = strcat(Dataset{n}.subject_id, '_Norm');
    elseif strcmp(Dataset{n}.exp_condition, 'Reversal')
        subject_id{n} = strcat(Dataset{n}.subject_id, '_Rev');
    end
    stat{n} = analyzeRewardWindowSpecAverageForSubject(Dataset{n}, options, label);
end

freq_rwd_roi = stat{1}.freq_rwd_roi;
wm_hit = nan(length(freq_rwd_roi), MaxN);
wm_cr = nan(length(freq_rwd_roi), MaxN);
wm_oh = nan(length(freq_rwd_roi), MaxN);

for n = 1:MaxN
    wm_hit(:,n) = stat{n}.mean_wm_rwd_hit;
    wm_cr(:,n) = stat{n}.mean_wm_rwd_cr;
    if ~isnan(stat{n}.mean_wm_rwd_oh)
        wm_oh(:,n) = stat{n}.mean_wm_rwd_oh;
    end
end

mean_wm_hit = mean(wm_hit,2);
sem_wm_hit = std(wm_hit,0,2)/sqrt(size(wm_hit,2));
mean_wm_cr = mean(wm_cr,2);
sem_wm_cr = std(wm_cr,0,2)/sqrt(size(wm_cr,2));
mean_wm_oh = nanmean(wm_oh,2);
if sum(~isnan(sum(wm_oh,1))) > 0
    sem_wm_oh = nanstd(wm_oh,0,2)/sqrt(sum(~isnan(sum(wm_oh,1))));
else
    sem_wm_oh = nan;
end

clf;
hold on;

%area([0, CUE_DUR], [Y_MAX, Y_MAX], Y_MIN, 'FaceColor', 'c','FaceAlpha',0.1,'EdgeColor', 'none', 'LineStyle', 'none', 'ShowBaseLine', 'off');
%area([CUE_DUR, min([max(freq_cue_roi), CUE_DUR+10])], [Y_MAX, Y_MAX], Y_MIN, 'FaceColor', 'g','FaceAlpha',0.1,'EdgeColor', 'none', 'LineStyle', 'none', 'ShowBaseLine', 'off');

%ar1 = area(freq_cue_roi, [mean_wm_hit-sem_wm_hit, 2*sem_wm_hit]);
%set(ar1(1),'FaceColor','None', 'LineStyle', 'none', 'ShowBaseLine', 'off')
%set(ar1(2),'FaceColor', co(1,:) ,'FaceAlpha',0.5,'EdgeColor', 'none', 'LineStyle', 'none', 'ShowBaseLine', 'off');
errorbar(freq_rwd_roi, mean_wm_hit, sem_wm_hit, '-', 'Color', co(1,:));
plt1 = plot(freq_rwd_roi, mean_wm_hit, '-', 'Color', co(1,:));

%ar1 = area(freq_cue_roi, [mean_wm_cr-sem_wm_cr, 2*sem_wm_cr]);
%set(ar1(1),'FaceColor','None', 'LineStyle', 'none', 'ShowBaseLine', 'off')
%set(ar1(2),'FaceColor', co(2,:) ,'FaceAlpha',0.5,'EdgeColor', 'none', 'LineStyle', 'none', 'ShowBaseLine', 'off');
errorbar(freq_rwd_roi, mean_wm_cr, sem_wm_cr, '-', 'Color', co(2,:));
plt2 = plot(freq_rwd_roi, mean_wm_cr, '-', 'Color', co(2,:));
xlim([min(freq_rwd_roi),max(freq_rwd_roi)]);
ylim([Y_MIN, Y_MAX]);
xlabel('Time from cue onset (s)');
ylabel('Whisker angle (degree)');
title(sprintf('%s', label),'FontSize', 16);
legend([plt1, plt2], 'Hit', 'CR', 'Location', 'northeastoutside');

if ~isempty(save_to_dir)
    filename = strcat(save_to_dir, '/all_hit_cr');
    print('-depsc', filename);
end

if sum(~isnan(sum(wm_oh,1))) > 0
    %ar1 = area(freq_cue_roi, [mean_wm_oh-sem_wm_oh, 2*sem_wm_oh]);
    %set(ar1(1),'FaceColor','None', 'LineStyle', 'none', 'ShowBaseLine', 'off')
    %set(ar1(2),'FaceColor', co(3,:) ,'FaceAlpha',0.5,'EdgeColor', 'none', 'LineStyle', 'none', 'ShowBaseLine', 'off');
    errorbar(freq_rwd_roi, mean_wm_oh, sem_wm_oh, '-', 'Color', co(3,:));
    plt3 = plot(freq_rwd_roi, mean_wm_oh, '-', 'Color', co(3,:));
    legend([plt1, plt2, plt3], 'Hit', 'CR', 'OH', 'Location', 'northeastoutside');
    if ~isempty(save_to_dir)
        filename = strcat(save_to_dir, '/', 'all_hit_cr_oh');
        print('-depsc', filename);
    end
end
hold off;

end

