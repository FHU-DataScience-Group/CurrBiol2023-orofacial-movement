function cp_protraction = computeCuePeriodProtraction(t, whisk, options)
%visualizeRawData - ToDo
%
% ToDo
%
% [書式]
%　　visualizeRawData(Dataset, options)
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

% Cue提示時間（単位: 秒）
CUE_DUR = options.CUE_DUR;

% 区間切り出しの丸め誤差補正（単位: 秒）
T_COR = (1/options.Fs)*0.1;

% Cue提示前表示区間（単位: 秒）
PRE_CUE_WINDOW = options.PRE_CUE_WINDOW;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 解析対象区間用マスクの作成
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Baseline用区間マスク
pre_cue_mask = (t >= -(PRE_CUE_WINDOW+T_COR)) & (t <= 0);

% Cue Period Protraction用区間マスク
cue_mask = (t > 0) & (t < CUE_DUR/4);

wm_base = mean(whisk(pre_cue_mask));
wm_cue = whisk(cue_mask) - wm_base;

% Cue Period Protractionを算出
cp_protraction = max(wm_cue);



end

