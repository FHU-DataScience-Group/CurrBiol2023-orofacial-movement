function [whisker,block_num_list,teaching] = getWhiskerData(file_path)
%getWhiskerData - �w�肳�ꂽ�t�H���_���ɕۑ�����Ă���Whisker�f�[�^�t�@�C�������[�h����
%
% file_path�ɂ���Ďw�肳�ꂽ�t�H���_���ɕۑ�����Ă���Whisker�f�[�^�t�@�C�������[�h����
%
% [����]
%�@�@voltage = getWhiskerData(file_path)
%
%
% [����]
%�@�@file_path: �擾�������f�[�^���i�[����Ă���t�H���_��
%�@�@�@(��: '../data/KM3/./Day10')
%
% [�o��]
%�@�@whisker: Whisker�^���̎��n��f�[�^
%
%
%=========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Whisker�f�[�^���擾����
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

whsk_file_path = strcat(file_path,'/Whisker');
if exist(whsk_file_path,'dir')
    [whisker,block_num_list,teaching] = importWhiskerExcelData(whsk_file_path);
else
    whsk_file_path = strcat(file_path,'/����');
    if exist(whsk_file_path,'dir')
        [whisker,block_num_list,teaching] = importWhiskerTextData(whsk_file_path);
    end
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �v���C�x�[�g�֐�: Excel�t�@�C������Whisker�f�[�^���擾����
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [whisker,block_num_list,teaching] = importWhiskerExcelData(file_path)
filename = strcat(file_path, '/', 'Whisker.xlsx');
if ~exist(filename, 'file')
    whisker = [];
    return;
end
[~, sheets] = xlsfinfo(filename);
NumS = length(sheets);

whisker = cell(1,NumS);
block_num_list = nan(1,NumS);
for n = 1:NumS
    sheet_name = sheets{n};
    block_num_list(n) = str2double(sheet_name);
    whsk_mat = xlsread(filename, sheet_name);
    whisker{n} = array2table(whsk_mat(:,end), 'VariableNames', {'Whisker'});
end
% �������Ƀ\�[�g
[~,asc_idx] = sort(block_num_list,'ascend');
whisker = whisker(asc_idx);
block_num_list = block_num_list(asc_idx);
teaching = false(size(block_num_list));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �v���C�x�[�g�֐�: text�t�@�C������Whisker�f�[�^���擾����
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [whisker,block_num_list,teaching] = importWhiskerTextData(file_path)
file_list = dir(file_path);
NumS = length(file_list);
whisker = cell(1,NumS);
block_num_list = nan(1,NumS);
teaching = nan(1,NumS);

idx = 0;
for n = 1:NumS
    %startIndex = regexp(file_list(n).name,'\d\w*')
    %pause;
    if startsWith(file_list(n).name,cellstr(string(0:9))) && endsWith(file_list(n).name,'.txt')
        filename = strcat(file_path, '/', file_list(n).name);
        tokens = strtok(file_list(n).name,{',', '_','.'});
        block_num = str2double(tokens);
        idx = idx+1;
        whsk_mat = csvread(filename,1,0,[1,0,36000,0]);
        whisker{idx} = array2table(whsk_mat, 'VariableNames', {'Whisker'});
        block_num_list(idx) = block_num;
        % Teaching block���ǂ����̔���
        if isempty(strfind(file_list(n).name,'teaching'))
            fprintf(1, '%s: false\n', file_list(n).name);
            teaching(idx) = false;
        else
            fprintf(1, '%s: true\n', file_list(n).name);
            teaching(idx) = true;
        end
    end
end
% �s�v�Ȕz��̍폜
whisker(idx+1:end)=[];
block_num_list(idx+1:end)=[];
teaching(idx+1:end)=[];

% �������Ƀ\�[�g
[~,asc_idx] = sort(block_num_list,'ascend');
whisker = whisker(asc_idx);
block_num_list = block_num_list(asc_idx);
teaching = teaching(asc_idx);
end