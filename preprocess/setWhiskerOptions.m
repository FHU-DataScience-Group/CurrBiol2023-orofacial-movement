function options = setWhiskerOptions(varargin)
%setWhiskerOptions - Set the options for the analysis
%
% Set/change the options/parameters for the analysis
%
% [Format]
%   options = setWhiskerOptions(Name,value,...)
%
% [Inputs]
%   Specify pairs of [Name] and [value], where [Name] is the name of the
%   parameter and [value] is the corresponding value.
%   The default value of each parameter is as follows:
%
%    - 'DATA_DIR' (default: '../rawdata')
%       to specify the folder in which the raw data are stored
%
%    - 'WORK_DIR' (デフォルト値: '../work')

%setWhiskerOptions - Set the options for the analysis
%
% データ解析用オプションを指定した値に変更する
%
% [書式]
%　　options = setWhiskerOptions(Name,value,...)
%
% [入力]
%　　Name,Value引数のペアをコンマ区切りで指定する。
%　　Nameは引数名で、Value は対応する値。
%　　Nameで指定できる引数は下記の通り。
%
%　　- 'DATA_DIR' (デフォルト値: '../data')
%　　　　実験データが保存されているフォルダ名
%
%　　- 'WORK_DIR' (デフォルト値: '../work')
%　　　　作業ファイルの保存先フォルダ名
%
%　　- 'FIG_DIR' (デフォルト値: '../figures')
%　　　　作成した図の保存先フォルダ名
%
%　　- 'EXPORT_DIR' (デフォルト値: '../export')
%　　　　解析データのエクスポート先フォルダ名
%
%　　- 'MaxTrials' (デフォルト値: 5000)
%　　　　想定される1日あたりの最大トライアル数（単位: 回）
%
%　　- 'CUE_V' (デフォルト値: 5.0)
%　　　　Cue, Reward提示時の電圧（単位: V）
%
%　　- 'LICK_TH' （デフォルト値: 0.1）
%　　　　ピエゾ素子によるLicking判定の閾値（単位: V）
%
%　　- 'Fs' （デフォルト値: 200）
%　　　　Whiskerデータのサンプリング周波数（単位: Hz）
%
%　　- 'Fs_V' （デフォルト値: 2000）
%　　　　電圧データのサンプリング周波数（単位: Hz）
%
%　　- 'CUE_DUR' （デフォルト値: 2.2）
%　　　　Go/No-Go Cueの提示時間（単位: 秒）
%
%　　- 'RWD_WIDTH' （デフォルト値: 1.0）
%　　　　Reward Windowの時間長（単位: 秒）
%
%　　- 'MIN_ITI' （デフォルト値: 3.0）
%　　　　最小のInter Trial Interval（単位: 秒）
%
%　　- 'PRE_WAIT_DUR' （デフォルト値: 2.0）
%　　　　トライアル前最小待ち時間（単位: 秒）
%
%　　- 'LOAD_ORG_FILE' （デフォルト値: false）
%　　　　元ファイルから実験データをロードする場合 = true
%　　　　変換済みmatファイルから実験データをロードする場合 = false
%
% [出力]
%   options: 各種オプションの設定値を格納した構造体（各配列は以下の要素を持つ）
%
% [使用例]
%　　1. 解析対象データの保存されているフォルダ名を'../new_data'、
%　　　　図の保存先フォルダ名を'../figs'に変更したい場合
%　　　　>> options = setWhiskerOptions('DATA_DIR','../new_data', 'FIG_DIR','../figs')
%=========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% デフォルトパス設定
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 解析対象データの格納先を指定
options.DATA_DIR = '~/rawdata';

% 解析対象データに対応する鼻運動データの格納先を指定
options.DATA_NOSE_DIR = strcat(options.DATA_DIR, '_nose');

% D-primeデータの格納先を指定
options.DPRIME_DIR = '~/dprime200820';

% 作業ファイルの格納先を指定
options.WORK_DIR = '~/hogehoge/processed_data';

% 作成した図の保存先を指定
options.FIG_DIR = '~/hogehoge/figures';

% 解析データのエクスポート先を指定
options.EXPORT_DIR = '../export200820';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 各実験パラメータのデフォルト設定
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 想定される1日あたりの最大トライアル数
options.MaxTrials = 5000;

% Cue, Reward提示時の電圧（単位: V）
options.CUE_V = 5.0;

% Lickセンサーの閾値（単位: V）
options.LICK_TH = 0.1;

% Whiskerデータのサンプリング周波数（単位: Hz）
options.Fs = 200;

% Toneの遅れ時間（単位: 秒）
options.TONE_DELAY_TIME = 0.19;

% Cue提示時間（単位: 秒）
options.CUE_DUR = 2.2 - options.TONE_DELAY_TIME;

% Reward Window幅（単位: 秒）
options.RWD_WIDTH = 1.0;

% 最小ITI（単位: 秒）
options.MIN_ITI = 2.0;

% トライアル前最小待ち時間（単位: 秒）
options.PRE_WAIT_DUR = 2.0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 行動解析パラメータのデフォルト設定
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Lickingの最小周期（単位: 秒）
options.MinLickFreq = 1/15;

% 移動平均による課題成功率計算時の窓幅（単位: トライアル）
options.RATE_WINDOW_PRE = 5;
options.RATE_WINDOW_POST = 5;

% 解析対象区間のHit Rateの閾値（単位: 無次元量）
options.HIT_RATE_TH = 0.8;

% 解析対象区間のFalse Alart Rate閾値（単位: 無次元量）
options.FA_RATE_TH = 0.2;

% P-prime計算時の1ブロックあたりのトライアル数
options.TRIALS_PER_BLOCK = 10;

% Cue提示区間解析時のCue提示前表示区間（単位: 秒）
options.PRE_CUE_WINDOW = 0.5;

% Cue提示区間解析時のCue提示後表示区間（単位: 秒）
options.POST_CUE_WINDOW = 0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Whisking解析パラメータのデフォルト設定
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 最小周波数 （単位: Hz）
options.MIN_FREQ = 1;

% 最小周波数 （単位: Hz）
options.MAX_FREQ = 20;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 実行する解析ルーチンの設定
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 元データから読み込む（true）か、変換済みmatファイルから読み込む（false）か
options.LOAD_ORG_FILE = false;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 出力変数の作成
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 入力変数がなければデフォルト値を出力変数として返す
if(isempty(varargin))
    return;
end

% 入力変数があれば、それに応じて設定値を変更して、出力変数として返す
for k=1:2:length(varargin)
    fname = varargin{k};
    if(isfield(options,fname))
        value=varargin{k+1};
        options.(fname)=value;
    end
end

end