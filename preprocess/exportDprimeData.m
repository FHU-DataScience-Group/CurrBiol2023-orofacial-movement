function exportDprimeData(Dataset, options)
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
    % Normal�����̊e�������ɑ΂��ď������s��
    NumD = length(Dataset{n}.data);
    perform_data = cell(NumD,4);
    for d = 1:NumD
        data = Dataset{n}.data{d};
        perform_data{d,1} = data.day_id;
        perform_data{d,2} = data.dprime;
        perform_data{d,3} = data.hit_rate_total;
        perform_data{d,4} = data.fa_rate_total;
    end
    perform_table = cell2table(perform_data, 'VariableNames', {'Day', 'D_prime', 'Hit_rate', 'FA_rate'});
    if NumD >= 1
        save_to_dir = strcat(EXPORT_DIR, '/', Dataset{n}.subject_id, '/Normal');
        if ~exist(save_to_dir,'dir')
            mkdir(save_to_dir);
        end
        filename = strcat(save_to_dir, '/', 'performance.csv');
        writetable(perform_table, filename);   
    end
end    


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Reversal������D-prime�f�[�^���G�N�X�|�[�g����
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% �e�����}�E�X�ɑ΂��ď������s��
for n = 1:MaxN
    % Normal�����̊e�������ɑ΂��ď������s��
    NumD = length(Dataset{n}.rev_data);
    perform_data = cell(NumD,4);
    for d = 1:NumD
        data = Dataset{n}.rev_data{d};
        perform_data{d,1} = data.day_id;
        perform_data{d,2} = data.dprime;
        perform_data{d,3} = data.hit_rate_total;
        perform_data{d,4} = data.fa_rate_total;
    end
    perform_table = cell2table(perform_data, 'VariableNames', {'Day', 'D_prime', 'Hit_rate', 'FA_rate'});
    if NumD >= 1
        save_to_dir = strcat(EXPORT_DIR, '/', Dataset{n}.subject_id, '/Reversal');
        if ~exist(save_to_dir,'dir')
            mkdir(save_to_dir);
        end
        filename = strcat(save_to_dir, '/', 'performance.csv');
        writetable(perform_table, filename);   
    end
end    

end
