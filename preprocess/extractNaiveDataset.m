function NaiveAll = extractNaiveDataset(Dataset, options)
%extractNaiveDataset - ToDo
%
% ToDo
%
% [����]
%�@�@NaiveDataset = extractNaiveDataset(Dataset)
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

% Normal������Naive�}�E�XID
NaiveNormalSubject = [1,2,3,8,9];
%NaiveNormalSubject = [4,9,10];

% Reversal������Naive�}�E�XID
NaiveRevSubject = [4,5,6,7];
%NaiveRevSubject = [5,6,7,8];

% �����}�E�X�̑������擾
MaxN = length(Dataset);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Naive Mouse�f�[�^�Z�b�g�̒��o
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Naive�}�E�X�f�[�^���i�[����Z���z��̗̈�m��
NaiveAll = cell(1,MaxN);

% �Z���z��̗v�f�ԍ���������
idx = 0;

% Normal������Naive�}�E�X�f�[�^�̒��o
exp_condition = 'Normal';
for n = NaiveNormalSubject
    % �����}�E�XID���擾
    subject_id = Dataset{n}.subject_id;
    % �������������擾
    NumD = length(Dataset{n}.data);
    % ���o����������}�X�N��������
    day_mask = false(1,NumD);
    for d = 1:min([3,NumD])
        % dprime��1.0�ȏ�ɂȂ�����Naive�ł͂Ȃ��Ȃ����Ɣ��f
        if Dataset{n}.data{d}.dprime > 1.0
            break;
        end
        day_mask(d) = true;
    end
    % �f�[�^���擾
    data = Dataset{n}.data(day_mask);
    % �Z���z��Ƀf�[�^�i�[
    idx = idx + 1;    
    NaiveAll{idx}.subject_id = subject_id;
    NaiveAll{idx}.exp_condition = exp_condition;
    NaiveAll{idx}.data = data;
end

% Reversal������Naive�}�E�X�f�[�^�̒��o
exp_condition = 'Reversal';
for n = NaiveRevSubject
    % �����}�E�XID���擾
    subject_id = Dataset{n}.subject_id;
    % �������������擾
    NumD = length(Dataset{n}.rev_data);
    % ���o����������}�X�N��������
    day_mask = false(1,NumD);
    for d = 1:min([3,NumD])
        % dprime��1.0�ȏ�ɂȂ�����Naive�ł͂Ȃ��Ȃ����Ɣ��f
        if Dataset{n}.rev_data{d}.dprime > 1.0
            break;
        end
        day_mask(d) = true;
    end
    % �f�[�^���擾
    data = Dataset{n}.rev_data(day_mask);
    % �Z���z��Ƀf�[�^�i�[
    idx = idx + 1;    
    NaiveAll{idx}.subject_id = subject_id;
    NaiveAll{idx}.exp_condition = exp_condition;
    NaiveAll{idx}.data = data;
end

NaiveAll(idx+1:end) = [];

% ��Ɨp�t�H���_�����݂��Ȃ���΍쐬����
if ~exist(options.WORK_DIR, 'dir')
    mkdir(options.WORK_DIR);
end
% �ۑ���t�@�C������ݒ肷��
mat_file = strcat(options.WORK_DIR, '/', 'naive_data.mat');
save(mat_file, 'NaiveAll', '-v7.3');

end
