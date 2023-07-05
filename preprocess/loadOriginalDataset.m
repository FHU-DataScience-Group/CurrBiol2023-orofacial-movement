function Dataset = loadOriginalDataset(options)
%loadOriginalDataset - �����f�[�^�̓ǂݍ���
%
% options�Ŏw�肳�ꂽ�p�X��������f�[�^��ǂݍ���
%
% [����]
%�@�@Dataset = loadOriginalDataset(options)
%
%
% [����]
%�@�@options: setWhiskerOptions�֐��Ő������ꂽ�\����
%�@�@�@�@�@�@�@�i�ڍׂ�setWhiskerOptions���Q�Ɓj
%
% [�o��]
%   Dataset: �����f�[�^���i�[�����\���̔z��i�e�v�f�͈ȉ��̒ʂ�j
%�@�@�@|
%�@�@�@|- subject_id: �����}�E�X��ID�i������j
%
%
%=========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �O����: mat�t�@�C������̃f�[�^�ǂݍ��݂����s
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % �f�[�^���i�[�����i���ꂩ��i�[����jmat file����ݒ�
mat_file = strcat(options.WORK_DIR,'/','raw_data.mat');
% 
% if ~options.LOAD_ORG_FILE
%     try
%         load(mat_file,'Dataset');
%         return;
%     catch
%         fprintf(1, 'Not found the file: %s\n', mat_file);
%         fprintf(1, 'Instead loading the data from %s\n', options.DATA_DIR);
%     end
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ���C�����[�`��: �f�[�^�̓ǂݍ���
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ��͑Ώۃf�[�^�̊i�[����擾
data_dir = options.DATA_DIR;

% �����}�E�X���̃��X�g���擾����
list_subjects = getSubjectList(data_dir);

% �����}�E�X�����擾����
NumS = length(list_subjects);
% �ǂݍ��񂾃f�[�^���i�[����Z���z���p�ӂ���
Dataset = cell(1,NumS);

% �e�����}�E�X�̃f�[�^��ǂݍ���
for n = 1:NumS
    subject_id = list_subjects{n};
    fprintf(1,'Now loading data for subject: %s\n', subject_id);
    Dataset{n}.subject_id = subject_id;
    Dataset{n}.data = getNormalData(data_dir, subject_id);
    Dataset{n}.rev_data = getReversalData(data_dir, subject_id);
end

% ��Ɨp�t�H���_�Ƀf�[�^��ۑ�
if ~exist(options.WORK_DIR, 'dir')
    mkdir(options.WORK_DIR);
end
mat_file = strcat(options.WORK_DIR,'/','raw_data.mat');
save(mat_file, 'Dataset', '-v7.3');
end

