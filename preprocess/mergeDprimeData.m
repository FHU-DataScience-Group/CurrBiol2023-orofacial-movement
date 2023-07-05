function Dataset = mergeDprimeData(Dataset, options)
%mergeDprimeData - ToDo
%
% ToDo
%
% [書式]
%　　Dataset = mergeDprimeData(Dataset, options)
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

% D-primeデータの格納先を指定
DPRIME_DIR = options.DPRIME_DIR;

% 実験マウス数を取得
MaxN = length(Dataset);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Normal条件のDprimeデータを取得
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for n = 1:MaxN
    % 実験マウスIDを取得する
    subject_id = Dataset{n}.subject_id;
    % 保存先親フォルダを設定
    prefix_dir = strcat(DPRIME_DIR, '/Normal/', subject_id);
    % Normal条件の総実験日数を取得する
    NumD = length(Dataset{n}.data);
    % 各実験日に対して解析を実行
    for d = 1:NumD
        % 実験日のIDを取得
        day_id = Dataset{n}.data{d}.day_id;
        % 読み込み対象のファイル名を設定
        filename = strcat(prefix_dir,'/',day_id,'/',day_id,'.txt');
        % D-primeデータを取得
        dprime = load(filename,'-ascii');
        % 構造体にD-primeデータを追加
        Dataset{n}.data{d}.dprime = dprime;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Reversal条件のDprimeデータを取得
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for n = 1:MaxN
    % 実験マウスIDを取得する
    subject_id = Dataset{n}.subject_id;
    % 保存先親フォルダを設定
    prefix_dir = strcat(DPRIME_DIR, '/Reversal/', subject_id);
    % Normal条件の総実験日数を取得する
    NumD = length(Dataset{n}.rev_data);
    % 各実験日に対して解析を実行
    for d = 1:NumD
        % 実験日のIDを取得
        day_id = Dataset{n}.rev_data{d}.day_id;
        % 読み込み対象のファイル名を設定
        filename = strcat(prefix_dir,'/',day_id,'/',day_id,'.txt');
        % D-primeデータを取得
        dprime = load(filename,'-ascii');
        % 構造体にD-primeデータを追加
        Dataset{n}.rev_data{d}.dprime = dprime;
    end
end

end

