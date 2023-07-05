function Dataset = mergeDprimeData(Dataset, options)
%mergeDprimeData - ToDo
%
% ToDo
%
% [����]
%�@�@Dataset = mergeDprimeData(Dataset, options)
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

% D-prime�f�[�^�̊i�[����w��
DPRIME_DIR = options.DPRIME_DIR;

% �����}�E�X�����擾
MaxN = length(Dataset);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Normal������Dprime�f�[�^���擾
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for n = 1:MaxN
    % �����}�E�XID���擾����
    subject_id = Dataset{n}.subject_id;
    % �ۑ���e�t�H���_��ݒ�
    prefix_dir = strcat(DPRIME_DIR, '/Normal/', subject_id);
    % Normal�����̑������������擾����
    NumD = length(Dataset{n}.data);
    % �e�������ɑ΂��ĉ�͂����s
    for d = 1:NumD
        % ��������ID���擾
        day_id = Dataset{n}.data{d}.day_id;
        % �ǂݍ��ݑΏۂ̃t�@�C������ݒ�
        filename = strcat(prefix_dir,'/',day_id,'/',day_id,'.txt');
        % D-prime�f�[�^���擾
        dprime = load(filename,'-ascii');
        % �\���̂�D-prime�f�[�^��ǉ�
        Dataset{n}.data{d}.dprime = dprime;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Reversal������Dprime�f�[�^���擾
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for n = 1:MaxN
    % �����}�E�XID���擾����
    subject_id = Dataset{n}.subject_id;
    % �ۑ���e�t�H���_��ݒ�
    prefix_dir = strcat(DPRIME_DIR, '/Reversal/', subject_id);
    % Normal�����̑������������擾����
    NumD = length(Dataset{n}.rev_data);
    % �e�������ɑ΂��ĉ�͂����s
    for d = 1:NumD
        % ��������ID���擾
        day_id = Dataset{n}.rev_data{d}.day_id;
        % �ǂݍ��ݑΏۂ̃t�@�C������ݒ�
        filename = strcat(prefix_dir,'/',day_id,'/',day_id,'.txt');
        % D-prime�f�[�^���擾
        dprime = load(filename,'-ascii');
        % �\���̂�D-prime�f�[�^��ǉ�
        Dataset{n}.rev_data{d}.dprime = dprime;
    end
end

end

