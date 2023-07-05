function [ExpertAll, ExpertGP] = extractExpertDataset(Dataset, options)
%extractExpertDataset - ToDo
%
% ToDo
%
% [����]
%�@�@ExpertAll = extractExpertDataset(Dataset, options)
%
%
% [����]
%�@�@Dataset: ToDo
%
%
% [�o��]
%   Dataset: ToDo
%�@�@�@�@�@�@�@�@
%
%=========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �萔�̎擾
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Normal������Expert�}�E�XID
% ExpertNormalSubject = [1,3,6,10];
ExpertNormalSubject = [1,2,5,9];

% Reversal������Expert�}�E�XID
ExpertRevSubject = [5,6,7];
% ExpertRevSubject = [2,6,7,8];

% �����}�E�X�̑������擾
MaxN = length(Dataset);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Expert Mouse�f�[�^�Z�b�g�̒��o
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Expert�}�E�X�f�[�^���i�[����Z���z��̗̈�m��
ExpertAll = cell(1,MaxN);

% �Z���z��̗v�f�ԍ���������
idx = 0;

% Normal������Expert�}�E�X�f�[�^�̒��o
exp_condition = 'Normal';
for n = ExpertNormalSubject
    % �����}�E�XID���擾
    subject_id = Dataset{n}.subject_id;
    % �������������擾
    NumD = length(Dataset{n}.data);
    % ���o����������}�X�N��������
    day_mask = false(1,NumD);
    for d = NumD:-1:1
        % dprime��2�ȏ�Ȃ��Expert�ɂ���
        if Dataset{n}.data{d}.dprime >= 2.5632
            day_mask(d) = true;
        end
        if sum(day_mask) >= 5
            break;
        end
    end
    % �f�[�^���擾
    data = Dataset{n}.data(day_mask);
    % �Z���z��Ƀf�[�^�i�[
    idx = idx + 1;    
    ExpertAll{idx}.subject_id = subject_id;
    ExpertAll{idx}.exp_condition = exp_condition;
    ExpertAll{idx}.data = data;
end

% Reversal������Naive�}�E�X�f�[�^�̒��o
exp_condition = 'Reversal';
for n = ExpertRevSubject
    % �����}�E�XID���擾
    subject_id = Dataset{n}.subject_id;
    % �������������擾
    NumD = length(Dataset{n}.rev_data);
    % ���o����������}�X�N��������
    day_mask = false(1,NumD);
    for d = NumD:-1:1
        % dprime��2�ȏ�Ȃ��Expert�ɂ���
        if Dataset{n}.rev_data{d}.dprime >= 2.5632
            day_mask(d) = true;
        end
        if sum(day_mask) >= 5
            break;
        end
    end
    % �f�[�^���擾
    data = Dataset{n}.rev_data(day_mask);
    % �Z���z��Ƀf�[�^�i�[
    idx = idx + 1;    
    ExpertAll{idx}.subject_id = subject_id;
    ExpertAll{idx}.exp_condition = exp_condition;
    ExpertAll{idx}.data = data;
end

ExpertAll(idx+1:end) = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Expert Mouse�f�[�^�Z�b�g����Good Performance���݂̂𒊏o����
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ExpertGP = ExpertAll;
MaxExpN = length(ExpertGP);

for n = 1:MaxExpN
    data = ExpertGP{n}.data;
    for d = 1:length(data)
       suc_mask = data{d}.suc_mask; 
       data{d}.trials = data{d}.trials(suc_mask);
       data{d}.suc_mask = data{d}.suc_mask(suc_mask);
       data{d}.hit_rate = data{d}.hit_rate(suc_mask);
       data{d}.fa_rate = data{d}.fa_rate(suc_mask);
    end
    ExpertGP{n}.data = data;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Expert Mouse�f�[�^�Z�b�g�𒆊ԃt�@�C���Ƃ��ĕۑ�����
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ��Ɨp�t�H���_�����݂��Ȃ���΍쐬����
if ~exist(options.WORK_DIR, 'dir')
    mkdir(options.WORK_DIR);
end
% �ۑ���t�@�C������ݒ肷��
mat_file = strcat(options.WORK_DIR, '/', 'expert_data.mat');
save(mat_file, 'ExpertAll', 'ExpertGP', '-v7.3');

end
