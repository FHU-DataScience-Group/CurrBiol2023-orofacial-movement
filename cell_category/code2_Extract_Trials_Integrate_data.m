Mouse_name='TYTM656';
DATA1=f_Extract_Trials(Mouse_name, Opt);
DATA1=f_Import_whsker_data(DATA1, Mouse_name, Opt);


Mouse_name='TYWL04'; 
[DATA2]=f_Extract_Trials(Mouse_name, Opt);
DATA2=f_Import_whsker_data(DATA2, Mouse_name, Opt);

Mouse_name='TYWL05'; 
[DATA3]=f_Extract_Trials(Mouse_name, Opt);
DATA3=f_Import_whsker_data(DATA3, Mouse_name, Opt);

Mouse_name='TYWL07'; 
[DATA4]=f_Extract_Trials(Mouse_name, Opt);
DATA4=f_Import_whsker_data(DATA4, Mouse_name, Opt);




FN='Behaviours.xlsx';
T656 = readtable([FN],'Sheet', 'TYTM656');
T04 = readtable([FN],'Sheet', 'TYWL04');
T05 = readtable([FN],'Sheet', 'TYWL05');
T07 = readtable([FN],'Sheet', 'TYWL07');


for i=1:size(T656, 1)
	if strcmp(T656.PreS(i), 'no')
		DATA1.PreS(i)=1;
	else
		DATA1.PreS(i)=0;
	end
end	

for i=1:size(T04, 1)-1
	if strcmp(T04.PreS(i+1), 'no')
		DATA2.PreS(i)=1;
	else
		DATA2.PreS(i)=0;
	end
end	


for i=1:size(T05, 1)
	if strcmp(T05.PreS(i), 'no')
		DATA3.PreS(i)=1;
	else
		DATA3.PreS(i)=0;
	end
end	


for i=1:size(T07, 1)
	if strcmp(T07.PreS(i), 'no')
		DATA4.PreS(i)=1;
	else
		DATA4.PreS(i)=0;
	end
end	


DATA3(30,:)=[];



save(['DATA.mat'], 'DATA*', 'Opt','-v7.3')
