function runTrialCategoryEstimationAnalysis02(Dataset, options)
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
    save_to_path = strcat(fig_dir,'/all/ml01');
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
cp_spec = nan(MaxTrials,153);
% �f�[�^�C���f�N�X��������
idx = 0;

% Normal condition����P���f�[�^�Z�b�g�Ɏg����f�[�^�𒊏o
for n = [1,2,3,6,10]
    % Normal condition�̃f�[�^�𒊏o
    data = Dataset{n}.data;
    % �w�K��i�Ō�3���ԁj�̃f�[�^�݂̂𒊏o
    for d = length(data)-2:length(data)
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

% Reversal condition����P���f�[�^�Z�b�g�Ɏg����f�[�^�𒊏o
for n = [2,6,7,8]
    % Normal condition�̃f�[�^�𒊏o
    data = Dataset{n}.rev_data;
    % �w�K��i�Ō�3���ԁj�̃f�[�^�݂̂𒊏o
    for d = length(data)-2:length(data)
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
        spec_load = reshape(W(:,1),[17,9]);
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
        figure(h1);
        clf;
        [fpr,tpr,T,AUC] = perfcurve(Ytest, Ptest_pred, 1);
        plot(fpr,tpr);
        axis square;
        xlabel('False positive rate')
        ylabel('True positive rate')
        title(sprintf('ROC curve (Test data = %s)', Dataset{n}.subject_id));
        % �t�@�C���ɏo��
        if ~isempty(save_to_path)
            filename = strcat(save_to_path, '/', sprintf('%s_confusion.csv', Dataset{n}.subject_id));
            writetable(CM,filename,'WriteVariableNames', true,'WriteRowNames', true);
            filename = strcat(save_to_path, '/', sprintf('%s_roc.eps', Dataset{n}.subject_id));
            print('-depsc', filename);
        end
        figure(h1);
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
            filename = strcat(save_to_path, '/', sprintf('%s_test_dist.eps', Dataset{n}.subject_id));
            print('-depsc', filename);
        end
    end
    
end


end

