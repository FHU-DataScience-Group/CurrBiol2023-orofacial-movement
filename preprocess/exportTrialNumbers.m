function exportTrialNumbers(Dataset, options, label)
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

% �����}�E�X�����擾
MaxN = length(Dataset);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Normal������D-prime�f�[�^���G�N�X�|�[�g����
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% �e�����}�E�X�ɑ΂��ď������s��
for n = 1:MaxN
    exportTrialNumbersForSubject(Dataset{n}, options, label);
end    

end