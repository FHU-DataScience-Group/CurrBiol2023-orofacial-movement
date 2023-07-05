function runTrialCategoryEstimationAnalysis(Dataset, options)
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

% �ő�g���C�A�������擾
MaxTrials = 100000;

% �����}�E�X�����擾
MaxN = length(Dataset);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �f�[�^�Z�b�g�̍\�z
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

idx = 0;
for n = 1:MaxN
    % For normal condition
    data = Dataset{n}.data;
    for d = 1:length(data)
        trials = data{d}.trials;
        for k = 1:length(trials)
            if ~strcmp(trials{k}.outcome, 'Error')
                idx = idx + 1;
                if strcmp(trials{k}.outcome, 'Hit')
                    trial_category(idx) = 1;                    
                elseif strcmp(trials{k}.outcome, 'Lick')
                    trial_category(idx) = 2;
                else
                    trial_category(idx) = 0;
                end
                t = trials{k}.values.Time;
                whisk = trials{k}.values.Whisker;
                cp_protraction(idx) = computeCuePeriodProtraction(t, whisk, options);
                cp_spec(idx,:) = computeCuePeriodSpectrogram(t, whisk, options);
                sid(idx) = n;
            end
        end
    end
    % For reversal condition
    data = Dataset{n}.rev_data;
    for d = 1:length(data)
        trials = data{d}.trials;
        for k = 1:length(trials)
            if ~strcmp(trials{k}.outcome, 'Error')
                idx = idx + 1;
                if strcmp(trials{k}.outcome, 'Hit')
                    trial_category(idx) = 1;                    
                elseif strcmp(trials{k}.outcome, 'Lick')
                    trial_category(idx) = 2;
                else
                    trial_category(idx) = 0;
                end
                t = trials{k}.values.Time;
                whisk = trials{k}.values.Whisker;
                cp_protraction(idx) = computeCuePeriodProtraction(t, whisk, options);
                cp_spec(idx,:) = computeCuePeriodSpectrogram(t, whisk, options);
                sid(idx) = n;
            end
        end
    end
end
sid(idx+1:end) = [];
trial_category(idx+1:end) = [];
cp_protraction(idx+1:end) = [];
cp_spec(idx+1:end,:) = [];

for n = 1:MaxN
    test_mask = (sid == n);
    Xtrain1 = cp_protraction(test_mask);
    [Xtrain2, PCload, PCctrb, PCcenter] = fastPCA(cp_spec(test_mask,:));
    figure(1);
    hold off;
    plot(Xtrain1(trial_category(test_mask)>=1),Xtrain2(trial_category(test_mask)>=1,1),'+r');
    hold on;
    plot(Xtrain1(trial_category(test_mask)==0), Xtrain2(trial_category(test_mask)==0,1),'+b');
    pause;
end


for n = 1:MaxN
    test_mask = (sid == n);
    train_mask = ~test_mask;
    Xtrain1 = cp_protraction(train_mask);
    [Xtrain2, PCload, PCctrb, PCcenter] = fastPCA(cp_spec(train_mask,:));
    Xtrain = [Xtrain1, Xtrain2(:,1)];
    %Xtrain = [Xtrain2(:,1)];
    Ytrain = categorical(trial_category(train_mask)>=1, [1,0], {'RA', 'NonRA'});
    Xtest1 = cp_protraction(test_mask);
    Xtest2 = (cp_spec(test_mask,:) - PCcenter) * PCload;
    Xtest = [Xtest1, Xtest2(:,1)];   
    %Xtest = [Xtest2(:,1)];   
    Ytest = categorical(trial_category(test_mask)>=1, [1,0], {'RA', 'NonRA'});
    mdl = fitcnb(Xtrain, Ytrain);
    % �e�X�g�f�[�^�ɑ΂���\��
    Ytest_pred = predict(mdl, Xtest);
    %mdl = fitcdiscr(Xtrain, Ytrain);
    %Ytest_pred = predict(mdl, Xtest);
    % �����s��iconfusion matrix�j�̍쐬
    [CMarray, grpOrder] = confusionmat(Ytest, Ytest_pred);
    % �����s��̍s�E�񃉃x���̍쐬
    cat_label = categories(grpOrder);
    % �����s���table�^�ɕϊ�
    CMtable = array2table(CMarray, 'VariableNames', cat_label, 'RowNames', cat_label)
    figure(1);
    hold off;
    plot(Xtest(trial_category(test_mask)>=1,1), Xtest(trial_category(test_mask)>=1,2),'+r');
    hold on;
    plot(Xtest(trial_category(test_mask)==0,1), Xtest(trial_category(test_mask)==0,2),'+b');
    pause;
end

% [PCscore, PCload, PCctrb, PCcenter] = fastPCA(cp_spec);
%[PCscore, ~, ~, ~] = fastPCA(cp_spec);
%whos
%plot(PCscore(trial_category >= 1,1),PCscore(trial_category >= 1,1),'+');PCscore(trial_category == 0,1),PCscore(trial_category == 0,1));
%fastPCA(cp_spec);
%cat_mask1 = trial_category >= 1;
%cat_mask0 = trial_category == 0;
%plot(PCscore(cat_mask1,1), cp_protraction(cat_mask1),'r.', ...
%    PCscore(cat_mask0,1), cp_protraction(cat_mask0),'b.');


%h1 = histogram(PCscore(trial_category >= 1,1));
%hold on
%h2 = histogram(PCscore(trial_category == 0,1));
%h2 = histogram(cp_protraction(trial_category == 0));
%mean(cp_protraction(trial_category >= 1))
%mean(cp_protraction(trial_category == 0))
%[h,p,stat]= ttest2(cp_protraction(trial_category >= 1), cp_protraction(trial_category == 0))

return;

for n = 1:MaxN
    % �����}�E�XID���擾����
    subject_id = Dataset{n}.subject_id;
    % �ۑ���e�t�H���_��ݒ�
    prefix_dir = strcat(fig_dir, '/', subject_id, '/Normal');
    % Normal�����̑������������擾����
    NumD = length(Dataset{n}.data);
    % �e�������ɑ΂��Đ}���쐬
    for d = 1:NumD
        % ��������ID���擾
        day_id = Dataset{n}.data{d}.day_id;
        % �ۑ���t�H���_���w��
        if ~isempty(fig_dir)
            save_to_dir = strcat(prefix_dir, '/',day_id, '/whisk_spec');
        else
            save_to_dir = [];
        end
        % �}�̍쐬
        Dataset{n}.data{d} = visualizeWhiskerSpectrogramForDay(Dataset{n}.data{d}, options, save_to_dir);        
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Reversal�����̃f�[�^���G�N�X�|�[�g
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for n = 1:MaxN
    % �����}�E�XID���擾����
    subject_id = Dataset{n}.subject_id;
    % �ۑ���e�t�H���_��ݒ�
    prefix_dir = strcat(fig_dir, '/', subject_id, '/Reversal');
    % Reversal�����̑������������擾����
    NumD = length(Dataset{n}.rev_data);
    % �e�������ɑ΂��Đ}���쐬
    for d = 1:NumD
        % ��������ID���擾
        day_id = Dataset{n}.rev_data{d}.day_id;
        % �ۑ���t�H���_���w��
        if ~isempty(fig_dir)
            save_to_dir = strcat(prefix_dir, '/',day_id, '/whisk_spec');
        else
            save_to_dir = [];
        end
        % �}�̍쐬
        Dataset{n}.data{d} = visualizeWhiskerSpectrogramForDay(Dataset{n}.rev_data{d}, options, save_to_dir);        
    end
end

end

