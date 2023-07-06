function whisk_cum=compute_cum_whisk(t, whisk, options, stim_timing)
%data=DATA1;



%parameters
fs=options.Fs;





%filter
[b,a]=butter(2,[0.0008,0.2]);
whisk = filter(b,a,whisk,[],2);

%comvert degree from radian
whisk=whisk*180/pi;


%difference
whisk_diff=abs(whisk(2:end)-whisk(1:end-1));


mask = (t >= stim_timing) & (t < stim_timing+0.3);

whisk_cum=sum(whisk_diff(mask));




