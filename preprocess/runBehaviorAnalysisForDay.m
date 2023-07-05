function data = runBehaviorAnalysisForDay(data, options, fig_dir)
%runBehaviorAnalysisForDay ���̊֐��̊T�v�������ɋL�q
%   �ڍא����������ɋL�q

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �萔�̐ݒ�
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Figure Window�̕�
FIG_XSize = 560;

% Figure Window�̍���
FIG_YSize = 350;

% Color Order�̎擾
co = get(gca,'ColorOrder');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �s����͗p�p�����[�^�̎擾
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% �ړ����ςɂ��ۑ萬�����v�Z���̑����i�P��: �g���C�A���j
RATE_WINDOW_PRE = options.RATE_WINDOW_PRE;
RATE_WINDOW_POST = options.RATE_WINDOW_POST;

% ��͑Ώۋ�Ԃ�Hit Rate��臒l
HIT_RATE_TH = options.HIT_RATE_TH;

% ��͑Ώۋ�Ԃ�False Alart Rate臒l
FA_RATE_TH = options.FA_RATE_TH;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �o�͐�t�H���_�̍쐬
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~isempty(fig_dir)
    if ~exist(fig_dir, 'dir')
        mkdir(fig_dir);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Figure Window�̐����ƃ��T�C�Y
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h1 = figure(1);
POS = get(h1, 'Position');
POS(3:4) = [FIG_XSize, FIG_YSize];
set(h1, 'Position', POS);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �e�g���C�A���̍s�����ʂ̏W�v
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% �S�g���C�A�������擾
NumTrials = length(data.trials);

go_hit = nan(1,NumTrials);
nogo_fa = nan(1,NumTrials);
outcome_idx = nan(1,NumTrials);
rslt_mat = zeros(3,4);
for k = 1:NumTrials
    trial = data.trials{k};
    cue = trial.cue;
    outcome = trial.outcome;
    if strcmp(cue, 'Go')
        if strcmp(outcome, 'Hit')
            go_hit(k) = 1;
            outcome_idx(k) = 1;
            rslt_mat(1,1) = rslt_mat(1,1) + 1;
        elseif strcmp(outcome, 'Miss')
            go_hit(k) = 0;
            outcome_idx(k) = 2;
            rslt_mat(1,2) = rslt_mat(1,2) + 1;
        elseif strcmp(outcome, 'Error')
            outcome_idx(k) = 0;
            rslt_mat(1,3) = rslt_mat(1,3) + 1;
        end
    elseif strcmp(cue, 'No Go')
        if strcmp(outcome, 'CR')
            nogo_fa(k) = 0;
            outcome_idx(k) = 4;
            rslt_mat(2,2) = rslt_mat(2,2) + 1;
        elseif strcmp(outcome, 'FA')
            nogo_fa(k) = 1;
            outcome_idx(k) = 3;
            rslt_mat(2,1) = rslt_mat(2,1) + 1;
        elseif strcmp(outcome, 'Error')
            outcome_idx(k) = 0;
            rslt_mat(2,3) = rslt_mat(2,3) + 1;
        end        
    elseif strcmp(cue, 'Omission')
        if strcmp(outcome, 'Lick')
            go_hit(k) = 1;
            outcome_idx(k) = 5;
            rslt_mat(3,1) = rslt_mat(3,1) + 1;            
        elseif strcmp(outcome, 'No Lick')
            go_hit(k) = 0;
            outcome_idx(k) = 6;
            rslt_mat(3,2) = rslt_mat(3,2) + 1;
        elseif strcmp(outcome, 'Error')
            outcome_idx(k) = 0;
            rslt_mat(3,3) = rslt_mat(3,3) + 1;
        end        
    end
    if strcmp(outcome, 'Teaching')
        outcome_idx(k) = -1;        
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �s�����ʂ̏W�v
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% �g���C�A����ނ̏o���p�x�Ɖۑ萬�������v�Z
rslt_mat(:,4) = rslt_mat(:,1)./(rslt_mat(:,1)+rslt_mat(:,2));
result_summary = array2table(rslt_mat, ...
    'VariableNames', {'Lick', 'No_Lick', 'Error', 'Lick_Rate'}, ...
    'RowNames', {'Go', 'No_Go', 'Omit'});

% ���ʂ��t�@�C���ɕۑ�
if ~isempty(fig_dir)
    filename = strcat(fig_dir, '/result_summary.csv');
    writetable(result_summary,filename, 'WriteRowNames', true)
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �ۑ萬�����ړ����ς̌v�Z
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hit_rate = nan(1,NumTrials);
fa_rate = nan(1,NumTrials);
for k = 1:NumTrials
    % �e�g���C�A����Hit Rate�̌v�Z
    go_hit_pre = go_hit(1:k-1);
    valid_pre_idx = find(~isnan(go_hit_pre),RATE_WINDOW_PRE,'last');
    go_hit_post = go_hit(k:end);
    valid_post_idx = find(~isnan(go_hit_post),RATE_WINDOW_POST,'first');
    hit_rate(k) = mean([go_hit_pre(valid_pre_idx),go_hit_post(valid_post_idx)]);
    % �e�g���C�A����FA Rate�̌v�Z
    nogo_fa_pre = nogo_fa(1:k-1);
    valid_pre_idx = find(~isnan(nogo_fa_pre),RATE_WINDOW_PRE,'last');
    nogo_fa_post = nogo_fa(k:end);
    valid_post_idx = find(~isnan(nogo_fa_post),RATE_WINDOW_POST,'first');
    fa_rate(k) = mean([nogo_fa_pre(valid_pre_idx),nogo_fa_post(valid_post_idx)]);   
end

suc_mask = (hit_rate >= HIT_RATE_TH) & (fa_rate <= FA_RATE_TH);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �s�����ʂ̌n��\��
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% �L�����o�X������
clf(h1);
% �T�u�v���b�g�L�����o�X�̍쐬
subplot(2,1,1);
% ��͑Ώۋ�Ԃ̕\��
bar(1:NumTrials,suc_mask,1,'EdgeColor','none', 'FaceColor','m', 'FaceAlpha', 0.1);
hold on;
% Go-Hit trial�̕\��
plot_idx = find(outcome_idx == 1);
plot([plot_idx; plot_idx], [0.9-0.1*ones(size(plot_idx)); 0.9+0.1*ones(size(plot_idx))], 'color', co(1,:), 'LineWidth', 1);
% Go-Miss trial�̕\��
plot_idx = find(outcome_idx == 2);
plot([plot_idx; plot_idx], [0.9-0.05*ones(size(plot_idx)); 0.9+0.05*ones(size(plot_idx))], 'color', co(1,:), 'LineWidth', 1);

% NoGo-FA trial�̕\��
plot_idx = find(outcome_idx == 3);
plot([plot_idx; plot_idx], [0.1-0.1*ones(size(plot_idx)); 0.1+0.1*ones(size(plot_idx))], 'color', co(2,:), 'LineWidth', 1);

% NoGo-CR trial�̕\��
plot_idx = find(outcome_idx == 4);
plot([plot_idx; plot_idx], [0.1-0.05*ones(size(plot_idx)); 0.1+0.05*ones(size(plot_idx))], 'color', co(2,:), 'LineWidth', 1);

% Omission-Lick trial�̕\��
plot_idx = find(outcome_idx == 5);
plot([plot_idx; plot_idx], [0.9-0.1*ones(size(plot_idx)); 0.9+0.1*ones(size(plot_idx))], 'color', co(3,:), 'LineWidth', 1);

% Omission-No Lick trial�̕\��
plot_idx = find(outcome_idx == 6);
plot([plot_idx; plot_idx], [0.9-0.05*ones(size(plot_idx)); 0.9+0.05*ones(size(plot_idx))], 'color', co(3,:), 'LineWidth', 1);

% Error trial�̕\��
plot_idx = find(outcome_idx == 0);
plot([plot_idx; plot_idx], [0.5-0.05*ones(size(plot_idx)); 0.5+0.05*ones(size(plot_idx))], 'color', [0.5, 0.5, 0.5], 'LineWidth', 1);

% Teaching trial�̕\��
plot_idx = find(outcome_idx == -1);
plot([plot_idx; plot_idx], [0.5-0.05*ones(size(plot_idx)); 0.5+0.05*ones(size(plot_idx))], 'color', [0.25, 0.25, 0.25], 'LineWidth', 1);


% ���̒���
xlim([0.5,NumTrials+0.5]);
ylim([0.0,+1.0]);
set(gca,'YTick',[0.1,0.5,0.9]);
set(gca,'YTickLabel',{'No Go','Error','Go'});
xlabel('Trials');
ylabel('Cue');
title('Behavioral result ');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �ۑ萬�����̎��ԕω��̕\��
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% �T�u�v���b�g�L�����o�X�̍쐬
subplot(2,1,2);
% ��͑Ώۋ�Ԃ̕\��
bar(1:NumTrials,suc_mask,1,'EdgeColor','none', 'FaceColor','m', 'FaceAlpha', 0.1);
hold on;
% Hit Rate�̕\��
plt1 = plot(1:NumTrials, hit_rate, 'color', co(1,:));
% FA Rate�̕\��
plt2 = plot(1:NumTrials, fa_rate, 'color', co(2,:));
% Hit Rate臒l�̕\��
plot([0;NumTrials+1], [0.8;0.8], 'k:');
% FA Rate臒l�̕\��
plot([0;NumTrials+1], [0.2;0.2], 'k:');

% ���̒���
ylim([0.0,1.0]);
set(gca,'YTick',[0,0.5,1]);
ylabel('Rate');

xlim([0.5,NumTrials+0.5]);
xlabel('Trials');
title('Time course of Hit & FA rates');
legend([plt1,plt2],{'Hit Rate','FA Rate'},'Location','east');

% �}�̕ۑ�
if ~isempty(fig_dir)
    filename = strcat(fig_dir, '/trial_by_trial');
    print('-dpdf', filename);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ��͌��ʂ̕ۑ�
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data.result_summary = result_summary;
data.suc_mask = suc_mask;
data.hit_rate = hit_rate;
data.fa_rate = fa_rate;

end

