function Dataset = loadNoseDataset(Dataset, options)
%loadOriginalDataset - �����f�[�^�̓ǂݍ���
%
% options�Ŏw�肳�ꂽ�p�X��������f�[�^��ǂݍ���
%
% [����]
%
% [����]
%
% [�o��]
%
%=========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �萔�̎擾
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% �����}�E�X�̑������擾
MaxN = length(Dataset);

% ��͑Ώۃf�[�^�̊i�[����擾
data_root_dir = options.DATA_NOSE_DIR;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ���C�����[�`��: �f�[�^�̓ǂݍ���
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for n=1:MaxN
    % �����}�E�XID���擾
    subject_id = Dataset{n}.subject_id
    % Normal�����̑��݂��`�F�b�N
    exist_normal = ~isempty(Dataset{n}.data);
    % Normal�����̃f�[�^���擾
    if exist_normal
        % ��͑Ώۃf�[�^�̃t�H���_��ݒ�
        data_dir_sufix = strcat(data_root_dir,'/',subject_id);
        % �������������擾
        NumD = length(Dataset{n}.data);
        % �e���������Ƃ̏���
        for d = 1:NumD
            data = Dataset{n}.data{d};
            day_id = data.day_id;
            data_dir = sprintf('%s/%s_%s',data_dir_sufix,subject_id,day_id);
            if ~exist(data_dir,'dir')
                data_dir = sprintf('%s/%s%s',data_dir_sufix,subject_id,day_id);
            end
            NumB = length(data.block_num_list);
            nose = cell(1,NumB);
            for b = 1:NumB
                raw_data = nan(36000,15);
                pattern = sprintf('%s/%dDLC*',data_dir,data.block_num_list(b))
                listing = dir(pattern);
                % �t�@�C�������݂���Γǂݍ���
                if ~isempty(listing)
                    full_fname = strcat(listing(1).folder,'/',listing(1).name);
                    try
                        tmp_data = csvread(full_fname,3,0);
                        tmp_data = tmp_data(:,2:end);
                        raw_data(:,:) = tmp_data(:,:);
                    catch
                        disp(full_fname);
                    end
                else
                    disp(full_fname);
                end
                nose{b} = array2table(raw_data, 'VariableNames', ...
                                {'L_P_nose_x', 'L_P_nose_y', 'L_P_nose_lh', ...
                                'L_D_nose_x', 'L_D_nose_y', 'L_D_nose_lh', ...
                                'C_D_nose_x', 'C_D_nose_y', 'C_D_nose_lh', ...
                                'R_D_nose_x', 'R_D_nose_y', 'R_D_nose_lh', ...
                                'R_P_nose_x', 'R_P_nose_y', 'R_P_nose_lh'});
            end
            Dataset{n}.data{d}.nose = nose;
        end
    end
    % Reversal�����̃f�[�^���擾
    if ~isempty(Dataset{n}.rev_data)
        % ��͑Ώۃf�[�^�̃t�H���_��K�v�ɉ����ĕύX
        data_dir_sufix = strcat(data_root_dir,'/',subject_id);
        if exist_normal
            data_dir_sufix = strcat(data_dir_sufix, 'rev');
        end        
        % �������������擾
        NumD = length(Dataset{n}.rev_data);
        % �e���������Ƃ̏���
        for d = 1:NumD
            data = Dataset{n}.rev_data{d};
            day_id = data.day_id;
            data_dir = sprintf('%s/%s_%s',data_dir_sufix,subject_id,day_id);
            if ~exist(data_dir,'dir')
                data_dir = sprintf('%s/%s%s',data_dir_sufix,subject_id,day_id);
            end
            NumB = length(data.block_num_list);
            nose = cell(1,NumB);
            for b = 1:NumB
                raw_data = nan(36000,15);
                pattern = sprintf('%s/%dDLC*',data_dir,data.block_num_list(b));
                listing = dir(pattern);
                % �t�@�C�������݂���Γǂݍ���
                if ~isempty(listing)
                    full_fname = strcat(listing(1).folder,'/',listing(1).name);
                    try
                        tmp_data = csvread(full_fname,3,0);
                        tmp_data = tmp_data(:,2:end);
                        raw_data(:,:) = tmp_data(:,:);
                    catch
                        disp(full_fname);
                    end
                end
                nose{b} = array2table(raw_data, 'VariableNames', ...
                                {'L_P_nose_x', 'L_P_nose_y', 'L_P_nose_lh', ...
                                'L_D_nose_x', 'L_D_nose_y', 'L_D_nose_lh', ...
                                'C_D_nose_x', 'C_D_nose_y', 'C_D_nose_lh', ...
                                'R_D_nose_x', 'R_D_nose_y', 'R_D_nose_lh', ...
                                'R_P_nose_x', 'R_P_nose_y', 'R_P_nose_lh'});
            end
            Dataset{n}.rev_data{d}.nose = nose;
        end        
    end
end

% �f�[�^���i�[�����i���ꂩ��i�[����jmat file����ݒ�
mat_file = strcat(options.WORK_DIR,'/','raw_data_nose.mat');

% ��Ɨp�t�H���_�Ƀf�[�^��ۑ�
if ~exist(options.WORK_DIR, 'dir')
    mkdir(options.WORK_DIR);
end
save(mat_file, 'Dataset', '-v7.3');


return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �O����: mat�t�@�C������̃f�[�^�ǂݍ��݂����s
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% �f�[�^���i�[�����i���ꂩ��i�[����jmat file����ݒ�
mat_file = strcat(options.WORK_DIR,'/','raw_data.mat');

if ~options.LOAD_ORG_FILE
    try
        load(mat_file,'Dataset');
        return;
    catch
        fprintf(1, 'Not found the file: %s\n', mat_file);
        fprintf(1, 'Instead loading the data from %s\n', options.DATA_DIR);
    end
end

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
save(mat_file, 'Dataset', '-v7.3');
end

