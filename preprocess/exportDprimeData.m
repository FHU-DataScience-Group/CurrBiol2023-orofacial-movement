function exportDprimeData(Dataset, options)
%exportDprimeData - 各実験日のデータをcsv形式にエクスポート
%
% ToDo
%
% [書式]
%　　exportDprimeData(Dataset, options)
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
%% 定数の設定
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% エクスポート先のフォルダ名を取得
EXPORT_DIR = options.EXPORT_DIR;

% 実験マウス数を取得
MaxN = length(Dataset);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Normal条件のD-primeデータをエクスポートする
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 各実験マウスに対して処理を行う
for n = 1:MaxN
    % Normal条件の各実験日に対して処理を行う
    NumD = length(Dataset{n}.data);
    perform_data = cell(NumD,4);
    for d = 1:NumD
        data = Dataset{n}.data{d};
        perform_data{d,1} = data.day_id;
        perform_data{d,2} = data.dprime;
        perform_data{d,3} = data.hit_rate_total;
        perform_data{d,4} = data.fa_rate_total;
    end
    perform_table = cell2table(perform_data, 'VariableNames', {'Day', 'D_prime', 'Hit_rate', 'FA_rate'});
    if NumD >= 1
        save_to_dir = strcat(EXPORT_DIR, '/', Dataset{n}.subject_id, '/Normal');
        if ~exist(save_to_dir,'dir')
            mkdir(save_to_dir);
        end
        filename = strcat(save_to_dir, '/', 'performance.csv');
        writetable(perform_table, filename);   
    end
end    


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Reversal条件のD-primeデータをエクスポートする
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 各実験マウスに対して処理を行う
for n = 1:MaxN
    % Normal条件の各実験日に対して処理を行う
    NumD = length(Dataset{n}.rev_data);
    perform_data = cell(NumD,4);
    for d = 1:NumD
        data = Dataset{n}.rev_data{d};
        perform_data{d,1} = data.day_id;
        perform_data{d,2} = data.dprime;
        perform_data{d,3} = data.hit_rate_total;
        perform_data{d,4} = data.fa_rate_total;
    end
    perform_table = cell2table(perform_data, 'VariableNames', {'Day', 'D_prime', 'Hit_rate', 'FA_rate'});
    if NumD >= 1
        save_to_dir = strcat(EXPORT_DIR, '/', Dataset{n}.subject_id, '/Reversal');
        if ~exist(save_to_dir,'dir')
            mkdir(save_to_dir);
        end
        filename = strcat(save_to_dir, '/', 'performance.csv');
        writetable(perform_table, filename);   
    end
end    

end
