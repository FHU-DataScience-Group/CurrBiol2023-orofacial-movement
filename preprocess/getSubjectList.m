function list_subjects = getSubjectList(data_dir)
%getSubjectList - �����f�[�^�̓ǂݍ���
%
% data_dir�ɕۑ�����Ă�������f�[�^��������}�E�X���X�g���擾����
%
% [����]
%�@�@list_subjects = getSubjectList(data_dir)
%
%
% [����]
%�@�@data_dir: �����f�[�^���i�[����Ă���t�H���_���i������j
%
% [�o��]
%   list_subjects: �����}�E�X���X�g���i�[�����Z���z��
%
%=========================================================================


subfolders = dir(data_dir);
MaxSF = length(subfolders);
list_subjects = cell(1, MaxSF);
idx = 0;
for n = 1:MaxSF
    folder_name = subfolders(n).name;
    if ~startsWith(folder_name, '.') && subfolders(n).isdir
        idx = idx+1;
        list_subjects{idx} = folder_name;
    end
end
list_subjects(idx+1:end) = [];
end