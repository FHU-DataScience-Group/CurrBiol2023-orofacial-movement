%main - Main script for data preprocessing
%
% [Run command on the MATLAB console]
% >> main;
%
%
% [How to change/set the configurations]
%   See setWhiskerOptions.m or run the following command on the console
%   >> help setWhiskerOptions;
%  
%
%=========================================================================

%=========================================================================
%%
%
% Procedures
%
%=========================================================================

% Set the configurations
options = setWhiskerOptions;

% Load the raw data
Dataset = loadOriginalDataset(options);
Dataset = loadNoseDataset(Dataset, options);

% 生データをトライアル単位に切り分ける
Dataset = segmentToTrials(Dataset, options);

% 行動解析（タスク成功率の計算）を実行
Dataset = runBehaviorAnalysis(Dataset, options);

% D-primeデータとの統合
Dataset = computePerformanceIndex(Dataset, options);

% Expert mouseだけのデータを抽出する
[ExpertAll, ExpertGP] = extractExpertDataset(Dataset, options);

% Naive mouseだけのデータを抽出する
NaiveAll = extractNaiveDataset(Dataset, options);

return;
% 

% Expert mouseのWhisker Movementの特徴を可視化
visualizeModifiedWhiskerSpectrogram(ExpertAll, options, 'Expert');

% Naive mouseのWhisker Movementの特徴を可視化
visualizeModifiedWhiskerSpectrogram(NaiveAll, options, 'Naive');

%Dataset = runBehaviorAnalysis(Dataset, options);



% 生データをcsvファイルにエクスポート
% exportRawData(Dataset, options);

% 生データを図として可視化
%visualizeRawData(Dataset, options);



% Whisker Movementのスペクトラムを可視化
% Dataset = visualizeWhiskerSpectrogram(Dataset, options);

% Whisker Movementの基本解析を実行
%Dataset = runBasicWhiskerAnalysis(Dataset, options);

% Expert mouseデータとNaive mouseデータに分割する
[NaiveDataAll,ExpertDataAll,ExpertDataGood] = extractAnalyzedDataset(Dataset);

% Expert Mouseのスペクトログラムを可視化する
visualizeWhiskerSpectrogram(ExpertDataAll, options);


% Whisker Movementからトライアルカテゴリを予測
runTrialCategoryEstimationAnalysis(Dataset, options)

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 解析条件
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

VIS_RAW_EXEC = false;

VIS_LICK_SPEC = false;

BA_EXEC = false;

EXPORT_RAW_DATA = false;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% フォルダの指定
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 解析対象データの格納先を指定
DATA_DIR = '../data';
%DATA_DIR = '/Users/juniti-y/Dropbox/Whisker movements/Data';

% 作成した図の保存先を指定
FIG_DIR = '../figures';

% 結果の保存先を指定
%RESULT_DIR = '../results';

% 作業用フォルダの指定
WORK_DIR = '../work';

%
EXPORT_DIR = '../export';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% データファイルの読み込み
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Dataset = loadWhiskerData(DATA_DIR, WORK_DIR);
return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 各トライアルへのデータ分割処理
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Dataset = segmentToTrialsAll(Dataset);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 生データの可視化
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if VIS_RAW_EXEC
    visualizeRawDataAll(Dataset, FIG_DIR);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% リッキングのスペクトル解析
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if VIS_LICK_SPEC
    visualizeLickSpectrumAll(Dataset, FIG_DIR);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 行動解析
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if BA_EXEC
   runBehaviorAnalysisAll(Dataset, FIG_DIR); 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CSVへの出力
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if EXPORT_RAW_DATA
   exportRawDataAll(Dataset, EXPORT_DIR); 
end
