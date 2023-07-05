function exportTrialNumbersForSubject(SubjectData, options, label)
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
%% Subject情報とData情報に切り分ける
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subject_id = SubjectData.subject_id;
exp_condition = SubjectData.exp_condition;
data = SubjectData.data;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% フォルダ作成およびPDFレポートファイルの作成
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~isempty(options.FIG_DIR)
    save_to_dir = strcat(options.EXPORT_DIR, '/TrialNumbers/', label);
    if ~exist(save_to_dir, 'dir')
        mkdir(save_to_dir);
    end
else
    save_to_dir = [];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 各トライアルの集計
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

stats = zeros(2,7);
for d = 1:length(data)
    trials = data{d}.trials;
    for k = 1:length(trials)
        if strcmp(trials{k}.outcome, 'Hit')
            stats(1,1) = stats(1,1)+1;
        elseif strcmp(trials{k}.outcome, 'Miss')
            stats(1,2) = stats(1,2)+1;
        elseif strcmp(trials{k}.outcome, 'FA')
            stats(1,3) = stats(1,3)+1;
        elseif strcmp(trials{k}.outcome, 'CR')
            stats(1,4) = stats(1,4)+1;
        elseif strcmp(trials{k}.outcome, 'Lick')
            stats(1,5) = stats(1,5)+1;
        elseif strcmp(trials{k}.outcome, 'No Lick')
            stats(1,6) = stats(1,6)+1;
        end
    end
end
stats(1,7) = sum(stats(1,1:6));
stats(2,:) = stats(1,:)/stats(1,7);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% テーブル形式に変換する
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

stats_table = array2table(stats, 'VariableNames', {'Hit', 'Miss', 'FA', 'CR', 'OH', 'OM', 'Total'}, 'RowNames', {'Count', 'Probability'});


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% データをエクスポートする
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

filename = sprintf('%s/%s_%s.csv', save_to_dir, subject_id, exp_condition);
writetable(stats_table, filename, 'WriteRowNames', true, 'WriteVariableNames', true);
end
