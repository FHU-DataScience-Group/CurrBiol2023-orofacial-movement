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

% ���f�[�^���g���C�A���P�ʂɐ؂蕪����
Dataset = segmentToTrials(Dataset, options);

% �s����́i�^�X�N�������̌v�Z�j�����s
Dataset = runBehaviorAnalysis(Dataset, options);

% D-prime�f�[�^�Ƃ̓���
Dataset = computePerformanceIndex(Dataset, options);

% Expert mouse�����̃f�[�^�𒊏o����
[ExpertAll, ExpertGP] = extractExpertDataset(Dataset, options);

% Naive mouse�����̃f�[�^�𒊏o����
NaiveAll = extractNaiveDataset(Dataset, options);

return;
% 

% Expert mouse��Whisker Movement�̓���������
visualizeModifiedWhiskerSpectrogram(ExpertAll, options, 'Expert');

% Naive mouse��Whisker Movement�̓���������
visualizeModifiedWhiskerSpectrogram(NaiveAll, options, 'Naive');

%Dataset = runBehaviorAnalysis(Dataset, options);



% ���f�[�^��csv�t�@�C���ɃG�N�X�|�[�g
% exportRawData(Dataset, options);

% ���f�[�^��}�Ƃ��ĉ���
%visualizeRawData(Dataset, options);



% Whisker Movement�̃X�y�N�g����������
% Dataset = visualizeWhiskerSpectrogram(Dataset, options);

% Whisker Movement�̊�{��͂����s
%Dataset = runBasicWhiskerAnalysis(Dataset, options);

% Expert mouse�f�[�^��Naive mouse�f�[�^�ɕ�������
[NaiveDataAll,ExpertDataAll,ExpertDataGood] = extractAnalyzedDataset(Dataset);

% Expert Mouse�̃X�y�N�g���O��������������
visualizeWhiskerSpectrogram(ExpertDataAll, options);


% Whisker Movement����g���C�A���J�e�S����\��
runTrialCategoryEstimationAnalysis(Dataset, options)

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ��͏���
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

VIS_RAW_EXEC = false;

VIS_LICK_SPEC = false;

BA_EXEC = false;

EXPORT_RAW_DATA = false;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �t�H���_�̎w��
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ��͑Ώۃf�[�^�̊i�[����w��
DATA_DIR = '../data';
%DATA_DIR = '/Users/juniti-y/Dropbox/Whisker movements/Data';

% �쐬�����}�̕ۑ�����w��
FIG_DIR = '../figures';

% ���ʂ̕ۑ�����w��
%RESULT_DIR = '../results';

% ��Ɨp�t�H���_�̎w��
WORK_DIR = '../work';

%
EXPORT_DIR = '../export';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �f�[�^�t�@�C���̓ǂݍ���
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Dataset = loadWhiskerData(DATA_DIR, WORK_DIR);
return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �e�g���C�A���ւ̃f�[�^��������
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Dataset = segmentToTrialsAll(Dataset);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ���f�[�^�̉���
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if VIS_RAW_EXEC
    visualizeRawDataAll(Dataset, FIG_DIR);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ���b�L���O�̃X�y�N�g�����
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if VIS_LICK_SPEC
    visualizeLickSpectrumAll(Dataset, FIG_DIR);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �s�����
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if BA_EXEC
   runBehaviorAnalysisAll(Dataset, FIG_DIR); 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CSV�ւ̏o��
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if EXPORT_RAW_DATA
   exportRawDataAll(Dataset, EXPORT_DIR); 
end
