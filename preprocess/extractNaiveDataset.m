function NaiveAll = extractNaiveDataset(Dataset, options)
%extractNaiveDataset - ToDo
%
% ToDo
%
% [書式]
%　　NaiveDataset = extractNaiveDataset(Dataset)
%
% [入力]
%　　Dataset: ToDo
%
%
% [出力]
%   Dataset: ToDo
%　　　　　　　　
%
%=========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 定数の取得
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Normal条件のNaiveマウスID
NaiveNormalSubject = [1,2,3,8,9];
%NaiveNormalSubject = [4,9,10];

% Reversal条件のNaiveマウスID
NaiveRevSubject = [4,5,6,7];
%NaiveRevSubject = [5,6,7,8];

% 実験マウスの総数を取得
MaxN = length(Dataset);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Naive Mouseデータセットの抽出
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Naiveマウスデータを格納するセル配列の領域確保
NaiveAll = cell(1,MaxN);

% セル配列の要素番号を初期化
idx = 0;

% Normal条件のNaiveマウスデータの抽出
exp_condition = 'Normal';
for n = NaiveNormalSubject
    % 実験マウスIDを取得
    subject_id = Dataset{n}.subject_id;
    % 総実験日数を取得
    NumD = length(Dataset{n}.data);
    % 抽出する実験日マスクを初期化
    day_mask = false(1,NumD);
    for d = 1:min([3,NumD])
        % dprimeが1.0以上になったらNaiveではなくなったと判断
        if Dataset{n}.data{d}.dprime > 1.0
            break;
        end
        day_mask(d) = true;
    end
    % データを取得
    data = Dataset{n}.data(day_mask);
    % セル配列にデータ格納
    idx = idx + 1;    
    NaiveAll{idx}.subject_id = subject_id;
    NaiveAll{idx}.exp_condition = exp_condition;
    NaiveAll{idx}.data = data;
end

% Reversal条件のNaiveマウスデータの抽出
exp_condition = 'Reversal';
for n = NaiveRevSubject
    % 実験マウスIDを取得
    subject_id = Dataset{n}.subject_id;
    % 総実験日数を取得
    NumD = length(Dataset{n}.rev_data);
    % 抽出する実験日マスクを初期化
    day_mask = false(1,NumD);
    for d = 1:min([3,NumD])
        % dprimeが1.0以上になったらNaiveではなくなったと判断
        if Dataset{n}.rev_data{d}.dprime > 1.0
            break;
        end
        day_mask(d) = true;
    end
    % データを取得
    data = Dataset{n}.rev_data(day_mask);
    % セル配列にデータ格納
    idx = idx + 1;    
    NaiveAll{idx}.subject_id = subject_id;
    NaiveAll{idx}.exp_condition = exp_condition;
    NaiveAll{idx}.data = data;
end

NaiveAll(idx+1:end) = [];

% 作業用フォルダが存在しなければ作成する
if ~exist(options.WORK_DIR, 'dir')
    mkdir(options.WORK_DIR);
end
% 保存先ファイル名を設定する
mat_file = strcat(options.WORK_DIR, '/', 'naive_data.mat');
save(mat_file, 'NaiveAll', '-v7.3');

end
