function [T_summary_original]=f_categorize_cells(DATA, Opt)

lndex_PreWhisk_OK=logical(DATA.PreS);
Index_Trial_OK=[1:min(30,size(DATA,1))];%assume  ignore 31-40 th trials DATA2 & 24 trials DATA3


Mouse_name=DATA.Mouse_name(1,:);
temp=cell2mat(reshape(DATA.PSTH_zscore_WR100ms,1,1,[]));
PSTH=permute(temp,[3 1 2]);

%parameters
thres_stim=0.5;
thres_cell_activity_std=2;

N_trial=size(DATA,1);





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%sound

for i_trial=1:N_trial %sound
    if isempty(DATA.Time_sound{i_trial})
        continue
    end
    

    %time range of sound onset per trial (bin 0.1s)
    TimeRange_PSTH_SoundONset(i_trial,:)=floor(DATA.Time_sound{i_trial}(1)/0.1)+1:floor(DATA.Time_sound{i_trial}(1)/0.1)+5;%0.5sec
        N_cell=size(DATA.PSTH_zscore_WR100ms{1},1);

    for i_cell=1:N_cell


        %extract sound onset activity per cell (zscore)
        PSTH_SoundONset_zscore_mean(i_cell, i_trial)=nanmean(DATA.PSTH_zscore_WR100ms{i_trial}( i_cell, TimeRange_PSTH_SoundONset(i_trial,:)));
    end
end %for i_trial=1:size(DATA,1) %sound




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%light


for i_trial=1:N_trial %light
    if isempty(DATA.Time_light{i_trial})
        continue
    end
    
    %time range of light onset per trial (bin 0.1s)
    TimeRange_PSTH_LightONset(i_trial,:)=floor(DATA.Time_light{i_trial}(1)/0.1)+1:floor(DATA.Time_light{i_trial}(1)/0.1)+10;%1sec
    
    for i_cell=1:N_cell

        %extract sound onset activity per cell (zscore)
        PSTH_LightONset_zscore_mean(i_cell, i_trial)=nanmean(DATA.PSTH_zscore_WR100ms{i_trial}(i_cell, TimeRange_PSTH_LightONset(i_trial,:)));
    end
    
    
end %for i_trial=1:size(DATA,1) %light

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PSTH_SoundONset_zscore_mean = PSTH_SoundONset_zscore_mean(:,lndex_PreWhisk_OK);
PSTH_LightONset_zscore_mean = PSTH_LightONset_zscore_mean(:,lndex_PreWhisk_OK);

protraction_SoundONset = DATA.protraction_SoundONset(lndex_PreWhisk_OK)';

whiskVar_LightONset =  DATA.whiskVar_LightONset(lndex_PreWhisk_OK)';




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%Z-score
%%%%correlation with  cell act zscore
%protraction_SoundONset 
[Corr_Cell_act_zscore_Sound_Protraction, Corr_pval_Cell_act_zscore_Sound_Protraction]=corr(PSTH_SoundONset_zscore_mean', protraction_SoundONset','rows','pairwise');


%whiskVar_LightONset
[Corr_Cell_act_zscore_Light_whiskVar, Corr_pval_Cell_act_zscore_Light_whiskVar]=corr(PSTH_LightONset_zscore_mean', whiskVar_LightONset','rows','pairwise');




T_summary_original=table;
T_summary_original.sound_zscore=mean(PSTH_SoundONset_zscore_mean,2);
T_summary_original.light_zscore=mean(PSTH_LightONset_zscore_mean,2);


T_summary_original.corr_whiskProtrct_sound_zscore= Corr_Cell_act_zscore_Sound_Protraction;
T_summary_original.corr_whiskVar_light_zscore= Corr_Cell_act_zscore_Light_whiskVar;

T_summary_original.corr_pval_whiskProtrct_sound_zscore= Corr_pval_Cell_act_zscore_Sound_Protraction;

T_summary_original.corr_pval_whiskVar_light_zscore= Corr_pval_Cell_act_zscore_Light_whiskVar;







