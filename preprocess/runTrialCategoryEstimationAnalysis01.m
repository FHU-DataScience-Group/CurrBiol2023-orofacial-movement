function runTrialCategoryEstimationAnalysis02(Dataset, options)
%visualizeRawData - ToDo
%
% ToDo
%
% [書式]
%　　visualizeRawData(Dataset, options)
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
%% 前処理
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Figure Windowの幅
FIG_XSize = 560;

% Figure Windowの高さ
FIG_YSize = 560;

% 最大トライアル数を取得
MaxTrials = 100000;

% 実験マウス数を取得
MaxN = length(Dataset);

% Figure出力用フォルダの取得
fig_dir = options.FIG_DIR;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% フォルダ作成およびPDFレポートファイルの作成
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~isempty(fig_dir)
    save_to_path = strcat(fig_dir,'/all/ml01');
    % 出力先フォルダが存在しない場合は作成する
    if ~exist(save_to_path, 'dir')
        mkdir(save_to_path);
    end
else
    save_to_path = [];
end

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
%% 学習用データセットの構築
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 実験マウスIDを格納する変数の領域確保
sid = nan(MaxTrials,1);
% トライアル種類を格納する変数の領域確保
trial_category = nan(MaxTrials,1);
% Cue Periodにおけるprotractionを格納する変数の領域確保
cp_protraction = nan(MaxTrials,1);
% Cue Periodにおけるspectrogramを格納する変数の領域確保
cp_spec = nan(MaxTrials,153);
% データインデクスを初期化
idx = 0;

% Normal conditionから訓練データセットに使えるデータを抽出
for n = [1,2,3,6,10]
    % Normal conditionのデータを抽出
    data = Dataset{n}.data;
    % 学習後（最後3日間）のデータのみを抽出
    for d = length(data)-2:length(data)
        % 各試行のプロファイルを取得
        trials = data{d}.trials;
        for k = 1:length(trials)
            % エラートライアルでないもののみを抽出
            if ~strcmp(trials{k}.outcome, 'Error')
                % データインデクスをインクリメント
                idx = idx + 1;
                % 実験マウスインデクスを格納
                sid(idx) = n;
                % 時間情報を抽出
                t = trials{k}.values.Time;
                % WM情報を抽出
                whisk = trials{k}.values.Whisker;
                % cue period時のprotraction量を格納
                cp_protraction(idx) = computeCuePeriodProtraction(t, whisk, options);
                % cue period時のスペクトログラムを格納
                cp_spec(idx,:) = computeCuePeriodSpectrogram(t, whisk, options);
                % Trial categoryを格納
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

% Reversal conditionから訓練データセットに使えるデータを抽出
for n = [2,6,7,8]
    % Normal conditionのデータを抽出
    data = Dataset{n}.rev_data;
    % 学習後（最後3日間）のデータのみを抽出
    for d = length(data)-2:length(data)
        % 各試行のプロファイルを取得
        trials = data{d}.trials;
        for k = 1:length(trials)
            % エラートライアルでないもののみを抽出
            if ~strcmp(trials{k}.outcome, 'Error')
                % データインデクスをインクリメント
                idx = idx + 1;
                % 実験マウスインデクスを格納
                sid(idx) = n;
                % 時間情報を抽出
                t = trials{k}.values.Time;
                % WM情報を抽出
                whisk = trials{k}.values.Whisker;
                % cue period時のprotraction量を格納
                cp_protraction(idx) = computeCuePeriodProtraction(t, whisk, options);
                % cue period時のスペクトログラムを格納
                cp_spec(idx,:) = computeCuePeriodSpectrogram(t, whisk, options);
                % Trial categoryを格納
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
%% SpectrogramからのSubject-dependent PCAの適用
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
%% Leave-one-subject-out交差検証による分類精度の評価
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
        % ロジスティック回帰モデルの学習
        B = glmfit(Xtrain, Ytrain, 'binomial');
        % テストデータに対する予測
        Ptest_pred = glmval(B,Xtest,'logit');       
        Ytest_pred = Ptest_pred >= 0.5;
        
        %mdl = fitcnb(Xtrain, Ytrain);
        % テストデータに対する予測
        %Ytest_pred = predict(mdl, Xtest);
        %mdl = fitcdiscr(Xtrain, Ytrain);
        %Ytest_pred = predict(mdl, Xtest);
        % 混同行列（confusion matrix）の作成
        Ytest_cat = categorical(Ytest, [1,0], {'RA', 'Non_RA'});
        Ytest_pred_cat = categorical(Ytest_pred, [1,0], {'RA', 'Non_RA'});
        [CMarray, grpOrder] = confusionmat(Ytest_cat, Ytest_pred_cat);
        % 混同行列の行・列ラベルの作成
        cat_label = categories(grpOrder);
        % 混同行列をtable型に変換
        CMtable = array2table(CMarray, 'VariableNames', cat_label, 'RowNames', cat_label);
        % 性能指標の計算
        % Accuracyの計算
        
        
        % 各クラスのTP数の取得
        TP = diag(CMarray);
        % 各クラスの予測数の取得
        Npred = sum(CMarray,1);
        % 各クラスのサポート数の取得
        Nsup = sum(CMarray,2);
        % Accuracyの計算
        accuracy = sum(TP)/sum(Nsup);
        accuracy_table = array2table([accuracy; accuracy], 'VariableNames', {'Accuracy'});
        % 各クラスを基準とした適合率の計算
        precision = TP./transpose(Npred);
        %prec_table = array2table(precision, 'VariableNames', {'Precision'});
        % 各クラスを基準とした再現率の計算
        recall = TP./Nsup;
        %recall_table = array2table(recall, 'VariableNames', {'Recall'});
        % 各クラスを基準としたF1スコアの計算
        f1 = 2*(recall.*precision)./(recall+precision);
        f1_table = array2table(f1, 'VariableNames', {'F1_score'});
        % 各クラスのサポート数をテーブル化
        %Nsup_table = array2table(Nsup, 'VariableNames', {'Support'});
        % AUCの計算
        [fpr,tpr,~,AUC] = perfcurve(Ytest, Ptest_pred, 1);
        auc_table = array2table([AUC; AUC], 'VariableNames', {'AUC'});
        % 上記を統合した混同行列テーブルを作成
        CM = [CMtable, accuracy_table, f1_table, auc_table]        
        % AUCの計算
        figure(h1);
        clf;
        [fpr,tpr,T,AUC] = perfcurve(Ytest, Ptest_pred, 1);
        plot(fpr,tpr);
        axis square;
        xlabel('False positive rate')
        ylabel('True positive rate')
        title(sprintf('ROC curve (Test data = %s)', Dataset{n}.subject_id));
        % ファイルに出力
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

