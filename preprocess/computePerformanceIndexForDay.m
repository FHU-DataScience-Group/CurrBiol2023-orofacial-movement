function data = computePerformanceIndexForDay(data, options)
%runBehaviorAnalysisForDay この関数の概要をここに記述
%   詳細説明をここに記述


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 行動解析用パラメータの取得
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% P-prime計算時の1ブロックあたりのトライアル数
TRIALS_PER_BLOCK = options.TRIALS_PER_BLOCK;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 各トライアルの行動結果の集計
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 全トライアル数を取得
NumTrials = length(data.trials);

% ブロック数を設定
NumBlocks = ceil(NumTrials/TRIALS_PER_BLOCK);

% ブロックマスクを初期化
block_mask = true(1,NumBlocks);
% D-prime計算に含むトライアルのマスクを初期化
dprime_mask = true(1,NumTrials);

% 各ブロックごとの以下の処理を実行する
for b = 1:NumBlocks
    % Go trial数を初期化
    go_cnt = 0;
    % Hit trial数を初期化
    hit_cnt = 0;
    for h = 1:TRIALS_PER_BLOCK
        % Trial IDを計算
        k = (b-1)*TRIALS_PER_BLOCK + h;
        if k > NumTrials
            break;
        end
        % 当該trialのcueを取得
        cue = data.trials{k}.cue;
        % 当該trialの結果を取得
        outcome = data.trials{k}.outcome;
        % Go trialの場合にカウンターを計算
        if strcmp(cue, 'Go')
            % ErrorでもTeachingでもない場合にGo trial数をインクリメント
            if ~(strcmp(outcome, 'Error') || strcmp(outcome, 'Teaching'))
                go_cnt = go_cnt + 1;
            end
            % Hit数をインクリメント
            if strcmp(outcome, 'Hit')
                hit_cnt = hit_cnt + 1;
            end
        end
    end
    % 除外条件をチェック
    if go_cnt >= 1
        HR = hit_cnt/go_cnt;
        if HR <= 0.2
            block_mask(b) = false;
        end
    end
end

% D-prime計算に含むトライアルのマスク
for b = 1:NumBlocks
    perform_mask = sum(block_mask(b:end)) >= 1;
    for h = 1:TRIALS_PER_BLOCK
        % Trial IDを計算
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
    % 当該trialのcueを取得
    cue = data.trials{k}.cue;
    % 当該trialの結果を取得
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

