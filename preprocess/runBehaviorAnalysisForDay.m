function data = runBehaviorAnalysisForDay(data, options, fig_dir)
%runBehaviorAnalysisForDay この関数の概要をここに記述
%   詳細説明をここに記述

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 定数の設定
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Figure Windowの幅
FIG_XSize = 560;

% Figure Windowの高さ
FIG_YSize = 350;

% Color Orderの取得
co = get(gca,'ColorOrder');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 行動解析用パラメータの取得
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 移動平均による課題成功率計算時の窓幅（単位: トライアル）
RATE_WINDOW_PRE = options.RATE_WINDOW_PRE;
RATE_WINDOW_POST = options.RATE_WINDOW_POST;

% 解析対象区間のHit Rateの閾値
HIT_RATE_TH = options.HIT_RATE_TH;

% 解析対象区間のFalse Alart Rate閾値
FA_RATE_TH = options.FA_RATE_TH;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 出力先フォルダの作成
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~isempty(fig_dir)
    if ~exist(fig_dir, 'dir')
        mkdir(fig_dir);
    end
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 各トライアルの行動結果の集計
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 全トライアル数を取得
NumTrials = length(data.trials);

go_hit = nan(1,NumTrials);
nogo_fa = nan(1,NumTrials);
outcome_idx = nan(1,NumTrials);
rslt_mat = zeros(3,4);
for k = 1:NumTrials
    trial = data.trials{k};
    cue = trial.cue;
    outcome = trial.outcome;
    if strcmp(cue, 'Go')
        if strcmp(outcome, 'Hit')
            go_hit(k) = 1;
            outcome_idx(k) = 1;
            rslt_mat(1,1) = rslt_mat(1,1) + 1;
        elseif strcmp(outcome, 'Miss')
            go_hit(k) = 0;
            outcome_idx(k) = 2;
            rslt_mat(1,2) = rslt_mat(1,2) + 1;
        elseif strcmp(outcome, 'Error')
            outcome_idx(k) = 0;
            rslt_mat(1,3) = rslt_mat(1,3) + 1;
        end
    elseif strcmp(cue, 'No Go')
        if strcmp(outcome, 'CR')
            nogo_fa(k) = 0;
            outcome_idx(k) = 4;
            rslt_mat(2,2) = rslt_mat(2,2) + 1;
        elseif strcmp(outcome, 'FA')
            nogo_fa(k) = 1;
            outcome_idx(k) = 3;
            rslt_mat(2,1) = rslt_mat(2,1) + 1;
        elseif strcmp(outcome, 'Error')
            outcome_idx(k) = 0;
            rslt_mat(2,3) = rslt_mat(2,3) + 1;
        end        
    elseif strcmp(cue, 'Omission')
        if strcmp(outcome, 'Lick')
            go_hit(k) = 1;
            outcome_idx(k) = 5;
            rslt_mat(3,1) = rslt_mat(3,1) + 1;            
        elseif strcmp(outcome, 'No Lick')
            go_hit(k) = 0;
            outcome_idx(k) = 6;
            rslt_mat(3,2) = rslt_mat(3,2) + 1;
        elseif strcmp(outcome, 'Error')
            outcome_idx(k) = 0;
            rslt_mat(3,3) = rslt_mat(3,3) + 1;
        end        
    end
    if strcmp(outcome, 'Teaching')
        outcome_idx(k) = -1;        
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 行動結果の集計
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% トライアル種類の出現頻度と課題成功率を計算
rslt_mat(:,4) = rslt_mat(:,1)./(rslt_mat(:,1)+rslt_mat(:,2));
result_summary = array2table(rslt_mat, ...
    'VariableNames', {'Lick', 'No_Lick', 'Error', 'Lick_Rate'}, ...
    'RowNames', {'Go', 'No_Go', 'Omit'});

% 結果をファイルに保存
if ~isempty(fig_dir)
    filename = strcat(fig_dir, '/result_summary.csv');
    writetable(result_summary,filename, 'WriteRowNames', true)
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 課題成功率移動平均の計算
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hit_rate = nan(1,NumTrials);
fa_rate = nan(1,NumTrials);
for k = 1:NumTrials
    % 各トライアルのHit Rateの計算
    go_hit_pre = go_hit(1:k-1);
    valid_pre_idx = find(~isnan(go_hit_pre),RATE_WINDOW_PRE,'last');
    go_hit_post = go_hit(k:end);
    valid_post_idx = find(~isnan(go_hit_post),RATE_WINDOW_POST,'first');
    hit_rate(k) = mean([go_hit_pre(valid_pre_idx),go_hit_post(valid_post_idx)]);
    % 各トライアルのFA Rateの計算
    nogo_fa_pre = nogo_fa(1:k-1);
    valid_pre_idx = find(~isnan(nogo_fa_pre),RATE_WINDOW_PRE,'last');
    nogo_fa_post = nogo_fa(k:end);
    valid_post_idx = find(~isnan(nogo_fa_post),RATE_WINDOW_POST,'first');
    fa_rate(k) = mean([nogo_fa_pre(valid_pre_idx),nogo_fa_post(valid_post_idx)]);   
end

suc_mask = (hit_rate >= HIT_RATE_TH) & (fa_rate <= FA_RATE_TH);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 行動結果の系列表示
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% キャンバスを消去
clf(h1);
% サブプロットキャンバスの作成
subplot(2,1,1);
% 解析対象区間の表示
bar(1:NumTrials,suc_mask,1,'EdgeColor','none', 'FaceColor','m', 'FaceAlpha', 0.1);
hold on;
% Go-Hit trialの表示
plot_idx = find(outcome_idx == 1);
plot([plot_idx; plot_idx], [0.9-0.1*ones(size(plot_idx)); 0.9+0.1*ones(size(plot_idx))], 'color', co(1,:), 'LineWidth', 1);
% Go-Miss trialの表示
plot_idx = find(outcome_idx == 2);
plot([plot_idx; plot_idx], [0.9-0.05*ones(size(plot_idx)); 0.9+0.05*ones(size(plot_idx))], 'color', co(1,:), 'LineWidth', 1);

% NoGo-FA trialの表示
plot_idx = find(outcome_idx == 3);
plot([plot_idx; plot_idx], [0.1-0.1*ones(size(plot_idx)); 0.1+0.1*ones(size(plot_idx))], 'color', co(2,:), 'LineWidth', 1);

% NoGo-CR trialの表示
plot_idx = find(outcome_idx == 4);
plot([plot_idx; plot_idx], [0.1-0.05*ones(size(plot_idx)); 0.1+0.05*ones(size(plot_idx))], 'color', co(2,:), 'LineWidth', 1);

% Omission-Lick trialの表示
plot_idx = find(outcome_idx == 5);
plot([plot_idx; plot_idx], [0.9-0.1*ones(size(plot_idx)); 0.9+0.1*ones(size(plot_idx))], 'color', co(3,:), 'LineWidth', 1);

% Omission-No Lick trialの表示
plot_idx = find(outcome_idx == 6);
plot([plot_idx; plot_idx], [0.9-0.05*ones(size(plot_idx)); 0.9+0.05*ones(size(plot_idx))], 'color', co(3,:), 'LineWidth', 1);

% Error trialの表示
plot_idx = find(outcome_idx == 0);
plot([plot_idx; plot_idx], [0.5-0.05*ones(size(plot_idx)); 0.5+0.05*ones(size(plot_idx))], 'color', [0.5, 0.5, 0.5], 'LineWidth', 1);

% Teaching trialの表示
plot_idx = find(outcome_idx == -1);
plot([plot_idx; plot_idx], [0.5-0.05*ones(size(plot_idx)); 0.5+0.05*ones(size(plot_idx))], 'color', [0.25, 0.25, 0.25], 'LineWidth', 1);


% 軸の調整
xlim([0.5,NumTrials+0.5]);
ylim([0.0,+1.0]);
set(gca,'YTick',[0.1,0.5,0.9]);
set(gca,'YTickLabel',{'No Go','Error','Go'});
xlabel('Trials');
ylabel('Cue');
title('Behavioral result ');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 課題成功率の時間変化の表示
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% サブプロットキャンバスの作成
subplot(2,1,2);
% 解析対象区間の表示
bar(1:NumTrials,suc_mask,1,'EdgeColor','none', 'FaceColor','m', 'FaceAlpha', 0.1);
hold on;
% Hit Rateの表示
plt1 = plot(1:NumTrials, hit_rate, 'color', co(1,:));
% FA Rateの表示
plt2 = plot(1:NumTrials, fa_rate, 'color', co(2,:));
% Hit Rate閾値の表示
plot([0;NumTrials+1], [0.8;0.8], 'k:');
% FA Rate閾値の表示
plot([0;NumTrials+1], [0.2;0.2], 'k:');

% 軸の調整
ylim([0.0,1.0]);
set(gca,'YTick',[0,0.5,1]);
ylabel('Rate');

xlim([0.5,NumTrials+0.5]);
xlabel('Trials');
title('Time course of Hit & FA rates');
legend([plt1,plt2],{'Hit Rate','FA Rate'},'Location','east');

% 図の保存
if ~isempty(fig_dir)
    filename = strcat(fig_dir, '/trial_by_trial');
    print('-dpdf', filename);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 解析結果の保存
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data.result_summary = result_summary;
data.suc_mask = suc_mask;
data.hit_rate = hit_rate;
data.fa_rate = fa_rate;

end

