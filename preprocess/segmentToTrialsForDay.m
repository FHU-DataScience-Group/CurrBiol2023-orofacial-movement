function data = segmentToTrialsForDay(data, options)
%segmentToTrialsForDay - 各実験日の生データをトライアル単位に切り分ける
%
% data内に格納されているデータをもとにトライアル単位に切り分け
% 各トライアル条件を同定する。
%
% [書式]
%　　data = segmentToTrialsForDay(data, options)
%
%
% [入力]
%　　data: 電圧データとWhiskingデータを格納している構造体配列
%
%　　options: ToDo
%
% [出力]
%   data: ToDo
%　　　　　　　　
%
%=========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 定数の設定
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Cue, Reward提示時の電圧（単位: V）
CUE_V = options.CUE_V;

% Lickセンサーの閾値（単位: V）
LICK_TH = options.LICK_TH;

% Whiskerデータのサンプリング周波数（単位: Hz）
Fs = options.Fs;

% Toneの遅れ時間（単位: 秒）
TONE_DELAY_TIME = options.TONE_DELAY_TIME;

% Cue提示時間（単位: 秒）
CUE_DUR = options.CUE_DUR;

% Reward Window幅（単位: 秒）
RWD_WIDTH = options.RWD_WIDTH;

% 最小ITI（単位: 秒）
MIN_ITI = options.MIN_ITI;

% トライアル前最小待ち時間（単位: 秒）
PRE_WAIT_DUR = options.PRE_WAIT_DUR;

% 想定される1日あたりの最大トライアル数
MaxNumTrials = options.MaxTrials;

% Lickingの最小周期（単位: 秒）
MinLickFreq = options.MinLickFreq;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 各トライアルへの切り分け
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 各トライアルの結果を格納するセル配列を作成する
trials = cell(1,MaxNumTrials);

% data内に格納されているセクション数を取得する
NumS = length(data.voltage);

% trialsに代入する配列番号の初期化
idx = 0;
for n = 1:NumS
    % Teaching sessionだったか否かのmaskを取得
    teaching = data.teaching(n);
    % 電圧データを取得する
    voltage = data.voltage{n};
    % Whiskerデータを取得する
    whisker = data.whisker{n};
    % noseデータを取得する
    nose = data.nose{n};
    % 電圧データをダウンサンプリングする
    mva_width = size(voltage,1)/size(whisker,1);    
    vol_mva = movmean(voltage{:,:}, [mva_width/2, mva_width/2], 1, 'omitnan');
    vol_mat = vol_mva(mva_width/2:mva_width:end,:);
    voltage = array2table(vol_mat, 'VariableNames', voltage.Properties.VariableNames);
    
    % 時系列長を取得する
    MaxRows = size(whisker,1);
    % タイムスタンプを作成する
    t=(1/Fs)*(1:MaxRows)';
    
    % 各時刻で各cueのON/OFFを判定する
    go_cue = voltage.Go > CUE_V/2;
    nogo_cue = voltage.No_Go > CUE_V/2;
    romit_cue = voltage.R_Omit > CUE_V/2;
    cue = go_cue | nogo_cue | romit_cue;    
    rwd = voltage.Rwd > CUE_V/2;
    
    % リッキングのデータを取得する
    lick = voltage.Lick;
    
    % リックタイミング検知（新バージョン）
    % 速度が有意に大きな時刻を検出
    dif_lick = [abs(diff(lick));0];
    on_lick = isoutlier(dif_lick, 'median', 1, 'ThresholdFactor', 5);
    on_lick_idx1 = find(on_lick == 1);
    % 検出された時刻が連続しているものは後に続く系列を除去
    t_lick = t(on_lick_idx1);
    dt1_lick = [inf; diff(t_lick)];
    on_lick_idx1(dt1_lick < MinLickFreq) = [];
    t_lick = t(on_lick_idx1);
    % 平滑化時系列からピーク点を検知する
    lick_filt = movmean(lick,3);
    [~,peak_idx] = findpeaks(abs(lick_filt), 'MinPeakHeight', LICK_TH/2);
    % ピーク点が以前のピーク点からMinPeakDist秒以内に出現したときはLickの対象から外す
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
    % ピーク点直前のLickが検出されていない場合は、加速度最大点をLickタイミングとする
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
    % 検出された時刻が連続しているものは後に続く系列を除去
    t_lick2 = t(on_lick_idx2);
    dt2_lick = [inf; diff(t_lick2)];
    on_lick_idx2(dt2_lick < MinLickFreq) = [];
        
    on_lick(:) = 0;
    on_lick(on_lick_idx1) = 1;
    on_lick(on_lick_idx2) = 1;

    
%     % リッキングタイミングを検知する
%     dif_lick = [abs(diff(lick));0];
%     on_lick = isoutlier(dif_lick, 'median', 1, 'ThresholdFactor', 5);
%     on_lick_idx = find(on_lick == 1);
%     t_lick = t(on_lick_idx);
%     dt1_lick = [inf; diff(t_lick)];
%     on_lick_idx(dt1_lick < 0.05) = [];
%     on_lick(:) = 0;
%     on_lick(on_lick_idx) = 1;

    % 各トライアルにおけるcueのonsetタイミングを同定する
    idx_cue_timing = find(diff([nan; cue]) == 1);
    % 想定しうるITIより短い間隔でcueのonsetと判定されてしまったものは除外する
    idx_cue_mask = diff([-inf; t(idx_cue_timing)]) > (TONE_DELAY_TIME + CUE_DUR + RWD_WIDTH + PRE_WAIT_DUR); 
    idx_cue_timing = idx_cue_timing(idx_cue_mask);
    idx_cue_mask = idx_cue_timing > Fs * PRE_WAIT_DUR;
    idx_cue_timing = idx_cue_timing(idx_cue_mask);
    % 各トライアルに切り出していく
    NumCues = length(idx_cue_timing);
    for k = 1:NumCues
        % 現トライアルの開始時刻と終了時刻の時系列インデクスを取得する
        idx_cue_onset = idx_cue_timing(k);
        idx_cue_offset = idx_cue_onset + round(Fs * (TONE_DELAY_TIME +CUE_DUR));
        idx_rwd_onset = idx_cue_offset;
        idx_rwd_offset = idx_rwd_onset + round(Fs * RWD_WIDTH);
        idx_start = idx_cue_onset - round(Fs * (PRE_WAIT_DUR-TONE_DELAY_TIME));
        idx_end = idx_rwd_offset + round(Fs * MIN_ITI);
        % 終了時刻が想定しうるITIより短ければ解析対象に含めず終了
        if(idx_end > MaxRows)
            break;
        end
        % 解析に必要な期間だけをデータとして切り出す
        idx_trial = idx_start:idx_end;
        tps = t(idx_trial)-(t(idx_cue_onset)+TONE_DELAY_TIME);
        t_table = array2table(tps, 'VariableNames', {'Time'});
        values = horzcat(t_table,voltage(idx_trial,:), whisker(idx_trial,:), nose(idx_trial,:));
        
        % Reward Window内でのlickセンサの最大値を取得する
        max_lick = max(abs(lick(idx_rwd_onset:idx_rwd_offset)));
        % Licking timingを得る
        lick_timing_mask = on_lick(idx_trial);
        lick_timing = tps(lick_timing_mask);% t_lick - t(idx_cue_onset);
        
        % 各トライアルの条件を同定する
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
