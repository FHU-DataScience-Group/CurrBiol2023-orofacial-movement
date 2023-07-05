function [voltage, block_mask] = getVoltageData(file_path, block_num_list)
%getVoltageData - 指定されたフォルダ内に保存されている電圧データファイルをロードする
%
% file_pathによって指定されたフォルダ内に保存されている電圧データファイルをロードする
%
% [書式]
%　　voltage = getVoltageData(file_path)
%
%
% [入力]
%　　file_path: 取得したい実験日のデータが格納されているフォルダ名
%
% [出力]
%　　voltage: 実験データを格納した構造体配列（各要素は以下の通り）
%　　　|
%　　　|- day_id: 実験日のID（文字列）
%
%
%=========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 電圧データを取得する
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

vol_file_path = strcat(file_path,'/Voltage');
if exist(vol_file_path,'dir')
    [voltage, block_mask] = importVoltageCsvData(vol_file_path, block_num_list);
else
    vol_file_path = strcat(file_path,'/電圧');
    if exist(vol_file_path,'dir')
        [voltage, block_mask] = importVoltageCsvData(vol_file_path, block_num_list);
    else
        error('Invalid data structure');
    end
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% プライベート関数: csvファイルから電圧データを取得する
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [voltage, block_mask] = importVoltageCsvData(file_path, block_num_list)

NumS = length(block_num_list);
voltage = cell(1,NumS);
block_mask = false(1,NumS);
for n = 1:NumS
    fname = sprintf('data%d.csv',block_num_list(n));
    full_fname = strcat(file_path,'/',fname);
    raw_data = [];
    if exist(full_fname,'file')
        try
            raw_data = csvread(full_fname);
        catch
            raw_data = csvread(full_fname,1,1);
        end
    else
        pattern = sprintf('*_%05d.csv',block_num_list(n));
        finfo = dir(strcat(file_path,'/',pattern));
        if ~isempty(finfo)
            full_fname = strcat(file_path,'/',finfo(1).name);
            try
                raw_data = csvread(full_fname);
            catch
                raw_data = csvread(full_fname,1,1);
                
            end
            raw_data = raw_data(:,1:5);
        else
            pattern = sprintf('*_%05d.mat',block_num_list(n));
            finfo = dir(strcat(file_path,'/',pattern));
            if ~isempty(finfo)
                full_fname = strcat(file_path,'/',finfo(1).name);
                tmp=load(full_fname);
                raw_data = tmp.RCRE(:,1:5);
            end
        end
    end
    if ~isempty(raw_data)
        voltage{n} = array2table(raw_data, 'VariableNames', {'Go', 'Lick', 'Rwd', 'No_Go', 'R_Omit'});
        block_mask(n) = true;
    end
end
end
