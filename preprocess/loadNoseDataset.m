function Dataset = loadNoseDataset(Dataset, options)
%loadOriginalDataset - 実験データの読み込み
%
% optionsで指定されたパスから実験データを読み込む
%
% [書式]
%
% [入力]
%
% [出力]
%
%=========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 定数の取得
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 実験マウスの総数を取得
MaxN = length(Dataset);

% 解析対象データの格納先を取得
data_root_dir = options.DATA_NOSE_DIR;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% メインルーチン: データの読み込み
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for n=1:MaxN
    % 実験マウスIDを取得
    subject_id = Dataset{n}.subject_id
    % Normal条件の存在をチェック
    exist_normal = ~isempty(Dataset{n}.data);
    % Normal条件のデータを取得
    if exist_normal
        % 解析対象データのフォルダを設定
        data_dir_sufix = strcat(data_root_dir,'/',subject_id);
        % 総実験日数を取得
        NumD = length(Dataset{n}.data);
        % 各実験日ごとの処理
        for d = 1:NumD
            data = Dataset{n}.data{d};
            day_id = data.day_id;
            data_dir = sprintf('%s/%s_%s',data_dir_sufix,subject_id,day_id);
            if ~exist(data_dir,'dir')
                data_dir = sprintf('%s/%s%s',data_dir_sufix,subject_id,day_id);
            end
            NumB = length(data.block_num_list);
            nose = cell(1,NumB);
            for b = 1:NumB
                raw_data = nan(36000,15);
                pattern = sprintf('%s/%dDLC*',data_dir,data.block_num_list(b))
                listing = dir(pattern);
                % ファイルが存在すれば読み込み
                if ~isempty(listing)
                    full_fname = strcat(listing(1).folder,'/',listing(1).name);
                    try
                        tmp_data = csvread(full_fname,3,0);
                        tmp_data = tmp_data(:,2:end);
                        raw_data(:,:) = tmp_data(:,:);
                    catch
                        disp(full_fname);
                    end
                else
                    disp(full_fname);
                end
                nose{b} = array2table(raw_data, 'VariableNames', ...
                                {'L_P_nose_x', 'L_P_nose_y', 'L_P_nose_lh', ...
                                'L_D_nose_x', 'L_D_nose_y', 'L_D_nose_lh', ...
                                'C_D_nose_x', 'C_D_nose_y', 'C_D_nose_lh', ...
                                'R_D_nose_x', 'R_D_nose_y', 'R_D_nose_lh', ...
                                'R_P_nose_x', 'R_P_nose_y', 'R_P_nose_lh'});
            end
            Dataset{n}.data{d}.nose = nose;
        end
    end
    % Reversal条件のデータを取得
    if ~isempty(Dataset{n}.rev_data)
        % 解析対象データのフォルダを必要に応じて変更
        data_dir_sufix = strcat(data_root_dir,'/',subject_id);
        if exist_normal
            data_dir_sufix = strcat(data_dir_sufix, 'rev');
        end        
        % 総実験日数を取得
        NumD = length(Dataset{n}.rev_data);
        % 各実験日ごとの処理
        for d = 1:NumD
            data = Dataset{n}.rev_data{d};
            day_id = data.day_id;
            data_dir = sprintf('%s/%s_%s',data_dir_sufix,subject_id,day_id);
            if ~exist(data_dir,'dir')
                data_dir = sprintf('%s/%s%s',data_dir_sufix,subject_id,day_id);
            end
            NumB = length(data.block_num_list);
            nose = cell(1,NumB);
            for b = 1:NumB
                raw_data = nan(36000,15);
                pattern = sprintf('%s/%dDLC*',data_dir,data.block_num_list(b));
                listing = dir(pattern);
                % ファイルが存在すれば読み込み
                if ~isempty(listing)
                    full_fname = strcat(listing(1).folder,'/',listing(1).name);
                    try
                        tmp_data = csvread(full_fname,3,0);
                        tmp_data = tmp_data(:,2:end);
                        raw_data(:,:) = tmp_data(:,:);
                    catch
                        disp(full_fname);
                    end
                end
                nose{b} = array2table(raw_data, 'VariableNames', ...
                                {'L_P_nose_x', 'L_P_nose_y', 'L_P_nose_lh', ...
                                'L_D_nose_x', 'L_D_nose_y', 'L_D_nose_lh', ...
                                'C_D_nose_x', 'C_D_nose_y', 'C_D_nose_lh', ...
                                'R_D_nose_x', 'R_D_nose_y', 'R_D_nose_lh', ...
                                'R_P_nose_x', 'R_P_nose_y', 'R_P_nose_lh'});
            end
            Dataset{n}.rev_data{d}.nose = nose;
        end        
    end
end

% データを格納した（これから格納する）mat file名を設定
mat_file = strcat(options.WORK_DIR,'/','raw_data_nose.mat');

% 作業用フォルダにデータを保存
if ~exist(options.WORK_DIR, 'dir')
    mkdir(options.WORK_DIR);
end
save(mat_file, 'Dataset', '-v7.3');


return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 前処理: matファイルからのデータ読み込みを試行
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% データを格納した（これから格納する）mat file名を設定
mat_file = strcat(options.WORK_DIR,'/','raw_data.mat');

if ~options.LOAD_ORG_FILE
    try
        load(mat_file,'Dataset');
        return;
    catch
        fprintf(1, 'Not found the file: %s\n', mat_file);
        fprintf(1, 'Instead loading the data from %s\n', options.DATA_DIR);
    end
end

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
save(mat_file, 'Dataset', '-v7.3');
end

