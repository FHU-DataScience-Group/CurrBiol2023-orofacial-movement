function [DATA]=f_Extract_Trials(Mouse_name, Opt)

load([Mouse_name, '_spike.mat']);




%trigger
temp=find(Ch_StimTime_trigger(2:end)-Ch_StimTime_trigger(1:end-1));
Timing_trigger_onsets=temp([1:2:length(temp)]);
Ntrials_trigger=length(Timing_trigger_onsets);
Time_trigger_onsets=Ch_time(Timing_trigger_onsets);




if exist('Ch_StimTime_trigger')==0
Ch_StimTime_trigger=zeros(size(Ch_time));
end
if exist('Ch_StimTime_sound')==0
Ch_StimTime_sound=zeros(size(Ch_time));
end
if exist('Ch_StimTime_light')==0
Ch_StimTime_light=zeros(size(Ch_time));
end


N_clst=max(Spike_clusters_good2);
T_end=Spike_times_good(end);
for i_clst=1:N_clst
    Spikes_time{i_clst}=Spike_times_good(Spike_clusters_good2==i_clst);
    
    bin_size=0.1;
    temp=discretize(Spikes_time{i_clst},[0:bin_size:T_end/bin_size]);
    temp2=histcounts(temp,[1:T_end/bin_size])*10;
    bin100ms_mean(i_clst)=mean(temp2);
    bin100ms_std(i_clst)=std(temp2);
    
end


Time_after_trigger_onset=30; %sec
Opt.Time_after_trigger_onset=Time_after_trigger_onset;

%trigger cell-by-cell
for i_clst=1:N_clst
	for i_trial=1:Ntrials_trigger
		index_time_clst_trial_trigger{i_clst,i_trial}=Spikes_time{i_clst}>Time_trigger_onsets(i_trial) & Spikes_time{i_clst}<Time_trigger_onsets(i_trial)+Time_after_trigger_onset ;
		%trigger onsetからTime_after_trigger_onset秒間のspikeの起きた時間のindex
	end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%
%trigger
for i_clst=1:N_clst
	for i_trial=1:Ntrials_trigger
		hist_Spikes_clst_trial_trigger(:,i_clst, i_trial)=histcounts(Spikes_time{i_clst}(index_time_clst_trial_trigger{i_clst,i_trial})-Time_trigger_onsets(i_trial), [0:0.1:Time_after_trigger_onset])*10;

		hist_Spikes_clst_trial_trigger_100ms(:,i_clst, i_trial)=histcounts(Spikes_time{i_clst}(index_time_clst_trial_trigger{i_clst,i_trial})-Time_trigger_onsets(i_trial), [0:0.1:Time_after_trigger_onset])*10;

	end
end


Time_from_Trigger=[1/Opt.fs:1/Opt.fs:30];
for i_trial=1:Ntrials_trigger
index_sound(i_trial,:)=Ch_StimTime_sound(Timing_trigger_onsets(i_trial):Timing_trigger_onsets(i_trial)+Time_after_trigger_onset*Opt.fs-1);
index_light(i_trial,:)=Ch_StimTime_light(Timing_trigger_onsets(i_trial):Timing_trigger_onsets(i_trial)+Time_after_trigger_onset*Opt.fs-1);
end

for i_trial=1:Ntrials_trigger
Time_sound_stim{i_trial}=Time_from_Trigger(find(index_sound(i_trial,2:end)-index_sound(i_trial,1:end-1)));
try
Time_sound_stim{i_trial}(1)=Time_sound_stim{i_trial}(1)+Opt.Delay_sound;
end
Time_light_stim{i_trial}=Time_from_Trigger(find(index_light(i_trial,2:end)-index_light(i_trial,1:end-1)));
end



DATA=table(repmat(Mouse_name,[Ntrials_trigger,1]),'VariableNames',{'Mouse_name'});
DATA.trial=[1:Ntrials_trigger]';%'

tempPSTH=permute(hist_Spikes_clst_trial_trigger, [3 2 1]);
for i_trials=1:size(tempPSTH,1)
	DATA.PSTH{i_trials}=squeeze(tempPSTH(i_trials,:,:));
end

tempPSTH=permute(hist_Spikes_clst_trial_trigger_100ms, [3 2 1]);
for i_trials=1:size(tempPSTH,1)
	DATA.PSTH_100ms{i_trials}=squeeze(tempPSTH(i_trials,:,:));
end



DATA.Time_sound=Time_sound_stim';%'
DATA.Time_light=Time_light_stim';%'
DATA.TTL_sound=index_sound;%'
DATA.TTL_light=index_light;%'


%Zscore
N_trial=size(DATA,1);
N_cell=size(tempPSTH,2);
TimeRange_PSTH_Baseline=1:3/0.1; % 3 sec

for i_cell=1:N_cell
    temp=[];
    for i_trial=1:N_trial
        temp=[temp, DATA.PSTH{i_trial}(i_cell, TimeRange_PSTH_Baseline)];
	end
	PSTH_base_mean_cell(i_cell)=mean(temp);
	PSTH_base_std_cell(i_cell)=std(temp);
end

for i_cell=1:N_cell
for i_trial=1:N_trial
       tempPSTH_zscore_WR100ms{i_trial}(i_cell,:) =(DATA.PSTH_100ms{i_trial}(i_cell,:)-bin100ms_mean(i_cell))/bin100ms_std(i_cell);
end
end
DATA.PSTH_zscore_WR100ms=tempPSTH_zscore_WR100ms';
