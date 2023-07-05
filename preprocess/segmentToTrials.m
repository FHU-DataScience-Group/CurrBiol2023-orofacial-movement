function Dataset = segmentToTrials(Dataset, options)
%segmentToTrials - 生データをトライアル単位に切り分ける
%
% Datasetに格納されている全データをトライアル単位に切り分け
% 各トライアル条件を同定する。
%
% [書式]
%　　Dataset = segmentToTrials(Dataset, options)
%
%
% [入力]
%　　Dataset: 生データを格納している構造体
%
%　　options: ToDo
%
% [出力]
%   data: ToDo
%
%
%=========================================================================

% 実験マウス数を取得する
MaxN = length(Dataset);
% 各実験マウスに対して以下の処理を実行
for n = 1:MaxN
    % Normal条件について各実験日ごとにトライアル単位に切り分ける
    NumD = length(Dataset{n}.data);
    for d = 1:NumD
        Dataset{n}.data{d} = segmentToTrialsForDay(Dataset{n}.data{d}, options);
    end
    % Reversal条件について各実験日ごとにトライアル単位に切り分ける
    NumD = length(Dataset{n}.rev_data);
    for d = 1:NumD
        Dataset{n}.rev_data{d} = segmentToTrialsForDay(Dataset{n}.rev_data{d}, options);
    end
end

% 作業用フォルダが存在しなければ作成する
if ~exist(options.WORK_DIR, 'dir')
    mkdir(options.WORK_DIR);
end
% 保存先ファイル名を設定する
mat_file = strcat(options.WORK_DIR, '/', 'raw_trial_data.mat');
save(mat_file, 'Dataset', '-v7.3');
end

