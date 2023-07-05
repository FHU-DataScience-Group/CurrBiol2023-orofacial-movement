function Dataset = runBehaviorAnalysis(Dataset, options)
%runBehaviorAnalysis - ToDo
%
% ToDo
%
% [書式]
%　　runBehaviorAnalysis(Dataset, options)
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

% 作成した図の保存先を指定
fig_dir = options.FIG_DIR;

% 実験マウス数を取得
MaxN = length(Dataset);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Normal条件の解析結果をエクスポート
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for n = 1:MaxN
    % 実験マウスIDを取得する
    subject_id = Dataset{n}.subject_id;
    % 保存先親フォルダを設定
    prefix_dir = strcat(fig_dir, '/', subject_id, '/Normal');
    % Normal条件の総実験日数を取得する
    NumD = length(Dataset{n}.data);
    % 各実験日に対して解析を実行
    for d = 1:NumD
        % 実験日のIDを取得
        day_id = Dataset{n}.data{d}.day_id;
        % 保存先フォルダを指定
        if ~isempty(fig_dir)
            save_to_dir = strcat(prefix_dir, '/',day_id, '/behavior');
        else
            save_to_dir = [];
        end
        % 解析ルーチンを実行
        Dataset{n}.data{d} = runBehaviorAnalysisForDay(Dataset{n}.data{d}, options, save_to_dir);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Reversal条件のデータをエクスポート
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for n = 1:MaxN
    % 実験マウスIDを取得する
    subject_id = Dataset{n}.subject_id;
    % 保存先親フォルダを設定
    prefix_dir = strcat(fig_dir, '/', subject_id, '/Reversal');
    % Reversal条件の総実験日数を取得する
    NumD = length(Dataset{n}.rev_data);
    % 各実験日に対して解析を実行
    for d = 1:NumD
        % 実験日のIDを取得
        day_id = Dataset{n}.rev_data{d}.day_id;
        % 保存先フォルダを指定
        if ~isempty(fig_dir)
            save_to_dir = strcat(prefix_dir, '/',day_id, '/behavior');
        else
            save_to_dir = [];
        end
        % 解析ルーチンを実行
        Dataset{n}.rev_data{d} = runBehaviorAnalysisForDay(Dataset{n}.rev_data{d}, options, save_to_dir);
    end
end

% 作業用フォルダが存在しなければ作成する
if ~exist(options.WORK_DIR, 'dir')
    mkdir(options.WORK_DIR);
end
% 保存先ファイル名を設定する
mat_file = strcat(options.WORK_DIR, '/', 'raw_trial_behavior_data.mat');
save(mat_file, 'Dataset', '-v7.3');

end

