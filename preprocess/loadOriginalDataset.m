function Dataset = loadOriginalDataset(options)
%loadOriginalDataset - 実験データの読み込み
%
% optionsで指定されたパスから実験データを読み込む
%
% [書式]
%　　Dataset = loadOriginalDataset(options)
%
%
% [入力]
%　　options: setWhiskerOptions関数で生成された構造体
%　　　　　　　（詳細はsetWhiskerOptionsを参照）
%
% [出力]
%   Dataset: 実験データを格納した構造体配列（各要素は以下の通り）
%　　　|
%　　　|- subject_id: 実験マウスのID（文字列）
%
%
%=========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 前処理: matファイルからのデータ読み込みを試行
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % データを格納した（これから格納する）mat file名を設定
mat_file = strcat(options.WORK_DIR,'/','raw_data.mat');
% 
% if ~options.LOAD_ORG_FILE
%     try
%         load(mat_file,'Dataset');
%         return;
%     catch
%         fprintf(1, 'Not found the file: %s\n', mat_file);
%         fprintf(1, 'Instead loading the data from %s\n', options.DATA_DIR);
%     end
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% メインルーチン: データの読み込み
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 解析対象データの格納先を取得
data_dir = options.DATA_DIR;

% 実験マウス名のリストを取得する
list_subjects = getSubjectList(data_dir);

% 実験マウス数を取得する
NumS = length(list_subjects);
% 読み込んだデータを格納するセル配列を用意する
Dataset = cell(1,NumS);

% 各実験マウスのデータを読み込む
for n = 1:NumS
    subject_id = list_subjects{n};
    fprintf(1,'Now loading data for subject: %s\n', subject_id);
    Dataset{n}.subject_id = subject_id;
    Dataset{n}.data = getNormalData(data_dir, subject_id);
    Dataset{n}.rev_data = getReversalData(data_dir, subject_id);
end

% 作業用フォルダにデータを保存
if ~exist(options.WORK_DIR, 'dir')
    mkdir(options.WORK_DIR);
end
mat_file = strcat(options.WORK_DIR,'/','raw_data.mat');
save(mat_file, 'Dataset', '-v7.3');
end

