function protraction = computeProtraction(t, whisk, stim_timing)
%visualizeRawData - ToDo
%
% ToDo
%
% [書式]
%　　visualizeRawData(Dataset, options)
%
%
% [入力]
%　　Dataset: ToDo
%
%　　options: ToDo
%
%
%=========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 前処理
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Cue period区間でのprotraction量を計算する
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%whisk=movmedian(whisk, 0.2*200);
pre_cue_mask = (t >= stim_timing-0.3) & (t < stim_timing);
baseline_whisk = median(whisk(pre_cue_mask));
cs_mask = (t >= stim_timing) & (t < stim_timing+0.3);
cs_whisk = max(whisk(cs_mask));
protraction = cs_whisk - baseline_whisk;

% figure(1);
% clf;
% plot(t,whisk);
% hold on;
% plot([min(t),max(t)],[baseline_whisk,baseline_whisk],'--');
% plot([min(t),max(t)],[cs_whisk,cs_whisk],'--');
% plot([min(t),max(t)],[baseline_whisk+cp_protraction,baseline_whisk+cp_protraction],'r:');
% pause;
end

