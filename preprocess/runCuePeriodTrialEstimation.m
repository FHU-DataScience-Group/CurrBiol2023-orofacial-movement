function runCuePeriodTrialEstimation(Dataset, label, options)
%visualizeRawData - ToDo
%
% ToDo
%
% [����]
%�@�@visualizeRawData(Dataset, options)
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

% �����}�E�X�����擾
MaxN = length(Dataset);

% Figure Window�̕�
FIG_XSize = 500;

% Figure Window�̍���
FIG_YSize = 300;

% Figure Window�̕�
FIG2_XSize = 400;

% Figure Window�̍���
FIG2_YSize = 500;

% CUE�񎦑O��Ԃ̐ݒ�i�P��: �b�j
PRE_CUE = 1.0;

% CUE�񎦌��Ԃ̐ݒ�i�P��: �b�j
POST_CUE = 0.1;

% Cue�񎦎��ԁi�P��: �b�j
CUE_DUR = options.CUE_DUR;

% Y���̍ő�l
Y_MAX = 40.0;

% Y���̍ŏ��l
Y_MIN = -5.0;

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
%% �t�H���_�쐬
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~isempty(options.FIG_DIR)
    save_to_dir = strcat(options.FIG_DIR, '/ML/', label, '/cue_period');
    if ~exist(save_to_dir, 'dir')
        mkdir(save_to_dir);
    end
else
    save_to_dir = [];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ���ޗp�f�[�^�Z�b�g�̍\�z
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% �����}�E�XID���i�[����ϐ��̗̈�m��
sid = nan(MaxTrials, 1);
% �g���C�A����ނ��i�[����ϐ��̗̈�m��
trial_category = nan(MaxTrials, 1);
% Cue Period�ɂ�����protraction���i�[����ϐ��̗̈�m��
cp_protraction = nan(MaxTrials,1);
% Cue Period�ɂ�����spectrogram���i�[����ϐ��̗̈�m��
cp_specpower = nan(MaxTrials, 1);
% �f�[�^�C���f�N�X��������
idx = 0;

% Normal condition����P���f�[�^�Z�b�g�Ɏg����f�[�^�𒊏o
for n = 1:length(Dataset)
    % Normal condition�̃f�[�^�𒊏o
    data = Dataset{n}.data;
    % �w�K��i�Ō�3���ԁj�̃f�[�^�݂̂𒊏o
    for d = 1:length(data)
        % �e���s�̃v���t�@�C�����擾
        trials = data{d}.trials;
        for k = 1:length(trials)
            % �G���[�g���C�A���łȂ����݂̂̂𒊏o
            if ~strcmp(trials{k}.outcome, 'Error')
                % �f�[�^�C���f�N�X���C���N�������g
                idx = idx + 1;
                % �����}�E�X�C���f�N�X���i�[
                sid(idx) = n;
                % ���ԏ��𒊏o
                t = trials{k}.values.Time;
                % WM���𒊏o
                whisk = trials{k}.values.Whisker;
                % cue period����protraction�ʂ��i�[
                cp_protraction(idx) = computeCuePeriodProtraction(t, whisk, options);
                % cue period���̃X�y�N�g���O�������i�[
                cp_specpower(idx,:) = computeCuePeriodSpectrogram(t, whisk, options);
                % Trial category���i�[
                if strcmp(trials{k}.outcome, 'Hit')
                    trial_category(idx) = 1;                    
                elseif strcmp(trials{k}.outcome, 'Lick')
                    trial_category(idx) = 2;
                else
                    trial_category(idx) = 0;
                end
            end
        end
    end
end

sid(idx+1:end) = [];
trial_category(idx+1:end) = [];
cp_protraction(idx+1:end) = [];
cp_specpower(idx+1:end) = [];





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
%% Figure Window�̐ݒ�
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �O����
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Figure Window�̕�
FIG_XSize = 560;

% Figure Window�̍���
FIG_YSize = 560;

% �ő�g���C�A�������擾
MaxTrials = 100000;

% �����}�E�X�����擾
MaxN = length(Dataset);

% Figure�o�͗p�t�H���_�̎擾
fig_dir = options.FIG_DIR;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �t�H���_�쐬�����PDF���|�[�g�t�@�C���̍쐬
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~isempty(fig_dir)
    save_to_path = strcat(fig_dir,'/all/ml02');
    % �o�͐�t�H���_�����݂��Ȃ��ꍇ�͍쐬����
    if ~exist(save_to_path, 'dir')
        mkdir(save_to_path);
    end
else
    save_to_path = [];
end

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
%% �w�K�p�f�[�^�Z�b�g�̍\�z
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% �����}�E�XID���i�[����ϐ��̗̈�m��
sid = nan(MaxTrials,1);
% �g���C�A����ނ��i�[����ϐ��̗̈�m��
trial_category = nan(MaxTrials,1);
% Cue Period�ɂ�����protraction���i�[����ϐ��̗̈�m��
cp_protraction = nan(MaxTrials,1);
% Cue Period�ɂ�����spectrogram���i�[����ϐ��̗̈�m��
cp_spec = nan(MaxTrials,180);
% �f�[�^�C���f�N�X��������
idx = 0;

% Normal condition����P���f�[�^�Z�b�g�Ɏg����f�[�^�𒊏o
for n = 1:length(Dataset)
    % Normal condition�̃f�[�^�𒊏o
    data = Dataset{n}.data;
    % �w�K��i�Ō�3���ԁj�̃f�[�^�݂̂𒊏o
    for d = 1:length(data)
        % �e���s�̃v���t�@�C�����擾
        trials = data{d}.trials;
        for k = 1:length(trials)
            % �G���[�g���C�A���łȂ����݂̂̂𒊏o
            if ~strcmp(trials{k}.outcome, 'Error')
                % �f�[�^�C���f�N�X���C���N�������g
                idx = idx + 1;
                % �����}�E�X�C���f�N�X���i�[
                sid(idx) = n;
                % ���ԏ��𒊏o
                t = trials{k}.values.Time;
                % WM���𒊏o
                whisk = trials{k}.values.Whisker;
                % cue period����protraction�ʂ��i�[
                cp_protraction(idx) = computeCuePeriodProtraction(t, whisk, options);
                % cue period���̃X�y�N�g���O�������i�[
                cp_spec(idx,:) = computeCuePeriodSpectrogram(t, whisk, options);
                % Trial category���i�[
                if strcmp(trials{k}.outcome, 'Hit')
                    trial_category(idx) = 1;                    
                elseif strcmp(trials{k}.outcome, 'Lick')
                    trial_category(idx) = 2;
                else
                    trial_category(idx) = 0;
                end
            end
        end
    end
end

sid(idx+1:end) = [];
trial_category(idx+1:end) = [];
cp_protraction(idx+1:end) = [];
cp_spec(idx+1:end,:) = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Spectrogram�����Subject-dependent PCA�̓K�p
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PCload = cell(1,MaxN);
PCcenter = cell(1,MaxN);
cp_spec_pc1 = nan(size(cp_protraction));
for n = 1:MaxN
    sid_mask = (sid == n);
    if sum(sid_mask) >= 1
        [PCscore, W, ~, M] = fastPCA(cp_spec(sid_mask,:));
        spec_load = reshape(W(:,1),[18,10]);
        if sum(sum(spec_load(2:5,5:end))) < 0
            PCscore = -PCscore;
            W = -W;
        end        
        cp_spec_pc1(sid_mask) = PCscore(:,1);
        PCload{n} = W(:,1);
        PCcenter{n} = M;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Leave-one-subject-out�������؂ɂ�镪�ސ��x�̕]��
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for n = 1:MaxN
    test_mask = (sid == n);
    if sum(test_mask) >= 1
        train_mask = ~test_mask;
        Xtrain = [cp_protraction(train_mask), cp_spec_pc1(train_mask)];
        Ytrain = trial_category(train_mask)>=1;
        % Ytrain = categorical(trial_category(train_mask)>=1, [1,0], {'RA', 'NonRA'});
        Xtest = [cp_protraction(test_mask), cp_spec_pc1(test_mask)];
        Ytest = trial_category(test_mask)>=1;
        % Ytest = categorical(trial_category(test_mask)>=1, [1,0], {'RA', 'NonRA'});
        % ���W�X�e�B�b�N��A���f���̊w�K
        B = glmfit(Xtrain, Ytrain, 'binomial');
        % �e�X�g�f�[�^�ɑ΂���\��
        Ptest_pred = glmval(B,Xtest,'logit');       
        Ytest_pred = Ptest_pred >= 0.5;
        
        %mdl = fitcnb(Xtrain, Ytrain);
        % �e�X�g�f�[�^�ɑ΂���\��
        %Ytest_pred = predict(mdl, Xtest);
        %mdl = fitcdiscr(Xtrain, Ytrain);
        %Ytest_pred = predict(mdl, Xtest);
        % �����s��iconfusion matrix�j�̍쐬
        Ytest_cat = categorical(Ytest, [1,0], {'RA', 'Non_RA'});
        Ytest_pred_cat = categorical(Ytest_pred, [1,0], {'RA', 'Non_RA'});
        [CMarray, grpOrder] = confusionmat(Ytest_cat, Ytest_pred_cat);
        % �����s��̍s�E�񃉃x���̍쐬
        cat_label = categories(grpOrder);
        % �����s���table�^�ɕϊ�
        CMtable = array2table(CMarray, 'VariableNames', cat_label, 'RowNames', cat_label);
        % ���\�w�W�̌v�Z
        % Accuracy�̌v�Z
        
        
        % �e�N���X��TP���̎擾
        TP = diag(CMarray);
        % �e�N���X�̗\�����̎擾
        Npred = sum(CMarray,1);
        % �e�N���X�̃T�|�[�g���̎擾
        Nsup = sum(CMarray,2);
        % Accuracy�̌v�Z
        accuracy = sum(TP)/sum(Nsup);
        accuracy_table = array2table([accuracy; accuracy], 'VariableNames', {'Accuracy'});
        % �e�N���X����Ƃ����K�����̌v�Z
        precision = TP./transpose(Npred);
        %prec_table = array2table(precision, 'VariableNames', {'Precision'});
        % �e�N���X����Ƃ����Č����̌v�Z
        recall = TP./Nsup;
        %recall_table = array2table(recall, 'VariableNames', {'Recall'});
        % �e�N���X����Ƃ���F1�X�R�A�̌v�Z
        f1 = 2*(recall.*precision)./(recall+precision);
        f1_table = array2table(f1, 'VariableNames', {'F1_score'});
        % �e�N���X�̃T�|�[�g�����e�[�u����
        %Nsup_table = array2table(Nsup, 'VariableNames', {'Support'});
        % AUC�̌v�Z
        [fpr,tpr,~,AUC] = perfcurve(Ytest, Ptest_pred, 1);
        auc_table = array2table([AUC; AUC], 'VariableNames', {'AUC'});
        % ��L�𓝍����������s��e�[�u�����쐬
        CM = [CMtable, accuracy_table, f1_table, auc_table]        
        % AUC�̌v�Z
        figure(1);
        clf;
        plot(fpr,tpr);
        axis square;
        xlabel('False positive rate')
        ylabel('True positive rate')
        title(sprintf('ROC curve (Test data = %s)', Dataset{n}.subject_id));
        % �t�@�C���ɏo��
        if ~isempty(save_to_path)
            filename = strcat(save_to_path, '/', sprintf('%s_learned_confusion.csv', Dataset{n}.subject_id));
            writetable(CM,filename,'WriteVariableNames', true,'WriteRowNames', true);
            filename = strcat(save_to_path, '/', sprintf('%s_learned_roc.eps', Dataset{n}.subject_id));
            print('-depsc', filename);
        end
        figure(1);
        clf;
        X1_MIN = min(Xtest(:,1));
        X1_MAX = max(Xtest(:,1));
        X2_MIN = min(Xtest(:,2));
        X2_MAX = max(Xtest(:,2));
        [x1,x2] = meshgrid(X1_MIN:(X1_MAX-X1_MIN)/50:X1_MAX, X2_MIN:(X2_MAX-X2_MIN)/50:X2_MAX);
        XX=[x1(:),x2(:)];
        p = x1;
        p(:) = glmval(B,XX,'logit');
        contourf(x1,x2,p,30);
        colormap(cool);
        colorbar;
        hold on;        
        pos_mask = (Ytest == 1);
        neg_mask = ~pos_mask;
        plot(Xtest(pos_mask,1),Xtest(pos_mask,2),'o','MarkerEdgeColor','w','MarkerFaceColor','r','LineWidth',1);
        hold on;
        plot(Xtest(neg_mask,1),Xtest(neg_mask,2),'o','MarkerEdgeColor','w','MarkerFaceColor','b','LineWidth',1);
        hold off;
        xlabel('Protraction after cue onset');
        ylabel('PC1 of spectrogram during cue period');
        title(sprintf('Distribution of test data: %s', Dataset{n}.subject_id));
        if ~isempty(save_to_path)
            filename = strcat(save_to_path, '/', sprintf('%s_learned_dist.eps', Dataset{n}.subject_id));
            print('-depsc', filename);
        end
        h1 = histogram(Xtest(pos_mask,1));
        hold on;
        h2 = histogram(Xtest(neg_mask,1));
        hold off;
        h1.Normalization = 'probability';
        h1.BinWidth = 5;
        h2.Normalization = 'probability';
        h2.BinWidth = 5;
        pause;
    end
    
end


end

