function analyzeCuePeriodGrandAverage(Dataset, options, label)
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
Y_MAX = 40.0;

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
%% フォルダ作成
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~isempty(options.FIG_DIR)
    save_to_dir = strcat(options.FIG_DIR, '/GrandAverage/', label, '/cue_period');
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
    stat{n} = analyzeCuePeriodWMAverageForSubject(Dataset{n}, options, label);
end

t = stat{1}.t_cue;
wm_hit = nan(length(t), MaxN);
wm_cr = nan(length(t), MaxN);
wm_oh = nan(length(t), MaxN);

for n = 1:MaxN
    wm_hit(:,n) = stat{n}.mean_wm_cue_hit;
    wm_cr(:,n) = stat{n}.mean_wm_cue_cr;
    if ~isnan(stat{n}.mean_wm_cue_oh)
        wm_oh(:,n) = stat{n}.mean_wm_cue_oh;
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

area([0, CUE_DUR], [Y_MAX, Y_MAX], Y_MIN, 'FaceColor', 'c','FaceAlpha',0.1,'EdgeColor', 'none', 'LineStyle', 'none', 'ShowBaseLine', 'off');
area([CUE_DUR, min([max(t), CUE_DUR+10])], [Y_MAX, Y_MAX], Y_MIN, 'FaceColor', 'g','FaceAlpha',0.1,'EdgeColor', 'none', 'LineStyle', 'none', 'ShowBaseLine', 'off');

ar1 = area(t, [mean_wm_hit-sem_wm_hit, 2*sem_wm_hit]);
set(ar1(1),'FaceColor','None', 'LineStyle', 'none', 'ShowBaseLine', 'off')
set(ar1(2),'FaceColor', co(1,:) ,'FaceAlpha',0.5,'EdgeColor', 'none', 'LineStyle', 'none', 'ShowBaseLine', 'off');
plt1 = plot(t, mean_wm_hit, '-', 'Color', co(1,:));

ar1 = area(t, [mean_wm_cr-sem_wm_cr, 2*sem_wm_cr]);
set(ar1(1),'FaceColor','None', 'LineStyle', 'none', 'ShowBaseLine', 'off')
set(ar1(2),'FaceColor', co(2,:) ,'FaceAlpha',0.5,'EdgeColor', 'none', 'LineStyle', 'none', 'ShowBaseLine', 'off');
plt2 = plot(t, mean_wm_cr, '-', 'Color', co(2,:));
xlim([min(t),max(t)]);
ylim([Y_MIN, Y_MAX]);
xlabel('Time from cue onset (s)');
ylabel('Whisker angle (degree)');
title(sprintf('%s', label),'FontSize', 16);
legend([plt1, plt2], 'Hit', 'CR', 'Location', 'northeastoutside');

if ~isempty(save_to_dir)
    filename = strcat(save_to_dir, '/all_hit_cr');
    print('-dpdf', filename);
    print('-painters', '-depsc', filename);
    
end

if sum(~isnan(sum(wm_oh,1))) > 0
    ar1 = area(t, [mean_wm_oh-sem_wm_oh, 2*sem_wm_oh]);
    set(ar1(1),'FaceColor','None', 'LineStyle', 'none', 'ShowBaseLine', 'off')
    set(ar1(2),'FaceColor', co(3,:) ,'FaceAlpha',0.5,'EdgeColor', 'none', 'LineStyle', 'none', 'ShowBaseLine', 'off');
    plt3 = plot(t, mean_wm_oh, '-', 'Color', co(3,:));
    legend([plt1, plt2, plt3], 'Hit', 'CR', 'OH', 'Location', 'northeastoutside');
    if ~isempty(save_to_dir)
        filename = strcat(save_to_dir, '/', 'all_hit_cr_oh');
        print('-dpdf', filename);
        print('-painters', '-depsc', filename);
    end
end
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Figure Windowの設定
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h2 = figure(2);
clf(h2);
POS = get(h2, 'Position');
POS(3:4) = [FIG2_XSize, FIG2_YSize];
set(h2, 'Position', POS);

cue_mask = (t > 0) & (t < CUE_DUR/4);
max_prot_hit = max(wm_hit(cue_mask,:),[],1);
max_prot_cr = max(wm_cr(cue_mask,:),[],1);
max_prot_oh = max(wm_oh(cue_mask,:),[],1);

x_value = repmat([1;2],[1,MaxN]);
y_value = [max_prot_hit; max_prot_cr];
[~,p] = ttest(max_prot_hit - max_prot_cr); %mean_hit_protraction-mean_cr_protraction);
if p < 0.001
    marker = '***';
elseif p < 0.01
    marker = '**';
elseif p < 0.05
    marker = '*';
else
    marker = 'N.S.';
end
ymax = nanmax(y_value(:));
yrng = ymax - nanmin(y_value(:));
clf;
plot(x_value,y_value,'-d','MarkerSize',8, 'MarkerFaceColor','auto');
hold on;
text(1.5, ymax+0.15*yrng, marker,'HorizontalAlignment','center','VerticalAlignment', 'middle', 'FontSize',14);
plot([1, 1],[ymax+0.1*yrng, ymax+0.15*yrng],'k-','LineWidth',1);
plot([2, 2],[ymax+0.1*yrng, ymax+0.15*yrng],'k-','LineWidth',1);
plot([1, 1.25],[ymax+0.15*yrng, ymax+0.15*yrng],'k-','LineWidth',1);
plot([1.75, 2],[ymax+0.15*yrng, ymax+0.15*yrng],'k-','LineWidth',1);
legend(subject_id,'Location','northeastoutside','Interpreter','none');

set(gca,'XTick',1:2);
set(gca,'XTickLabel', {'Hit', 'CR'});
xlim([0.5,2.5]);
ylim([Y_MIN, Y_MAX]);
xlabel('Trial category');
ylabel('Protraction after cue onset (degree)');
title(label);

if ~isempty(save_to_dir)
    filename = strcat(save_to_dir, '/compare_prot_hit_cr');
    print('-dpdf', filename);
    print('-painters', '-depsc', filename);
end

if sum(~isnan(sum(wm_oh,1))) > 0
    clf(h2);
    x_value = repmat([1;2],[1,MaxN]);
    y_value = [max_prot_hit; max_prot_oh];
    [~,p] = ttest(max_prot_hit - max_prot_oh); %mean_hit_protraction-mean_cr_protraction);
    if p < 0.001
        marker = '***';
    elseif p < 0.01
        marker = '**';
    elseif p < 0.05
        marker = '*';
    else
        marker = 'N.S.';
    end
    ymax = max(y_value(:));
    yrng = ymax - min(y_value(:));
    plot(x_value,y_value,'-d','MarkerSize',8, 'MarkerFaceColor','auto');
    hold on;
    text(1.5, ymax+0.15*yrng, marker,'HorizontalAlignment','center','VerticalAlignment', 'middle', 'FontSize',14);
    plot([1, 1],[ymax+0.1*yrng, ymax+0.15*yrng],'k-','LineWidth',1);
    plot([2, 2],[ymax+0.1*yrng, ymax+0.15*yrng],'k-','LineWidth',1);
    plot([1, 1.25],[ymax+0.15*yrng, ymax+0.15*yrng],'k-','LineWidth',1);
    plot([1.75, 2],[ymax+0.15*yrng, ymax+0.15*yrng],'k-','LineWidth',1);
    legend(subject_id,'Location','northeastoutside','Interpreter','none');
    set(gca,'XTick',1:2);
    set(gca,'XTickLabel', {'Hit', 'OH'});
    xlim([0.5,2.5]);
    ylim([Y_MIN, Y_MAX]);
    xlabel('Trial category');
    ylabel('Protraction after cue tone (degree)');
    title(label);
    if ~isempty(save_to_dir)
        filename = strcat(save_to_dir, '/compare_prot_hit_oh');
        print('-dpdf', filename);
        print('-painters', '-depsc', filename);
    end
end

end

