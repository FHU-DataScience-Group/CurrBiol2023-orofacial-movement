function Dataset = computePerformanceIndex(Dataset, options)
%computePerformanceIndex - ToDo
%
% ToDo
%
% [書式]
%　　Dataset = computePerformanceIndex(Dataset, options)
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

% 実験マウス数を取得
MaxN = length(Dataset);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Normal条件の解析結果をエクスポート
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for n = 1:MaxN
    % Normal条件の総実験日数を取得する
    NumD = length(Dataset{n}.data);
    % 各実験日に対して解析を実行
    for d = 1:NumD
        % 解析ルーチンを実行
        Dataset{n}.data{d} = computePerformanceIndexForDay(Dataset{n}.data{d}, options);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Reversal条件のデータをエクスポート
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for n = 1:MaxN
    % Reversal条件の総実験日数を取得する
    NumD = length(Dataset{n}.rev_data);
    % 各実験日に対して解析を実行
    for d = 1:NumD
        % 解析ルーチンを実行
        Dataset{n}.rev_data{d} = computePerformanceIndexForDay(Dataset{n}.rev_data{d}, options);
    end
end

% 作業用フォルダが存在しなければ作成する
if ~exist(options.WORK_DIR, 'dir')
    mkdir(options.WORK_DIR);
end
% 保存先ファイル名を設定する
mat_file = strcat(options.WORK_DIR, '/', 'raw_trial_behavior_dprime_data.mat');
save(mat_file, 'Dataset', '-v7.3');

end

