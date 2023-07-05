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
%    - 'WORK_DIR' (�f�t�H���g�l: '~/processed_data')
%       to change the folder in which you want to store the processed
%       data.
%
%�@�@- 'FIG_DIR' (�f�t�H���g�l: '~/figures')
%�@�@�@�@to change the folder in which you want to store the figures created by
%�@�@�@�@this program.
%
% [Example]
%   1. If you store the raw data set into "/somewhere/rawdata", please
%   change Line 22 of main.m into 
%�@�@�@ options = setWhiskerOptions('DATA_DIR', '/somewhere/rawdata');
%
%   2. If you store the raw data set into "/somewhere/rawdata" and save the
%   files created by this program into "/somewhere/figures", please change
%   Line 22 of main.m into 
%�@�@�@ options = setWhiskerOptions('DATA_DIR', '/somewhere/rawdata', ...
%         'FIG_DIR', '/somewhere/figures');
%
%=========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �f�t�H���g�p�X�ݒ�
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ��͑Ώۃf�[�^�̊i�[����w��
options.DATA_DIR = '~/rawdata';

% ��͑Ώۃf�[�^�ɑΉ�����@�^���f�[�^�̊i�[����w��
options.DATA_NOSE_DIR = strcat(options.DATA_DIR, '_nose');

% ��ƃt�@�C���̊i�[����w��
options.WORK_DIR = '~/processed_data';

% �쐬�����}�̕ۑ�����w��
options.FIG_DIR = '~/figures';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �e�����p�����[�^�̃f�t�H���g�ݒ�
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% �z�肳���1��������̍ő�g���C�A����
options.MaxTrials = 5000;

% Cue, Reward�񎦎��̓d���i�P��: V�j
options.CUE_V = 5.0;

% Lick�Z���T�[��臒l�i�P��: V�j
options.LICK_TH = 0.1;

% Whisker�f�[�^�̃T���v�����O���g���i�P��: Hz�j
options.Fs = 200;

% Tone�̒x�ꎞ�ԁi�P��: �b�j
options.TONE_DELAY_TIME = 0.19;

% Cue�񎦎��ԁi�P��: �b�j
options.CUE_DUR = 2.2 - options.TONE_DELAY_TIME;

% Reward Window���i�P��: �b�j
options.RWD_WIDTH = 1.0;

% �ŏ�ITI�i�P��: �b�j
options.MIN_ITI = 2.0;

% �g���C�A���O�ŏ��҂����ԁi�P��: �b�j
options.PRE_WAIT_DUR = 2.0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �s����̓p�����[�^�̃f�t�H���g�ݒ�
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Licking�̍ŏ������i�P��: �b�j
options.MinLickFreq = 1/15;

% �ړ����ςɂ��ۑ萬�����v�Z���̑����i�P��: �g���C�A���j
options.RATE_WINDOW_PRE = 5;
options.RATE_WINDOW_POST = 5;

% ��͑Ώۋ�Ԃ�Hit Rate��臒l�i�P��: �������ʁj
options.HIT_RATE_TH = 0.8;

% ��͑Ώۋ�Ԃ�False Alart Rate臒l�i�P��: �������ʁj
options.FA_RATE_TH = 0.2;

% P-prime�v�Z����1�u���b�N������̃g���C�A����
options.TRIALS_PER_BLOCK = 10;

% Cue�񎦋�ԉ�͎���Cue�񎦑O�\����ԁi�P��: �b�j
options.PRE_CUE_WINDOW = 0.5;

% Cue�񎦋�ԉ�͎���Cue�񎦌�\����ԁi�P��: �b�j
options.POST_CUE_WINDOW = 0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Whisking��̓p�����[�^�̃f�t�H���g�ݒ�
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% �ŏ����g�� �i�P��: Hz�j
options.MIN_FREQ = 1;

% �ŏ����g�� �i�P��: Hz�j
options.MAX_FREQ = 20;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ���s�����̓��[�`���̐ݒ�
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ���f�[�^����ǂݍ��ށitrue�j���A�ϊ��ς�mat�t�@�C������ǂݍ��ށifalse�j��
options.LOAD_ORG_FILE = false;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �o�͕ϐ��̍쐬
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ���͕ϐ����Ȃ���΃f�t�H���g�l���o�͕ϐ��Ƃ��ĕԂ�
if(isempty(varargin))
    return;
end

% ���͕ϐ�������΁A����ɉ����Đݒ�l��ύX���āA�o�͕ϐ��Ƃ��ĕԂ�
for k=1:2:length(varargin)
    fname = varargin{k};
    if(isfield(options,fname))
        value=varargin{k+1};
        options.(fname)=value;
    end
end

end