function Dataset = computePerformanceIndex(Dataset, options)
%computePerformanceIndex - ToDo
%
% ToDo
%
% [����]
%�@�@Dataset = computePerformanceIndex(Dataset, options)
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

% �����}�E�X�����擾
MaxN = length(Dataset);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Normal�����̉�͌��ʂ��G�N�X�|�[�g
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for n = 1:MaxN
    % Normal�����̑������������擾����
    NumD = length(Dataset{n}.data);
    % �e�������ɑ΂��ĉ�͂����s
    for d = 1:NumD
        % ��̓��[�`�������s
        Dataset{n}.data{d} = computePerformanceIndexForDay(Dataset{n}.data{d}, options);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Reversal�����̃f�[�^���G�N�X�|�[�g
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for n = 1:MaxN
    % Reversal�����̑������������擾����
    NumD = length(Dataset{n}.rev_data);
    % �e�������ɑ΂��ĉ�͂����s
    for d = 1:NumD
        % ��̓��[�`�������s
        Dataset{n}.rev_data{d} = computePerformanceIndexForDay(Dataset{n}.rev_data{d}, options);
    end
end

% ��Ɨp�t�H���_�����݂��Ȃ���΍쐬����
if ~exist(options.WORK_DIR, 'dir')
    mkdir(options.WORK_DIR);
end
% �ۑ���t�@�C������ݒ肷��
mat_file = strcat(options.WORK_DIR, '/', 'raw_trial_behavior_dprime_data.mat');
save(mat_file, 'Dataset', '-v7.3');

end

