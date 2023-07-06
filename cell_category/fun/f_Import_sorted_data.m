function f_Import_sorted_data(Mouse_name, Nchannel, Ch_trigger, Ch_sound, Ch_light, Opt)

% import_sorted_data.m
% 33 Chのデータ（うち1:32 ChにEphysデータ、fs = 30000 Hz）を
% phyでsortingした後のデータからスパイクタイミングを抽出するプログラム
% Yasutaka Mukai, 20180710
Nch=Nchannel;
Ch_trigger=Ch_trigger;
Ch_sound=Ch_sound;
Ch_light=Ch_light;

thres_trigger=Opt.thres_trigger;
thres_light=Opt.thres_light;
thres_sound=Opt.thres_sound;

fs=Opt.fs;

name_f= [Opt.dir, Mouse_name];


%name_f = uigetdir; % spike_times.npyとspike_clusters.npyの入っているフォルダを選択
f_times = fullfile(name_f, 'spike_times.npy'); % timesのパスを代入
f_clusters = fullfile(name_f, 'spike_clusters.npy'); % clustersのパスを代入
f_groups = fullfile(name_f, 'cluster_groups.csv'); % cluster_groupsのパスを代入

datfile = dir(fullfile(name_f,'*.dat')); % datファイルを選択 !１フォルダに１つだけdatファイルがある前提
if length(datfile)<1; error('No dat file in the folder!'); end % datファイルがない場合
if length(datfile)>1; error('Two or more dat files in the folder!'); end % datファイルが2つ以上ある場合

A = fopen(f_times); Spike_times = fread(A, 'uint64'); % uint64のtimesをインポート
B = fopen(f_clusters); Spike_clusters = fread(B, 'uint32'); % uint32のclustersをインポート
Spike_times(1:10,:) = []; Spike_clusters(1:20,:) = []; % よくわからない余分な行を削除 !場合によって行数は異なるかも
Spike_times = Spike_times/fs; % fs=30000で割って実時間（sec）にする

clear A B;

Ch = fopen(fullfile(datfile.folder, datfile.name));
Ch_dat = fread(Ch, 'int16'); % datファイルをインポート
if mod(numel(Ch_dat),Nch) == 0
    Ch_dat = reshape(Ch_dat,Nch,[]); % datファイルを33行データにreshape
else
    warning('The .dat file does not contain 33 Ch data.') % 33Ch以外の場合に警告
end

clear Ch;
% とりあえず刺激の情報だけを抽出してほかのephysデータは無くす
Ch_length=size(Ch_dat,2);
if ~isnan(Ch_trigger)
    Ch_dat_trigger = Ch_dat(Ch_trigger,:);
end
if ~isnan(Ch_sound)
    Ch_dat_sound = Ch_dat(Ch_sound,:);
end
if ~isnan(Ch_light)
    Ch_dat_light = Ch_dat(Ch_light,:);
end
clear Ch_dat;

if ~isnan(Ch_trigger)
    Ch_StimTime_trigger = Ch_dat_trigger > thres_trigger; %6000以上は１、それ以外は０
    Ch_dat_trigger = Ch_dat_trigger/max(Ch_dat_trigger); % とりあえずephysのy軸を1以下くらいにする。!60000は条件によって変更する。
end
if ~isnan(Ch_sound)
    Ch_StimTime_sound = Ch_dat_sound > thres_sound; %10000以上は１、それ以外は０
    Ch_dat_sound = Ch_dat_sound/max(Ch_dat_sound); % とりあえずephysのy軸を1以下くらいにする。!60000は条件によって変更する。
end
if ~isnan(Ch_light)
    Ch_StimTime_light = Ch_dat_light > thres_light; %6000以上は１、それ以外は０
    Ch_dat_light = Ch_dat_light/max(Ch_dat_light); % とりあえずephysのy軸を1以下くらいにする。!60000は条件によって変更する。
end
Ch_time = linspace(0,(Ch_length-1)/fs,Ch_length); % ephysデータ用の時間スケール


clusters_groups = readtable(f_groups); % cluster_groupsをインポート
clusters_groups2 = [clusters_groups.group];
clusters_groups_id = [clusters_groups.cluster_id];
clusters_groups_good = clusters_groups_id(strcmp(clusters_groups2,'good'));% goodのcluster_idのみ抽出

clear clusters_groups clusters_groups2

for i=1:length(clusters_groups_good) % A_timesのうちgoodのcluster_idのみを抽出できるように準備
    Spike_clusters_goodtemp = Spike_clusters == clusters_groups_good(i); % D_good(i)を含むB_clustersをtrueにする
    if i == 1
        Spike_clusters_goodTF = Spike_clusters_goodtemp;
    else
        Spike_clusters_goodTF = or(Spike_clusters_goodTF, Spike_clusters_goodtemp); % B_goodtempのTrueをB_goodTFに追加
    end
end
Spike_times_good = Spike_times(Spike_clusters_goodTF); % A_timesのうちgoodのclusterのみを抽出
Spike_clusters_good = Spike_clusters(Spike_clusters_goodTF); % B_clustersのうちgoodのclusterのみを抽出

clear Spike_clusters_goodTF Spike_clusters_goodtemp Spike_clusters;

Spike_clusters_good2 = Spike_clusters_good; % プロット用にcluster_idを１番から整数順に改名
for i=1:length(clusters_groups_good)
    Spike_clusters_good2(Spike_clusters_good2==clusters_groups_good(i))=i;
end



%%%%%%%%%%%%%%%%%%%%%%%%%
%Ch_dat_sound is for TYWL04-6 because signals from sound, TTL, light are mixed.
%the below code is to fix this problem.

if strcmp(Mouse_name, 'TYWL04')
    thres_lightTTL=0.67;
    Ch_dat_sound(1.6109e8:1.611e8)=0;
end
if strcmp(Mouse_name, 'TYWL05')
    thres_lightTTL=0.9;
end
if strcmp(Mouse_name, 'TYWL07')
    thres_lightTTL=0.8;
    Ch_dat_sound(1.48e7:1.5e7)=0.1;
    Ch_dat_sound(4.494e7:4.945e7)=0.1;
    Ch_dat_sound(5.295e7:5.3e7)=0.1;
    Ch_dat_sound(9.9e7:9.93e7)=0.1;
    Ch_dat_sound(11.23e7:11.235e7)=0.1;
    Ch_dat_sound(16.98e7:16.995e7)=0.1;
end

if strcmp(Mouse_name, 'TYWL04') | strcmp(Mouse_name, 'TYWL05') | strcmp(Mouse_name, 'TYWL07')




    delay_sound_light=126728;
    delay_trigger_light=216892;

    durTTL_light=151;
    durTTL_sound=155391;
    durTTL_trigger=31;



    temp = Ch_dat_sound > thres_lightTTL;
    [~, loc_lightpulse]=findpeaks(single(temp),'MinPeakDistance',500);
    [~, loc_lightonset]=findpeaks(single(temp),'MinPeakDistance',50000);


    Ch_StimTime_light=zeros(size(Ch_dat_sound));
    Ch_StimTime_trigger=zeros(size(Ch_dat_sound));
    Ch_StimTime_sound=zeros(size(Ch_dat_sound));

    for i=1:length(loc_lightpulse)
    	Ch_StimTime_light(loc_lightpulse(i):loc_lightpulse(i)+durTTL_light)=1;
    end

    for i=1:length(loc_lightonset)
    	Ch_StimTime_trigger(loc_lightonset(i)-delay_trigger_light:loc_lightonset(i)-delay_trigger_light+durTTL_trigger)=1;
    	Ch_StimTime_sound(loc_lightonset(i)-delay_sound_light:loc_lightonset(i)-delay_sound_light+durTTL_sound)=1;
    end

    Ch_StimTime_light=logical(Ch_StimTime_light);
    Ch_StimTime_trigger=logical(Ch_StimTime_trigger);
    Ch_StimTime_sound=logical(Ch_StimTime_sound);

end


save([Mouse_name, '_spike.mat'], 'Ch_StimTime*', 'Ch_time', 'Spike_*good*', 'Ch_dat_sound')