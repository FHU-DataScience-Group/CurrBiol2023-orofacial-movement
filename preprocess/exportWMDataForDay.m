function exportWMDataForDay(data, export_dir)
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
%% Whiskerデータをエクスポートする
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 実験日を取得する
day_id = data.day_id;

% 出力先フォルダを設定する
save_to_dir = [];
if ~isempty(export_dir)
    save_to_dir = strcat(export_dir, '/', day_id);
    if ~exist(save_to_dir, 'dir')
        mkdir(save_to_dir);
    end
end

% トライアル回数を取得する
NumTrials = length(data.trials);

% 各トライアルに対してデータをエクスポートする
for k = 1:NumTrials
    trial = data.trials{k};
    if ~isempty(save_to_dir)
        % ファイル名を設定
        filename = sprintf('%s/trial%03d.csv', save_to_dir, trial.trial_id);
        writetable(trial.values(:,[1,end]), filename);   
    end    
end
end    
