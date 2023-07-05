function cp_protraction = computeCuePeriodProtraction(t, whisk, options)
%visualizeRawData - ToDo
%
% ToDo
%
% [����]
%�@�@visualizeRawData(Dataset, options)
%
%
% [����]
%�@�@Dataset: ToDo
%
%�@�@options: ToDo
%
%
%=========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �O����
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Cue�񎦎��ԁi�P��: �b�j
CUE_DUR = options.CUE_DUR;

% ��Ԑ؂�o���̊ۂߌ덷�␳�i�P��: �b�j
T_COR = (1/options.Fs)*0.1;

% Cue�񎦑O�\����ԁi�P��: �b�j
PRE_CUE_WINDOW = options.PRE_CUE_WINDOW;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ��͑Ώۋ�ԗp�}�X�N�̍쐬
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Baseline�p��ԃ}�X�N
pre_cue_mask = (t >= -(PRE_CUE_WINDOW+T_COR)) & (t <= 0);

% Cue Period Protraction�p��ԃ}�X�N
cue_mask = (t > 0) & (t < CUE_DUR/4);

wm_base = mean(whisk(pre_cue_mask));
wm_cue = whisk(cue_mask) - wm_base;

% Cue Period Protraction���Z�o
cp_protraction = max(wm_cue);



end

