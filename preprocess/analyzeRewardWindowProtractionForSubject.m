function stat = analyzeRewardWindowProtractionForSubject(SubjectData, options, label)
%analyzeCuePeriodWMAverageForSubject - ToDo
%
% ToDo
%
% [����]
%�@�@analyzeCuePeriodGrandAverage(Dataset, options, label)
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

% �ő�g���C�A�������擾
MaxTrials = 100000;

% Figure Window�̕�
FIG_XSize = 500;

% Figure Window�̍���
FIG_YSize = 300;

% ��Ԑ؂�o���̊ۂߌ덷�␳�i�P��: �b�j
T_COR = (1/options.Fs)*0.1;

% Reward Window�x�[�X���C�������ԁi�P��: �b�j
PRE_RWD_WINDOW = 0.5;

% Cue�񎦎��ԁi�P��: �b�j
CUE_DUR = options.CUE_DUR;

% Reward Window���i�P��: �b�j
RWD_WIDTH = options.RWD_WIDTH;

% Y���̍ő�l
Y_MAX = 20.0;

% Y���̍ŏ��l
Y_MIN = -5.0;

% Color Order�̎擾
co = get(gca,'ColorOrder');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Figure Window�̐ݒ�
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h1 = figure(1);
POS = get(h1, 'Position');
POS(3:4) = [FIG_XSize, FIG_YSize];
set(h1, 'Position', POS);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Subject����Data���ɐ؂蕪����
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subject_id = SubjectData.subject_id;
exp_condition = SubjectData.exp_condition;
data = SubjectData.data;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% �t�H���_�쐬�����PDF���|�[�g�t�@�C���̍쐬
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~isempty(options.FIG_DIR)
    save_to_dir = strcat(options.FIG_DIR, '/Setpoint/', label, '/reward_window');
    if ~exist(save_to_dir, 'dir')
        mkdir(save_to_dir);
    end
else
    save_to_dir = [];
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ��͑ΏۂƂȂ鎞�Ԕ͈͂�ݒ肷��
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

idx_hit = 0;
prot_rw_hit = nan(MaxTrials, 5);
idx_oh = 0;
prot_rw_oh = nan(MaxTrials, 5);

for d = 1:length(data)
    trials = data{d}.trials;
    for k = 1:length(trials)
        outcome = trials{k}.outcome;
        if strcmp(outcome, 'Hit')
            t = trials{k}.values.Time;
            whisk = trials{k}.values.Whisker;
            baseline_mask = (t >= CUE_DUR - (PRE_RWD_WINDOW + T_COR)) & (t < CUE_DUR - T_COR);
            whisk_baseline = median(whisk(baseline_mask));
            whisk_c = whisk - whisk_baseline;
            rwd_mask = (t >= CUE_DUR + T_COR) & (t <= CUE_DUR +RWD_WIDTH + T_COR);
            whisk_rwd = whisk_c(rwd_mask);
            whisk_rwd_seg = reshape(whisk_rwd, [length(whisk_rwd)/5,5]);
            idx_hit = idx_hit + 1;
            prot_rw_hit(idx_hit,:) = median(whisk_rwd_seg,1);
        elseif strcmp(outcome, 'Lick')
            t = trials{k}.values.Time;
            whisk = trials{k}.values.Whisker;
            baseline_mask = (t >= CUE_DUR - (PRE_RWD_WINDOW + T_COR)) & (t < CUE_DUR - T_COR);
            whisk_baseline = median(whisk(baseline_mask));
            whisk_c = whisk - whisk_baseline;
            rwd_mask = (t >= CUE_DUR + T_COR) & (t <= CUE_DUR +RWD_WIDTH + T_COR);
            whisk_rwd = whisk_c(rwd_mask);
            whisk_rwd_seg = reshape(whisk_rwd, [length(whisk_rwd)/5,5]);
            idx_oh = idx_oh + 1;
            prot_rw_oh(idx_oh,:) = median(whisk_rwd_seg,1);
        end
    end
end

prot_rw_hit(idx_hit+1:end,:) = [];
prot_rw_oh(idx_oh+1:end,:) = [];

figure(h1);
clf(h1);
mean_prot_rw_hit = [0, mean(prot_rw_hit,1)];
sem_prot_rw_hit = [0, std(prot_rw_hit,0,1)/sqrt(size(prot_rw_hit,1))];

if idx_oh >= 1
    mean_prot_rw_oh = [0, mean(prot_rw_oh,1)];
    sem_prot_rw_oh = [0, std(prot_rw_oh,0,1)/sqrt(size(prot_rw_oh,1))];
else
    mean_prot_rw_oh = [0, mean(prot_rw_oh,1)];
    sem_prot_rw_oh = nan(size(mean_prot_rw_oh));
end

plt1 = errorbar(0:0.2:1, mean_prot_rw_hit, sem_prot_rw_hit, '-', 'Color', co(1,:), 'LineWidth', 2);
hold on;
plt2 = errorbar(0:0.2:1, mean_prot_rw_oh, sem_prot_rw_oh, '-', 'Color', co(3,:), 'LineWidth', 2);
legend([plt1, plt2], {'Hit', 'OH'}, 'Location', 'northeastoutside');
xlabel('Time from reward window onset (s)');
ylabel('Change in set-point (degree)');
xlim([0,1.1]);
ylim([Y_MIN, Y_MAX]);
pval = nan(1,5);
for d = 1:5
    [~,pval(d)] = ttest2(prot_rw_hit(:,d),prot_rw_oh(:,d));
    if pval(d) < 1e-3
        text(0.2*d,18, '***', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
    elseif pval(d) < 1e-2
        text(0.2*d,18, '**', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
    elseif pval(d) < 5e-2
        text(0.2*d,18, '*', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
    else
        text(0.2*d,18, 'N.S.', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
    end
end


if ~isempty(save_to_dir)
    filename = strcat(save_to_dir, '/', subject_id, '_', exp_condition, '_hit_oh');
    print('-painters', '-depsc', filename);
    print('-dpdf', filename);
end

stat.t_rwd = 0:0.2:1;
stat.mean_prot_rw_hit = mean_prot_rw_hit;
stat.mean_prot_rw_oh = mean_prot_rw_oh;

end

