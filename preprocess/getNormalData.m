function data = getNormalData(data_dir, subject_id)
%getNormalData - 通常学習時のデータを取得する
%
% data_dirで指定されたフォルダからsubject_idに対応する通常学習時のデータを取得する
%
% [書式]
%　　data = getNormalData(data_dir, subject_id)
%
%
% [入力]
%　　data_dir: 実験データが格納されているフォルダ名（文字列）
%
%　　subject_id: 実験マウスのID（文字列）
%
% [出力]
%   data: 実験データを格納した構造体配列（各要素は以下の通り）
%　　　|
%　　　|- day_id: 実験日のID（文字列）
%　　　　　　　　
%
%=========================================================================

% 実験日のリストとその親フォルダ名を取得する
[list_days, work_dir] = getDayList(data_dir, subject_id);
% 解析対象の実験日数を取得
NumD = length(list_days);
% データ格納用セル配列を生成
data = cell(1, NumD);
% 各実験日のデータを取得する
for n = 1:NumD
    % 各実験日のフォルダ名を取得
    day_dir = list_days{n};
    % フォルダ名から余分な文字列を削除し、実験日idとする
    substr = extractAfter(day_dir, 'Day');
    tokens = strsplit(substr,'(');
    day_id = strcat('Day',erase(tokens{1},'N'));
    % ファイル読み込みのためのパスを取得
    file_path = strcat(work_dir,'/',day_dir);
    % Whiskerデータを取得
    [whisker,block_num_list,teaching] = getWhiskerData(file_path);
    % 電圧データを取得
    [voltage, block_mask] = getVoltageData(file_path, block_num_list);
    
    data{n}.day_id = day_id;
    data{n}.file_path = file_path;
    data{n}.voltage = voltage(block_mask);
    data{n}.whisker = whisker(block_mask);
    data{n}.block_num_list = block_num_list(block_mask);
    data{n}.teaching = teaching;
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% プライベート関数: 実験日のリストとその親フォルダ名を取得する
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [list_days, work_dir] = getDayList(data_dir, subject_id)
% フォルダのリストを取得する
folders = dir(strcat(data_dir, '/', subject_id));
% フォルダ数を取得する
MaxSF = length(folders);

% データがサブフォルダに存在するかをチェック
subfolder = '.';
for n = 1:MaxSF
    if contains(folders(n).name,'学習')
        subfolder = 'Normal学習';
        break;
    end
end

% 実験日リストが格納されている親フォルダを取得する
work_dir = strcat(data_dir, '/', subject_id, '/', subfolder);

% 実験日リストを取得する
folders = dir(work_dir);
% フォルダ数を取得する
MaxSF = length(folders);

% 実験日リストを格納するセル配列を初期化する
list_days = cell(1, MaxSF);

% 実験日リストを取得する
idx = 0;
for n = 1:MaxSF
    folder_name = folders(n).name;
    if contains(folder_name, 'Day')
        idx = idx+1;
        list_days{idx} = folder_name;
    end
end
list_days(idx+1:end) = [];

% 実験日順にソートする
days = str2double(extractAfter(list_days, 'Day'));
[~, d_idx] = sort(days, 'ascend');
list_days = list_days(d_idx);
end