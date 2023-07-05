function data = getNormalData(data_dir, subject_id)
%getNormalData - �ʏ�w�K���̃f�[�^���擾����
%
% data_dir�Ŏw�肳�ꂽ�t�H���_����subject_id�ɑΉ�����ʏ�w�K���̃f�[�^���擾����
%
% [����]
%�@�@data = getNormalData(data_dir, subject_id)
%
%
% [����]
%�@�@data_dir: �����f�[�^���i�[����Ă���t�H���_���i������j
%
%�@�@subject_id: �����}�E�X��ID�i������j
%
% [�o��]
%   data: �����f�[�^���i�[�����\���̔z��i�e�v�f�͈ȉ��̒ʂ�j
%�@�@�@|
%�@�@�@|- day_id: ��������ID�i������j
%�@�@�@�@�@�@�@�@
%
%=========================================================================

% �������̃��X�g�Ƃ��̐e�t�H���_�����擾����
[list_days, work_dir] = getDayList(data_dir, subject_id);
% ��͑Ώۂ̎����������擾
NumD = length(list_days);
% �f�[�^�i�[�p�Z���z��𐶐�
data = cell(1, NumD);
% �e�������̃f�[�^���擾����
for n = 1:NumD
    % �e�������̃t�H���_�����擾
    day_dir = list_days{n};
    % �t�H���_������]���ȕ�������폜���A������id�Ƃ���
    substr = extractAfter(day_dir, 'Day');
    tokens = strsplit(substr,'(');
    day_id = strcat('Day',erase(tokens{1},'N'));
    % �t�@�C���ǂݍ��݂̂��߂̃p�X���擾
    file_path = strcat(work_dir,'/',day_dir);
    % Whisker�f�[�^���擾
    [whisker,block_num_list,teaching] = getWhiskerData(file_path);
    % �d���f�[�^���擾
    [voltage, block_mask] = getVoltageData(file_path, block_num_list);
    
    data{n}.day_id = day_id;
    data{n}.file_path = file_path;
    data{n}.voltage = voltage(block_mask);
    data{n}.whisker = whisker(block_mask);
    data{n}.block_num_list = block_num_list(block_mask);
    data{n}.teaching = teaching;
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �v���C�x�[�g�֐�: �������̃��X�g�Ƃ��̐e�t�H���_�����擾����
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [list_days, work_dir] = getDayList(data_dir, subject_id)
% �t�H���_�̃��X�g���擾����
folders = dir(strcat(data_dir, '/', subject_id));
% �t�H���_�����擾����
MaxSF = length(folders);

% �f�[�^���T�u�t�H���_�ɑ��݂��邩���`�F�b�N
subfolder = '.';
for n = 1:MaxSF
    if contains(folders(n).name,'�w�K')
        subfolder = 'Normal�w�K';
        break;
    end
end

% ���������X�g���i�[����Ă���e�t�H���_���擾����
work_dir = strcat(data_dir, '/', subject_id, '/', subfolder);

% ���������X�g���擾����
folders = dir(work_dir);
% �t�H���_�����擾����
MaxSF = length(folders);

% ���������X�g���i�[����Z���z�������������
list_days = cell(1, MaxSF);

% ���������X�g���擾����
idx = 0;
for n = 1:MaxSF
    folder_name = folders(n).name;
    if contains(folder_name, 'Day')
        idx = idx+1;
        list_days{idx} = folder_name;
    end
end
list_days(idx+1:end) = [];

% ���������Ƀ\�[�g����
days = str2double(extractAfter(list_days, 'Day'));
[~, d_idx] = sort(days, 'ascend');
list_days = list_days(d_idx);
end