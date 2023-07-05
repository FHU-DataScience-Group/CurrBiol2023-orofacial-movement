function Dataset = runBehaviorAnalysis(Dataset, options)
%runBehaviorAnalysis - ToDo
%
% ToDo
%
% [����]
%�@�@runBehaviorAnalysis(Dataset, options)
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

% �쐬�����}�̕ۑ�����w��
fig_dir = options.FIG_DIR;

% �����}�E�X�����擾
MaxN = length(Dataset);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Normal�����̉�͌��ʂ��G�N�X�|�[�g
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for n = 1:MaxN
    % �����}�E�XID���擾����
    subject_id = Dataset{n}.subject_id;
    % �ۑ���e�t�H���_��ݒ�
    prefix_dir = strcat(fig_dir, '/', subject_id, '/Normal');
    % Normal�����̑������������擾����
    NumD = length(Dataset{n}.data);
    % �e�������ɑ΂��ĉ�͂����s
    for d = 1:NumD
        % ��������ID���擾
        day_id = Dataset{n}.data{d}.day_id;
        % �ۑ���t�H���_���w��
        if ~isempty(fig_dir)
            save_to_dir = strcat(prefix_dir, '/',day_id, '/behavior');
        else
            save_to_dir = [];
        end
        % ��̓��[�`�������s
        Dataset{n}.data{d} = runBehaviorAnalysisForDay(Dataset{n}.data{d}, options, save_to_dir);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Reversal�����̃f�[�^���G�N�X�|�[�g
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for n = 1:MaxN
    % �����}�E�XID���擾����
    subject_id = Dataset{n}.subject_id;
    % �ۑ���e�t�H���_��ݒ�
    prefix_dir = strcat(fig_dir, '/', subject_id, '/Reversal');
    % Reversal�����̑������������擾����
    NumD = length(Dataset{n}.rev_data);
    % �e�������ɑ΂��ĉ�͂����s
    for d = 1:NumD
        % ��������ID���擾
        day_id = Dataset{n}.rev_data{d}.day_id;
        % �ۑ���t�H���_���w��
        if ~isempty(fig_dir)
            save_to_dir = strcat(prefix_dir, '/',day_id, '/behavior');
        else
            save_to_dir = [];
        end
        % ��̓��[�`�������s
        Dataset{n}.rev_data{d} = runBehaviorAnalysisForDay(Dataset{n}.rev_data{d}, options, save_to_dir);
    end
end

% ��Ɨp�t�H���_�����݂��Ȃ���΍쐬����
if ~exist(options.WORK_DIR, 'dir')
    mkdir(options.WORK_DIR);
end
% �ۑ���t�@�C������ݒ肷��
mat_file = strcat(options.WORK_DIR, '/', 'raw_trial_behavior_data.mat');
save(mat_file, 'Dataset', '-v7.3');

end

