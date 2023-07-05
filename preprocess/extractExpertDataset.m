function [ExpertAll, ExpertGP] = extractExpertDataset(Dataset, options)
%extractExpertDataset - ToDo
%
% ToDo
%
% [書式]
%　　ExpertAll = extractExpertDataset(Dataset, options)
%
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

% Normal条件のExpertマウスID
% ExpertNormalSubject = [1,3,6,10];
ExpertNormalSubject = [1,2,5,9];

% Reversal条件のExpertマウスID
ExpertRevSubject = [5,6,7];
% ExpertRevSubject = [2,6,7,8];

% 実験マウスの総数を取得
MaxN = length(Dataset);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Expert Mouseデータセットの抽出
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Expertマウスデータを格納するセル配列の領域確保
ExpertAll = cell(1,MaxN);

% セル配列の要素番号を初期化
idx = 0;

% Normal条件のExpertマウスデータの抽出
exp_condition = 'Normal';
for n = ExpertNormalSubject
    % 実験マウスIDを取得
    subject_id = Dataset{n}.subject_id;
    % 総実験日数を取得
    NumD = length(Dataset{n}.data);
    % 抽出する実験日マスクを初期化
    day_mask = false(1,NumD);
    for d = NumD:-1:1
        % dprimeが2以上ならばExpertにする
        if Dataset{n}.data{d}.dprime >= 2.5632
            day_mask(d) = true;
        end
        if sum(day_mask) >= 5
            break;
        end
    end
    % データを取得
    data = Dataset{n}.data(day_mask);
    % セル配列にデータ格納
    idx = idx + 1;    
    ExpertAll{idx}.subject_id = subject_id;
    ExpertAll{idx}.exp_condition = exp_condition;
    ExpertAll{idx}.data = data;
end

% Reversal条件のNaiveマウスデータの抽出
exp_condition = 'Reversal';
for n = ExpertRevSubject
    % 実験マウスIDを取得
    subject_id = Dataset{n}.subject_id;
    % 総実験日数を取得
    NumD = length(Dataset{n}.rev_data);
    % 抽出する実験日マスクを初期化
    day_mask = false(1,NumD);
    for d = NumD:-1:1
        % dprimeが2以上ならばExpertにする
        if Dataset{n}.rev_data{d}.dprime >= 2.5632
            day_mask(d) = true;
        end
        if sum(day_mask) >= 5
            break;
        end
    end
    % データを取得
    data = Dataset{n}.rev_data(day_mask);
    % セル配列にデータ格納
    idx = idx + 1;    
    ExpertAll{idx}.subject_id = subject_id;
    ExpertAll{idx}.exp_condition = exp_condition;
    ExpertAll{idx}.data = data;
end

ExpertAll(idx+1:end) = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Expert MouseデータセットからGood Performance時のみを抽出する
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ExpertGP = ExpertAll;
MaxExpN = length(ExpertGP);

for n = 1:MaxExpN
    data = ExpertGP{n}.data;
    for d = 1:length(data)
       suc_mask = data{d}.suc_mask; 
       data{d}.trials = data{d}.trials(suc_mask);
       data{d}.suc_mask = data{d}.suc_mask(suc_mask);
       data{d}.hit_rate = data{d}.hit_rate(suc_mask);
       data{d}.fa_rate = data{d}.fa_rate(suc_mask);
    end
    ExpertGP{n}.data = data;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Expert Mouseデータセットを中間ファイルとして保存する
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 作業用フォルダが存在しなければ作成する
if ~exist(options.WORK_DIR, 'dir')
    mkdir(options.WORK_DIR);
end
% 保存先ファイル名を設定する
mat_file = strcat(options.WORK_DIR, '/', 'expert_data.mat');
save(mat_file, 'ExpertAll', 'ExpertGP', '-v7.3');

end
