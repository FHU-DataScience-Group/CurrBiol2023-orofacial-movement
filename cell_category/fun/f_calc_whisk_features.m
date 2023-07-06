function [DATA]=f_calc_whisk_features(DATA, Opt)



Mouse_name=DATA.Mouse_name(1,:);
temp=cell2mat(reshape(DATA.PSTH,1,1,[]));
PSTH=permute(temp,[3 1 2]);


thres_protraction=5;
N_trial=size(DATA,1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%sound

for i_trial=1:N_trial %sound
    if isempty(DATA.Time_sound{i_trial})
        protraction_SoundONset(i_trial)=NaN;
        whiskVar_SoundONset(i_trial)=NaN;
        NoseAreaMax_SoundONset(i_trial)=NaN;
        NoseLengthMax_SoundONset(i_trial)=NaN;
        NoseAeraVar_SoundONset(i_trial)=NaN;
        NoseLengthVar_SoundONset(i_trial)=NaN;
        continue
    end
    

    
    %time range of sound onset per trial (1frame =0.002s)
    TimeRange_Movie_SoundONset(i_trial,:)=floor(DATA.Time_sound{i_trial}(1)*Opt.fs_whisk)+1:floor(DATA.Time_sound{i_trial}(1)*Opt.fs_whisk)+0.5*Opt.fs_whisk;%0.5sec
    
    
    
    %extract whisker protraction at light onset per trial
    whisk=movmedian(DATA.Whisk(i_trial,:), 0.2*Opt.fs_whisk);
    
    %extract whisker protraction at sound onset per trial
    baseline_whisk(i_trial)  = median(whisk(TimeRange_Movie_SoundONset(i_trial,:)-0.3*Opt.fs_whisk));
    Onset_whisk(i_trial)  = max(whisk(TimeRange_Movie_SoundONset(i_trial,:)));
    protraction_SoundONset(i_trial) = Onset_whisk(i_trial)  - baseline_whisk(i_trial) ;
    
    whiskVar_SoundONset(i_trial)=var(DATA.Whisk(i_trial,TimeRange_Movie_SoundONset(i_trial,:)));
    


    
    

end %for i_trial=1:size(DATA,1) %sound




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%light


for i_trial=1:N_trial %light
    if isempty(DATA.Time_light{i_trial})
        protraction_LightONset(i_trial)=NaN;
        whiskVar_LightONset(i_trial)=NaN;
        NoseVar_LightONset(i_trial)=NaN;
        continue
    end
    
    
    %time range of light onset per trial (1frame =0.002s)
    TimeRange_Movie_LightONset(i_trial,:)=floor(DATA.Time_light{i_trial}(1)*Opt.fs_whisk)+1:floor(DATA.Time_light{i_trial}(1)*Opt.fs_whisk)+1.0*Opt.fs_whisk;%1.0sec
    
    
    
    %extract whisker protraction at light onset per trial
    whisk=movmedian(DATA.Whisk(i_trial,:), 0.2*Opt.fs_whisk);
    baseline_whisk = nanmedian(whisk(TimeRange_Movie_LightONset(i_trial,:)-0.3*Opt.fs_whisk));
    Onset_whisk = max(whisk(TimeRange_Movie_LightONset(i_trial,:)));
    protraction_LightONset(i_trial) = Onset_whisk - baseline_whisk;
    
    whiskVar_LightONset(i_trial)=var(DATA.Whisk(i_trial,TimeRange_Movie_LightONset(i_trial,:)));
    


    
    

    
end %for i_trial=1:size(DATA,1) %light



DATA.protraction_SoundONset=protraction_SoundONset';
DATA.whiskVar_SoundONset=whiskVar_SoundONset';
DATA.protraction_LightONset=protraction_LightONset';
DATA.whiskVar_LightONset=whiskVar_LightONset';


index_trial_sound_whiskprotrct=protraction_SoundONset>thres_protraction;
DATA.index_trial_sound_whiskprotrct=index_trial_sound_whiskprotrct';
