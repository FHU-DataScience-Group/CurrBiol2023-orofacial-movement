function [whisker,block_num_list,teaching] = getWhiskerData(file_path)
%getWhiskerData - 指定されたフォルダ内に保存されているWhiskerデータファイルをロードする
%
% file_pathによって指定されたフォルダ内に保存されているWhiskerデータファイルをロードする
%
% [書式]
%　　voltage = getWhiskerData(file_path)
%
%
% [入力]
%　　file_path: 取得したいデータが格納されているフォルダ名
%　　　(例: '../data/KM3/./Day10')
%
% [出力]
%　　whisker: Whisker運動の時系列データ
%
%
%=========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Whiskerデータを取得する
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

whsk_file_path = strcat(file_path,'/Whisker');
if exist(whsk_file_path,'dir')
    [whisker,block_num_list,teaching] = importWhiskerExcelData(whsk_file_path);
else
    whsk_file_path = strcat(file_path,'/動画');
    if exist(whsk_file_path,'dir')
        [whisker,block_num_list,teaching] = importWhiskerTextData(whsk_file_path);
    end
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% プライベート関数: ExcelファイルからWhiskerデータを取得する
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [whisker,block_num_list,teaching] = importWhiskerExcelData(file_path)
filename = strcat(file_path, '/', 'Whisker.xlsx');
if ~exist(filename, 'file')
    whisker = [];
    return;
end
[~, sheets] = xlsfinfo(filename);
NumS = length(sheets);

whisker = cell(1,NumS);
block_num_list = nan(1,NumS);
for n = 1:NumS
    sheet_name = sheets{n};
    block_num_list(n) = str2double(sheet_name);
    whsk_mat = xlsread(filename, sheet_name);
    whisker{n} = array2table(whsk_mat(:,end), 'VariableNames', {'Whisker'});
end
% 実験順にソート
[~,asc_idx] = sort(block_num_list,'ascend');
whisker = whisker(asc_idx);
block_num_list = block_num_list(asc_idx);
teaching = false(size(block_num_list));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% プライベート関数: textファイルからWhiskerデータを取得する
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [whisker,block_num_list,teaching] = importWhiskerTextData(file_path)
file_list = dir(file_path);
NumS = length(file_list);
whisker = cell(1,NumS);
block_num_list = nan(1,NumS);
teaching = nan(1,NumS);

idx = 0;
for n = 1:NumS
    %startIndex = regexp(file_list(n).name,'\d\w*')
    %pause;
    if startsWith(file_list(n).name,cellstr(string(0:9))) && endsWith(file_list(n).name,'.txt')
        filename = strcat(file_path, '/', file_list(n).name);
        tokens = strtok(file_list(n).name,{',', '_','.'});
        block_num = str2double(tokens);
        idx = idx+1;
        whsk_mat = csvread(filename,1,0,[1,0,36000,0]);
        whisker{idx} = array2table(whsk_mat, 'VariableNames', {'Whisker'});
        block_num_list(idx) = block_num;
        % Teaching blockかどうかの判定
        if isempty(strfind(file_list(n).name,'teaching'))
            fprintf(1, '%s: false\n', file_list(n).name);
            teaching(idx) = false;
        else
            fprintf(1, '%s: true\n', file_list(n).name);
            teaching(idx) = true;
        end
    end
end
% 不要な配列の削除
whisker(idx+1:end)=[];
block_num_list(idx+1:end)=[];
teaching(idx+1:end)=[];

% 実験順にソート
[~,asc_idx] = sort(block_num_list,'ascend');
whisker = whisker(asc_idx);
block_num_list = block_num_list(asc_idx);
teaching = teaching(asc_idx);
end