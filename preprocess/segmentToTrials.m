function Dataset = segmentToTrials(Dataset, options)
%segmentToTrials - ���f�[�^���g���C�A���P�ʂɐ؂蕪����
%
% Dataset�Ɋi�[����Ă���S�f�[�^���g���C�A���P�ʂɐ؂蕪��
% �e�g���C�A�������𓯒肷��B
%
% [����]
%�@�@Dataset = segmentToTrials(Dataset, options)
%
%
% [����]
%�@�@Dataset: ���f�[�^���i�[���Ă���\����
%
%�@�@options: ToDo
%
% [�o��]
%   data: ToDo
%
%
%=========================================================================

% �����}�E�X�����擾����
MaxN = length(Dataset);
% �e�����}�E�X�ɑ΂��Ĉȉ��̏��������s
for n = 1:MaxN
    % Normal�����ɂ��Ċe���������ƂɃg���C�A���P�ʂɐ؂蕪����
    NumD = length(Dataset{n}.data);
    for d = 1:NumD
        Dataset{n}.data{d} = segmentToTrialsForDay(Dataset{n}.data{d}, options);
    end
    % Reversal�����ɂ��Ċe���������ƂɃg���C�A���P�ʂɐ؂蕪����
    NumD = length(Dataset{n}.rev_data);
    for d = 1:NumD
        Dataset{n}.rev_data{d} = segmentToTrialsForDay(Dataset{n}.rev_data{d}, options);
    end
end

% ��Ɨp�t�H���_�����݂��Ȃ���΍쐬����
if ~exist(options.WORK_DIR, 'dir')
    mkdir(options.WORK_DIR);
end
% �ۑ���t�@�C������ݒ肷��
mat_file = strcat(options.WORK_DIR, '/', 'raw_trial_data.mat');
save(mat_file, 'Dataset', '-v7.3');
end

