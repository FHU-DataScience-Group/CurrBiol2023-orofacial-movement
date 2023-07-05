function visualizeModifiedWhiskerSpectrogram(Dataset, options, label)
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
%% �萔�̐ݒ�
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% �G�N�X�|�[�g��̃t�H���_�����擾
FIG_DIR = options.FIG_DIR;

% �����}�E�X�����擾
MaxN = length(Dataset);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Normal������D-prime�f�[�^���G�N�X�|�[�g����
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% �e�����}�E�X�ɑ΂��ď������s��
for n = 1:MaxN
    % �}�E�XID���擾����
    subject_id = Dataset{n}.subject_id;
    % �����������擾����
    exp_condition = Dataset{n}.exp_condition;    
    % Normal�����̊e�������ɑ΂��ď������s��
    NumD = length(Dataset{n}.data);    
    for d = 1:NumD
        data = Dataset{n}.data{d};
        day_id = data.day_id;
        fig_dir = strcat(FIG_DIR, '/Profiles/', label, '/', subject_id, '/', exp_condition, '/', day_id);
        visualizeModifiedWhiskerSpectrogramForDay(data, options, fig_dir);
    end
end    


end

