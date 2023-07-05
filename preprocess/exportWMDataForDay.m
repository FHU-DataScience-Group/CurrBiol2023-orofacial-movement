function exportWMDataForDay(data, export_dir)
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
%% Whisker�f�[�^���G�N�X�|�[�g����
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ���������擾����
day_id = data.day_id;

% �o�͐�t�H���_��ݒ肷��
save_to_dir = [];
if ~isempty(export_dir)
    save_to_dir = strcat(export_dir, '/', day_id);
    if ~exist(save_to_dir, 'dir')
        mkdir(save_to_dir);
    end
end

% �g���C�A���񐔂��擾����
NumTrials = length(data.trials);

% �e�g���C�A���ɑ΂��ăf�[�^���G�N�X�|�[�g����
for k = 1:NumTrials
    trial = data.trials{k};
    if ~isempty(save_to_dir)
        % �t�@�C������ݒ�
        filename = sprintf('%s/trial%03d.csv', save_to_dir, trial.trial_id);
        writetable(trial.values(:,[1,end]), filename);   
    end    
end
end    
