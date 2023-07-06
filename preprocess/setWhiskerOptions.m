function options = setWhiskerOptions(varargin)
%setWhiskerOptions - Set the options for the analysis
%
% Set/change the options/parameters for the analysis
%
% [Format]
%   options = setWhiskerOptions(Name,value,...)
%
%
% [Inputs]
%   Specify pairs of [Name] and [value], where [Name] is the name of the
%   parameter and [value] is the corresponding value.
%   The default value of each parameter is as follows:
%
%    - 'DATA_DIR' (default: '~/rawdata')
%       to change the folder in which the raw data are stored
%
%    - 'WORK_DIR' (デフォルト値: '~/processed_data')
%       to change the folder in which you want to store the processed
%       data.
%
%　　- 'FIG_DIR' (デフォルト値: '~/figures')
%　　　　to change the folder in which you want to store the figures created by
%　　　　this program.
%
% [Example]
%   1. If you store the raw data set into "/somewhere/rawdata", please
%   change Line 22 of main.m into 
%　　　 options = setWhiskerOptions('DATA_DIR', '/somewhere/rawdata');
%
%   2. If you store the raw data set into "/somewhere/rawdata" and save the
%   files created by this program into "/somewhere/figures", please change
%   Line 22 of main.m into 
%　　　 options = setWhiskerOptions('DATA_DIR', '/somewhere/rawdata', ...
%         'FIG_DIR', '/somewhere/figures');
%
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

% 作業ファイルの格納先を指定
options.WORK_DIR = '~/processed_data';

% 作成した図の保存先を指定
options.FIG_DIR = '~/figures';

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