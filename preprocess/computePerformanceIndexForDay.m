function data = computePerformanceIndexForDay(data, options)
%runBehaviorAnalysisForDay ���̊֐��̊T�v�������ɋL�q
%   �ڍא����������ɋL�q


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �s����͗p�p�����[�^�̎擾
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% P-prime�v�Z����1�u���b�N������̃g���C�A����
TRIALS_PER_BLOCK = options.TRIALS_PER_BLOCK;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �e�g���C�A���̍s�����ʂ̏W�v
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% �S�g���C�A�������擾
NumTrials = length(data.trials);

% �u���b�N����ݒ�
NumBlocks = ceil(NumTrials/TRIALS_PER_BLOCK);

% �u���b�N�}�X�N��������
block_mask = true(1,NumBlocks);
% D-prime�v�Z�Ɋ܂ރg���C�A���̃}�X�N��������
dprime_mask = true(1,NumTrials);

% �e�u���b�N���Ƃ̈ȉ��̏��������s����
for b = 1:NumBlocks
    % Go trial����������
    go_cnt = 0;
    % Hit trial����������
    hit_cnt = 0;
    for h = 1:TRIALS_PER_BLOCK
        % Trial ID���v�Z
        k = (b-1)*TRIALS_PER_BLOCK + h;
        if k > NumTrials
            break;
        end
        % ���Ytrial��cue���擾
        cue = data.trials{k}.cue;
        % ���Ytrial�̌��ʂ��擾
        outcome = data.trials{k}.outcome;
        % Go trial�̏ꍇ�ɃJ�E���^�[���v�Z
        if strcmp(cue, 'Go')
            % Error�ł�Teaching�ł��Ȃ��ꍇ��Go trial�����C���N�������g
            if ~(strcmp(outcome, 'Error') || strcmp(outcome, 'Teaching'))
                go_cnt = go_cnt + 1;
            end
            % Hit�����C���N�������g
            if strcmp(outcome, 'Hit')
                hit_cnt = hit_cnt + 1;
            end
        end
    end
    % ���O�������`�F�b�N
    if go_cnt >= 1
        HR = hit_cnt/go_cnt;
        if HR <= 0.2
            block_mask(b) = false;
        end
    end
end

% D-prime�v�Z�Ɋ܂ރg���C�A���̃}�X�N
for b = 1:NumBlocks
    perform_mask = sum(block_mask(b:end)) >= 1;
    for h = 1:TRIALS_PER_BLOCK
        % Trial ID���v�Z
        k = (b-1)*TRIALS_PER_BLOCK + h;
        if k > NumTrials
            break;
        end
        dprime_mask(k) = perform_mask;
    end
end
if dprime_mask(1) == false
    dprime_mask(:) = true;
end


rslt_mat = zeros(3,4);
for k = find(dprime_mask)
    % ���Ytrial��cue���擾
    cue = data.trials{k}.cue;
    % ���Ytrial�̌��ʂ��擾
    outcome = data.trials{k}.outcome;
    if strcmp(cue, 'Go')
        if strcmp(outcome, 'Hit')
            rslt_mat(1,1) = rslt_mat(1,1) + 1;
        elseif strcmp(outcome, 'Miss')
            rslt_mat(1,2) = rslt_mat(1,2) + 1;
        elseif strcmp(outcome, 'Error')
            rslt_mat(1,3) = rslt_mat(1,3) + 1;
        end
    elseif strcmp(cue, 'No Go')
        if strcmp(outcome, 'CR')
            rslt_mat(2,2) = rslt_mat(2,2) + 1;
        elseif strcmp(outcome, 'FA')
            rslt_mat(2,1) = rslt_mat(2,1) + 1;
        elseif strcmp(outcome, 'Error')
            rslt_mat(2,3) = rslt_mat(2,3) + 1;
        end        
    elseif strcmp(cue, 'Omission')
        if strcmp(outcome, 'Lick')
            rslt_mat(3,1) = rslt_mat(3,1) + 1;            
        elseif strcmp(outcome, 'No Lick')
            rslt_mat(3,2) = rslt_mat(3,2) + 1;
        elseif strcmp(outcome, 'Error')
            rslt_mat(3,3) = rslt_mat(3,3) + 1;
        end        
    end
end

Ngo = rslt_mat(1,1)+rslt_mat(1,2);
Nhit = rslt_mat(1,1);
Nnogo = rslt_mat(2,1)+rslt_mat(2,2);
Nfa = rslt_mat(2,1);

hit_rate_total = Nhit/Ngo;
fa_rate_total = Nfa/Nnogo;

if Nhit == Ngo
    z_hr = norminv(1-1/Ngo);
elseif Nhit == 0
    z_hr = norminv(1/Ngo);
else
    z_hr = norminv(hit_rate_total);
end

if Nfa == Nnogo
    z_fa = norminv(1-1/Nnogo);
elseif Nfa == 0
    z_fa = norminv(1/Nnogo);
else
    z_fa = norminv(fa_rate_total);
end

dprime = z_hr - z_fa;

data.hit_rate_total = hit_rate_total;
data.fa_rate_total = fa_rate_total;
data.dprime = dprime;
data.dprime_mask = dprime_mask;


end

