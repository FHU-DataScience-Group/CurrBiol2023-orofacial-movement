function data = segmentToTrialsForDay(data, options)
%segmentToTrialsForDay - �e�������̐��f�[�^���g���C�A���P�ʂɐ؂蕪����
%
% data���Ɋi�[����Ă���f�[�^�����ƂɃg���C�A���P�ʂɐ؂蕪��
% �e�g���C�A�������𓯒肷��B
%
% [����]
%�@�@data = segmentToTrialsForDay(data, options)
%
%
% [����]
%�@�@data: �d���f�[�^��Whisking�f�[�^���i�[���Ă���\���̔z��
%
%�@�@options: ToDo
%
% [�o��]
%   data: ToDo
%�@�@�@�@�@�@�@�@
%
%=========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �萔�̐ݒ�
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Cue, Reward�񎦎��̓d���i�P��: V�j
CUE_V = options.CUE_V;

% Lick�Z���T�[��臒l�i�P��: V�j
LICK_TH = options.LICK_TH;

% Whisker�f�[�^�̃T���v�����O���g���i�P��: Hz�j
Fs = options.Fs;

% Tone�̒x�ꎞ�ԁi�P��: �b�j
TONE_DELAY_TIME = options.TONE_DELAY_TIME;

% Cue�񎦎��ԁi�P��: �b�j
CUE_DUR = options.CUE_DUR;

% Reward Window���i�P��: �b�j
RWD_WIDTH = options.RWD_WIDTH;

% �ŏ�ITI�i�P��: �b�j
MIN_ITI = options.MIN_ITI;

% �g���C�A���O�ŏ��҂����ԁi�P��: �b�j
PRE_WAIT_DUR = options.PRE_WAIT_DUR;

% �z�肳���1��������̍ő�g���C�A����
MaxNumTrials = options.MaxTrials;

% Licking�̍ŏ������i�P��: �b�j
MinLickFreq = options.MinLickFreq;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �e�g���C�A���ւ̐؂蕪��
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% �e�g���C�A���̌��ʂ��i�[����Z���z����쐬����
trials = cell(1,MaxNumTrials);

% data���Ɋi�[����Ă���Z�N�V���������擾����
NumS = length(data.voltage);

% trials�ɑ������z��ԍ��̏�����
idx = 0;
for n = 1:NumS
    % Teaching session���������ۂ���mask���擾
    teaching = data.teaching(n);
    % �d���f�[�^���擾����
    voltage = data.voltage{n};
    % Whisker�f�[�^���擾����
    whisker = data.whisker{n};
    % nose�f�[�^���擾����
    nose = data.nose{n};
    % �d���f�[�^���_�E���T���v�����O����
    mva_width = size(voltage,1)/size(whisker,1);    
    vol_mva = movmean(voltage{:,:}, [mva_width/2, mva_width/2], 1, 'omitnan');
    vol_mat = vol_mva(mva_width/2:mva_width:end,:);
    voltage = array2table(vol_mat, 'VariableNames', voltage.Properties.VariableNames);
    
    % ���n�񒷂��擾����
    MaxRows = size(whisker,1);
    % �^�C���X�^���v���쐬����
    t=(1/Fs)*(1:MaxRows)';
    
    % �e�����Ŋecue��ON/OFF�𔻒肷��
    go_cue = voltage.Go > CUE_V/2;
    nogo_cue = voltage.No_Go > CUE_V/2;
    romit_cue = voltage.R_Omit > CUE_V/2;
    cue = go_cue | nogo_cue | romit_cue;    
    rwd = voltage.Rwd > CUE_V/2;
    
    % ���b�L���O�̃f�[�^���擾����
    lick = voltage.Lick;
    
    % ���b�N�^�C�~���O���m�i�V�o�[�W�����j
    % ���x���L�ӂɑ傫�Ȏ��������o
    dif_lick = [abs(diff(lick));0];
    on_lick = isoutlier(dif_lick, 'median', 1, 'ThresholdFactor', 5);
    on_lick_idx1 = find(on_lick == 1);
    % ���o���ꂽ�������A�����Ă�����̂͌�ɑ����n�������
    t_lick = t(on_lick_idx1);
    dt1_lick = [inf; diff(t_lick)];
    on_lick_idx1(dt1_lick < MinLickFreq) = [];
    t_lick = t(on_lick_idx1);
    % ���������n�񂩂�s�[�N�_�����m����
    lick_filt = movmean(lick,3);
    [~,peak_idx] = findpeaks(abs(lick_filt), 'MinPeakHeight', LICK_TH/2);
    % �s�[�N�_���ȑO�̃s�[�N�_����MinPeakDist�b�ȓ��ɏo�������Ƃ���Lick�̑Ώۂ���O��
    t_peak = t(peak_idx);
    peak_locs = nan(size(peak_idx));
    prev_t_peak = -inf;
    cnt = 0;
    for h = 1:length(peak_idx)
        if t_peak(h) - prev_t_peak > MinLickFreq
            prev_t_peak = t_peak(h);
            cnt = cnt + 1;
            peak_locs(cnt) = peak_idx(h);
        end
    end
    peak_locs(cnt+1:end) = [];
    % �s�[�N�_���O��Lick�����o����Ă��Ȃ��ꍇ�́A�����x�ő�_��Lick�^�C�~���O�Ƃ���
    cnt = 0;
    on_lick_idx2 = nan(size(peak_locs));
    for h = 1:length(peak_locs)
        loc = peak_locs(h);
        if sum((t_lick >= t(loc) - MinLickFreq) & (t_lick < t(loc)+ MinLickFreq)) == 0
            candidate_idx = find((t >= t(loc) - MinLickFreq) & (t < t(loc)));
            accel_lick = diff(diff(lick(candidate_idx)));
            [~,ptr] = max(abs(accel_lick));
            if ~isempty(ptr)
                cnt = cnt + 1;
                on_lick_idx2(cnt) = candidate_idx(ptr);
            end
        end
    end
    on_lick_idx2(cnt+1:end) = [];
    % ���o���ꂽ�������A�����Ă�����̂͌�ɑ����n�������
    t_lick2 = t(on_lick_idx2);
    dt2_lick = [inf; diff(t_lick2)];
    on_lick_idx2(dt2_lick < MinLickFreq) = [];
        
    on_lick(:) = 0;
    on_lick(on_lick_idx1) = 1;
    on_lick(on_lick_idx2) = 1;

    
%     % ���b�L���O�^�C�~���O�����m����
%     dif_lick = [abs(diff(lick));0];
%     on_lick = isoutlier(dif_lick, 'median', 1, 'ThresholdFactor', 5);
%     on_lick_idx = find(on_lick == 1);
%     t_lick = t(on_lick_idx);
%     dt1_lick = [inf; diff(t_lick)];
%     on_lick_idx(dt1_lick < 0.05) = [];
%     on_lick(:) = 0;
%     on_lick(on_lick_idx) = 1;

    % �e�g���C�A���ɂ�����cue��onset�^�C�~���O�𓯒肷��
    idx_cue_timing = find(diff([nan; cue]) == 1);
    % �z�肵����ITI���Z���Ԋu��cue��onset�Ɣ��肳��Ă��܂������̂͏��O����
    idx_cue_mask = diff([-inf; t(idx_cue_timing)]) > (TONE_DELAY_TIME + CUE_DUR + RWD_WIDTH + PRE_WAIT_DUR); 
    idx_cue_timing = idx_cue_timing(idx_cue_mask);
    idx_cue_mask = idx_cue_timing > Fs * PRE_WAIT_DUR;
    idx_cue_timing = idx_cue_timing(idx_cue_mask);
    % �e�g���C�A���ɐ؂�o���Ă���
    NumCues = length(idx_cue_timing);
    for k = 1:NumCues
        % ���g���C�A���̊J�n�����ƏI�������̎��n��C���f�N�X���擾����
        idx_cue_onset = idx_cue_timing(k);
        idx_cue_offset = idx_cue_onset + round(Fs * (TONE_DELAY_TIME +CUE_DUR));
        idx_rwd_onset = idx_cue_offset;
        idx_rwd_offset = idx_rwd_onset + round(Fs * RWD_WIDTH);
        idx_start = idx_cue_onset - round(Fs * (PRE_WAIT_DUR-TONE_DELAY_TIME));
        idx_end = idx_rwd_offset + round(Fs * MIN_ITI);
        % �I���������z�肵����ITI���Z����Ή�͑ΏۂɊ܂߂��I��
        if(idx_end > MaxRows)
            break;
        end
        % ��͂ɕK�v�Ȋ��Ԃ������f�[�^�Ƃ��Đ؂�o��
        idx_trial = idx_start:idx_end;
        tps = t(idx_trial)-(t(idx_cue_onset)+TONE_DELAY_TIME);
        t_table = array2table(tps, 'VariableNames', {'Time'});
        values = horzcat(t_table,voltage(idx_trial,:), whisker(idx_trial,:), nose(idx_trial,:));
        
        % Reward Window���ł�lick�Z���T�̍ő�l���擾����
        max_lick = max(abs(lick(idx_rwd_onset:idx_rwd_offset)));
        % Licking timing�𓾂�
        lick_timing_mask = on_lick(idx_trial);
        lick_timing = tps(lick_timing_mask);% t_lick - t(idx_cue_onset);
        
        % �e�g���C�A���̏����𓯒肷��
        if go_cue(idx_cue_onset)
            cue = 'Go';            
            if max_lick >= LICK_TH
                if sum(rwd(idx_trial)) >= 1
                    outcome = 'Hit';
                else
                    outcome = 'Error';
                end
            else
                if sum(rwd(idx_trial)) >= 1
                    outcome = 'Error';
                else
                    outcome = 'Miss';
                end
            end
        elseif nogo_cue(idx_cue_onset)
            cue = 'No Go';            
            if max_lick >= LICK_TH
                outcome = 'FA';
            else
                outcome = 'CR';
            end
        elseif romit_cue(idx_cue_onset)
            cue = 'Omission';
            if max_lick >= LICK_TH
                outcome = 'Lick';
            else
                outcome = 'No Lick';
            end
        else
            cue = 'Unknown';
            outcome = 'Unknown';
        end
        mask_pre_wait_dur = idx_cue_onset-(Fs*PRE_WAIT_DUR):idx_cue_onset-1;
        max_pre_wait_lick = max(abs(lick(mask_pre_wait_dur)));
        if max_pre_wait_lick > LICK_TH
            outcome = 'Error';
        end
        if teaching
            outcome = 'Teaching';
        end
                
        idx = idx + 1;
        trials{idx}.trial_id = idx;
        trials{idx}.cue = cue;
        trials{idx}.outcome = outcome;
        trials{idx}.max_lick = max_lick;
        trials{idx}.lick_timing = lick_timing;
        trials{idx}.values = values;
        trials{idx}.teaching = teaching;
    end
    
end

trials(idx+1:end) = [];
data.trials = trials;
data = rmfield(data,'voltage');
data = rmfield(data,'whisker');
data = rmfield(data,'nose');
data = rmfield(data,'block_num_list');
data = rmfield(data,'teaching');
end
