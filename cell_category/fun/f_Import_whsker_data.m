function DATA=f_Import_whsker_data(DATA, Mouse_name, Opt)

Ntrial=size(DATA,1);


%%%Whisker
for i_trial=1:Ntrial
    if matches(Mouse_name, 'TYWL04')
        FN=[Opt.dir_behaviors, Mouse_name, '/Whisker/', num2str(i_trial+1), '.txt'];
    else
        FN=[Opt.dir_behaviors, Mouse_name, '/Whisker/', num2str(i_trial), '.txt'];
    end
    temp=NaN(1,7500);
    if exist(FN)==2
        temp= readmatrix(FN, 'Range',2, 'Delimiter',',');
        temp(end-3:end)=[];
        if length(temp)<7500
            temp=[temp; NaN(7500-length(temp),1)];
        end
    end
    Whisker(i_trial,:) =temp;
end
%protoraction






DATA.Whisk=Whisker;