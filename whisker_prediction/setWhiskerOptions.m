function options = setWhiskerOptions(varargin)
%setWhiskerOptions - �f�[�^��͗p�I�v�V�����̐ݒ�
%
% �f�[�^��͗p�I�v�V�������w�肵���l�ɕύX����
%
% [����]
%�@�@options = setWhiskerOptions(Name,value,...)
%
% [����]
%�@�@Name,Value�����̃y�A���R���}��؂�Ŏw�肷��B
%�@�@Name�͈������ŁAValue �͑Ή�����l�B
%�@�@Name�Ŏw��ł�������͉��L�̒ʂ�B
%
%�@�@- 'DATA_DIR' (�f�t�H���g�l: '../data')
%�@�@�@�@�����f�[�^���ۑ�����Ă���t�H���_��
%
%�@�@- 'WORK_DIR' (�f�t�H���g�l: '../work')
%�@�@�@�@��ƃt�@�C���̕ۑ���t�H���_��
%
%�@�@- 'FIG_DIR' (�f�t�H���g�l: '../figures')
%�@�@�@�@�쐬�����}�̕ۑ���t�H���_��
%
%�@�@- 'EXPORT_DIR' (�f�t�H���g�l: '../export')
%�@�@�@�@��̓f�[�^�̃G�N�X�|�[�g��t�H���_��
%
%�@�@- 'MaxTrials' (�f�t�H���g�l: 5000)
%�@�@�@�@�z�肳���1��������̍ő�g���C�A�����i�P��: ��j
%
%�@�@- 'CUE_V' (�f�t�H���g�l: 5.0)
%�@�@�@�@Cue, Reward�񎦎��̓d���i�P��: V�j
%
%�@�@- 'LICK_TH' �i�f�t�H���g�l: 0.1�j
%�@�@�@�@�s�G�]�f�q�ɂ��Licking�����臒l�i�P��: V�j
%
%�@�@- 'Fs' �i�f�t�H���g�l: 200�j
%�@�@�@�@Whisker�f�[�^�̃T���v�����O���g���i�P��: Hz�j
%
%�@�@- 'Fs_V' �i�f�t�H���g�l: 2000�j
%�@�@�@�@�d���f�[�^�̃T���v�����O���g���i�P��: Hz�j
%
%�@�@- 'CUE_DUR' �i�f�t�H���g�l: 2.2�j
%�@�@�@�@Go/No-Go Cue�̒񎦎��ԁi�P��: �b�j
%
%�@�@- 'RWD_WIDTH' �i�f�t�H���g�l: 1.0�j
%�@�@�@�@Reward Window�̎��Ԓ��i�P��: �b�j
%
%�@�@- 'MIN_ITI' �i�f�t�H���g�l: 3.0�j
%�@�@�@�@�ŏ���Inter Trial Interval�i�P��: �b�j
%
%�@�@- 'PRE_WAIT_DUR' �i�f�t�H���g�l: 2.0�j
%�@�@�@�@�g���C�A���O�ŏ��҂����ԁi�P��: �b�j
%
%�@�@- 'LOAD_ORG_FILE' �i�f�t�H���g�l: false�j
%�@�@�@�@���t�@�C����������f�[�^�����[�h����ꍇ = true
%�@�@�@�@�ϊ��ς�mat�t�@�C����������f�[�^�����[�h����ꍇ = false
%
% [�o��]
%   options: �e��I�v�V�����̐ݒ�l���i�[�����\���́i�e�z��͈ȉ��̗v�f�����j
%
% [�g�p��]
%�@�@1. ��͑Ώۃf�[�^�̕ۑ�����Ă���t�H���_����'../new_data'�A
%�@�@�@�@�}�̕ۑ���t�H���_����'../figs'�ɕύX�������ꍇ
%�@�@�@�@>> options = setWhiskerOptions('DATA_DIR','../new_data', 'FIG_DIR','../figs')
%=========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �f�t�H���g�p�X�ݒ�
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% �쐬�����}�̕ۑ�����w��
options.FIG_DIR = 'results/';




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


% Cue�񎦎��ԁi�P��: �b�j�O���P�b
options.CUE_DUR_1sec = 1;

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
options.LOAD_ORG_FILE = true;


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