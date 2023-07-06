clear
close all

load 'expert_data.mat'
options = setWhiskerOptions;
Dataset=ExpertGP;



MaxTrials = 100000;

MaxN = length(Dataset);

fig_dir = options.FIG_DIR;

if ~isempty(fig_dir)
    save_to_path = fig_dir;
    if ~exist(save_to_path, 'dir')
        mkdir(save_to_path);
    end
else
    save_to_path = [];
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% prepare datasets
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sid = nan(MaxTrials,1);
trial_category = nan(MaxTrials,1);
cp_protraction = nan(MaxTrials,1);
rw_protraction = nan(MaxTrials,1);

cp_spec = nan(MaxTrials,240);
rw_spec = nan(MaxTrials,240);

cp_cumwhisk = nan(MaxTrials,1);
rw_cumwhisk = nan(MaxTrials,1);

%data index
idx = 0;






% Normal conditionから訓練データセットに使えるデータを抽出
for n = 1:length(Dataset)
    mouse_name{n}=[Dataset{n}.subject_id,'_',Dataset{n}.exp_condition];
    % Normal conditionのデータを抽出
    data = Dataset{n}.data;
    % 学習後（最後3日間）のデータのみを抽出
    for d = 1:length(data)
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

                cp_protraction(idx) = computeProtraction(t, whisk, 0.0);
                rw_protraction(idx) = computeProtraction(t, whisk, 3.0);

                cp_spec(idx,:) = computeSpectrogram_BP_rel(t, whisk, options, 0.0);
                rw_spec(idx,:) = computeSpectrogram_BP_rel(t, whisk, options, 3.0);

                cp_cumwhisk(idx)  = compute_cum_whisk(t, whisk, options, 0.0);
                rw_cumwhisk(idx)  = compute_cum_whisk(t, whisk, options, 3.0);

                % Trial categoryを格納
                if strcmp(trials{k}.outcome, 'Hit')
                    trial_category(idx) = 1;
                elseif strcmp(trials{k}.outcome, 'Lick') %Omission Lick
                    trial_category(idx) = 3;
                elseif strcmp(trials{k}.outcome, 'CR')
                    trial_category(idx) = 0;
                else
                    trial_category(idx) = 3;
                end
            end
        end
    end
end

sid(idx+1:end) = [];
trial_category(idx+1:end) = [];
cp_protraction(idx+1:end) = [];
rw_protraction(idx+1:end) = [];
cp_spec(idx+1:end,:) = [];
rw_spec(idx+1:end,:) = [];
cp_cumwhisk(idx+1:end) = [];
rw_cumwhisk(idx+1:end) = [];

sid(trial_category==3 | trial_category==0)=[];
cp_protraction(trial_category==3 | trial_category==0) = [];
rw_protraction(trial_category==3 | trial_category==0) = [];
cp_spec(trial_category==3 | trial_category==0,:) = [];
rw_spec(trial_category==3 | trial_category==0,:) = [];

cp_cumwhisk(trial_category==3 | trial_category==0) = [];
rw_cumwhisk(trial_category==3 | trial_category==0) = [];

trial_category(trial_category==3 | trial_category==0)=[];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SpectrogramからのSubject-dependent PCAの適用
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

save('features.mat', 'rw_*', 'cp_*', 'trial_category', 'sid', 'MaxN', 'save_to_path', 'mouse_name')


