function exportWMData(Dataset, options, label)
%exportDprimeData - �e�������̃f�[�^��csv�`���ɃG�N�X�|�[�g
%
% ToDo
%
% [����]
%�@�@exportDprimeData(Dataset, options)
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
EXPORT_DIR = options.EXPORT_DIR;

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
        export_dir = strcat(EXPORT_DIR, '/', label, '/', subject_id, '/', exp_condition);
        exportWMDataForDay(data, export_dir);
    end
end    

end
