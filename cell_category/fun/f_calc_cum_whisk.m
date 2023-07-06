function [x_cum, index_trial_light_whisk_cum]=f_calc_cum_whisk(data, Opt)
%data=DATA1;

x=data.Whisk;


%parameters
fs=Opt.fs_whisk;
bin_width=0.05;%s
thres_cum_whisk=10e3;

bin_width_pt=bin_width*fs;
nbin=floor(length(data.Whisk)/fs/bin_width);

%filter
%	FilterIIR /HI=0.0008 /LO=0.2 temp
%bilinear transforms of the Butterworth analog prototype with an optional variable-width notch filter.
%https://www.wavemetrics.net/doc/igorman/V-01%20Reference.pdf

%[b,a]=besself(ceil(0.0008*fs),0.2*fs);
[b,a]=butter(2,[0.0008,0.2]);
%[b1,a1]=bilinear(b,a,fs);
x = filter(b,a,x,[],2);

%comvert degree from radian
x=x*180/pi;


%difference
x_diff=abs(x(:,2:end)-x(:,1:end-1));

%bin
for i_bin=1:nbin-1
x_bin(:,i_bin)=sum(x_diff(:,(i_bin-1)*bin_width_pt+1:(i_bin)*bin_width_pt),2);
end

%cum
for i_bin=1:nbin-1
x_cum(:,i_bin)=sum(x_bin(:,1:i_bin),2);
end

%baseline
N_trials=size(data,1);
for i_trial=1:N_trials
stimonset=data.Time_light{i_trial}(1);
x_base=x_cum(i_trial, max(floor(stimonset/bin_width)-1,1));
x_cum(i_trial,:)=x_cum(i_trial,:)-x_base;
end
%%%

index_trial_light_whisk_cum=x_cum(:,floor((stimonset+1)/bin_width))>thres_cum_whisk;

%figure
%plot(x_cum')
