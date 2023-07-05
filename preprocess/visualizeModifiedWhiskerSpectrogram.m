function visualizeModifiedWhiskerSpectrogram(Dataset, options, label)
%computePerformanceIndex - ToDo
%
% ToDo
%
% [書式]
%　　Dataset = computePerformanceIndex(Dataset, options)
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
FIG_DIR = options.FIG_DIR;

% 実験マウス数を取得
MaxN = length(Dataset);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Normal条件のD-primeデータをエクスポートする
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 各実験マウスに対して処理を行う
for n = 1:MaxN
    % マウスIDを取得する
    subject_id = Dataset{n}.subject_id;
    % 実験条件を取得する
    exp_condition = Dataset{n}.exp_condition;    
    % Normal条件の各実験日に対して処理を行う
    NumD = length(Dataset{n}.data);    
    for d = 1:NumD
        data = Dataset{n}.data{d};
        day_id = data.day_id;
        fig_dir = strcat(FIG_DIR, '/Profiles/', label, '/', subject_id, '/', exp_condition, '/', day_id);
        visualizeModifiedWhiskerSpectrogramForDay(data, options, fig_dir);
    end
end    


end

