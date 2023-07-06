[DATA1.whisk_cum_light, DATA1.index_trial_light_whisk_cum]=f_calc_cum_whisk(DATA1, Opt);
[DATA1]=f_calc_whisk_features(DATA1, Opt);

[DATA2.whisk_cum_light, DATA2.index_trial_light_whisk_cum]=f_calc_cum_whisk(DATA2, Opt);
[DATA2]=f_calc_whisk_features(DATA2, Opt);


[DATA3.whisk_cum_light, DATA3.index_trial_light_whisk_cum]=f_calc_cum_whisk(DATA3, Opt);
[DATA3]=f_calc_whisk_features(DATA3, Opt);


[DATA4.whisk_cum_light, DATA4.index_trial_light_whisk_cum]=f_calc_cum_whisk(DATA4, Opt);
[DATA4]=f_calc_whisk_features(DATA4, Opt);


save(['DATA.mat'], 'DATA*', 'Opt','-v7.3')
