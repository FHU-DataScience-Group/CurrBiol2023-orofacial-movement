function analyzeRewardWindowProtraction(Dataset, options, label)
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



% 実験マウス数を取得
MaxN = length(Dataset);

% Figure Windowの幅
FIG_XSize = 500;

% Figure Windowの高さ
FIG_YSize = 300;


% Y軸の最大値
Y_MAX = 12.0;

% Y軸の最小値
Y_MIN = -2.0;

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
    save_to_dir = strcat(options.FIG_DIR, '/Setpoint/', label, '/reward_window');
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
    stat{n} = analyzeRewardWindowProtractionForSubject(Dataset{n}, options, label);
end

t = stat{1}.t_rwd;
prot_hit = nan(MaxN, length(t));
prot_oh = nan(MaxN, length(t));
for n = 1:MaxN
    prot_hit(n,:) = stat{n}.mean_prot_rw_hit;
    prot_oh(n,:) = stat{n}.mean_prot_rw_oh;
end

mean_wm_hit = mean(prot_hit,1);
sem_wm_hit = std(prot_hit,0,1)./sqrt(sum(~isnan(prot_hit),1));
mean_wm_oh = nanmean(prot_oh,1);
sem_wm_oh = nanstd(prot_oh,0,1)./sqrt(sum(~isnan(prot_oh),1));

clf;
hold on;
plt1 = errorbar(t, mean_wm_hit, sem_wm_hit, '-', 'Color', co(1,:), 'LineWidth', 2);
hold on;
plt2 = errorbar(t, mean_wm_oh, sem_wm_oh, '-', 'Color', co(3,:), 'LineWidth', 2);
legend([plt1, plt2], {'Hit', 'OH'}, 'Location', 'northeastoutside');
xlabel('Time from reward window onset (s)');
ylabel('Change in set-point (degree)');
xlim([0,1.1]);
ylim([Y_MIN, Y_MAX]);

pval = nan(1,5);
for d = 1:5
    [~,pval(d)] = ttest(prot_hit(:,d+1)-prot_oh(:,d+1));
    if pval(d) < 1e-3
        text(0.2*d,10, '***', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
    elseif pval(d) < 1e-2
        text(0.2*d,10, '**', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
    elseif pval(d) < 5e-2
        text(0.2*d,10, '*', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
    else
        text(0.2*d,10, 'N.S.', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
    end
end
hold off;

if ~isempty(save_to_dir)
    filename = strcat(save_to_dir, '/all_hit_oh');
    print('-depsc', filename);
end



end

