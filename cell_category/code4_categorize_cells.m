Mouse_names={'TYTM656','TYWL04','TYWL05','TYWL07'};
Nmouse=length(Mouse_names);

Cell_categorized=[];
Cell_categorized_noPreWhisk=[];
Cell_response_type=[];

thres_cell_ignore=0;


for i_mouse=1:Nmouse
Mouse_name=Mouse_names{i_mouse};

if strcmp(Mouse_name,'TYTM656')
	[Cell_categorized_mouse_noPreWhisk{i_mouse}]=f_categorize_cells(DATA1, Opt);

elseif strcmp(Mouse_name,'TYWL04')
	[Cell_categorized_mouse_noPreWhisk{i_mouse}]=f_categorize_cells(DATA2, Opt);

elseif strcmp(Mouse_name,'TYWL05')
	[Cell_categorized_mouse_noPreWhisk{i_mouse}]=f_categorize_cells(DATA3, Opt);

elseif strcmp(Mouse_name,'TYWL07')
	[Cell_categorized_mouse_noPreWhisk{i_mouse}]=f_categorize_cells(DATA4, Opt);

end


end








for i_mouse=1:Nmouse
    
    
        %cell type based on corr between zscore of cell firing and whisk mvmnt
        
        corr_whiskVar_light_zscore{i_mouse}=Cell_categorized_mouse_noPreWhisk{i_mouse}.corr_whiskVar_light_zscore;
        corr_whiskProtrct_sound_zscore{i_mouse}=Cell_categorized_mouse_noPreWhisk{i_mouse}.corr_whiskProtrct_sound_zscore;
        
        
             index_cell_ignore_corr{i_mouse}=corr_whiskVar_light_zscore{i_mouse}<thres_cell_ignore &corr_whiskVar_light_zscore{i_mouse}>-thres_cell_ignore & corr_whiskProtrct_sound_zscore{i_mouse}<thres_cell_ignore &corr_whiskProtrct_sound_zscore{i_mouse}>-thres_cell_ignore ;
            index_cell_OK_corr{i_mouse}=~index_cell_ignore_corr{i_mouse};

        

        
            
            %whiskPrtVar_cellact_zscore
            celltype_sound=Cell_categorized_mouse_noPreWhisk{i_mouse}.corr_pval_whiskProtrct_sound_zscore<0.05 & Cell_categorized_mouse_noPreWhisk{i_mouse}.corr_whiskProtrct_sound_zscore>0;
            celltype_light=Cell_categorized_mouse_noPreWhisk{i_mouse}.corr_pval_whiskVar_light_zscore<0.05 & Cell_categorized_mouse_noPreWhisk{i_mouse}.corr_whiskVar_light_zscore>0;
            index_cell_OK_corr{i_mouse}=true(size(celltype_sound));
            
         
          
        CellType{i_mouse}=celltype_sound+celltype_light*2;
     
       T_cell=table(index_cell_OK_corr{i_mouse}, 'VariableNames', {'above thes'});
    T_cell=addvars(T_cell, CellType{i_mouse}, 'NewVariableNames', 'type');
    
    writetable(T_cell, ['summary_results_cell_trials.xls'], 'sheet', [Mouse_names{i_mouse}, '_Cell'])

end %for i_mouse







figure
hold on
for i_mouse=[1,2,3,4]
    scatter(Cell_categorized_mouse_noPreWhisk{i_mouse}.corr_whiskProtrct_sound_zscore(CellType{i_mouse}==1), Cell_categorized_mouse_noPreWhisk{i_mouse}.corr_whiskVar_light_zscore(CellType{i_mouse}==1), 'g',"filled")
    scatter(Cell_categorized_mouse_noPreWhisk{i_mouse}.corr_whiskProtrct_sound_zscore(CellType{i_mouse}==2), Cell_categorized_mouse_noPreWhisk{i_mouse}.corr_whiskVar_light_zscore(CellType{i_mouse}==2), 'b',"filled")
    scatter(Cell_categorized_mouse_noPreWhisk{i_mouse}.corr_whiskProtrct_sound_zscore(CellType{i_mouse}==3), Cell_categorized_mouse_noPreWhisk{i_mouse}.corr_whiskVar_light_zscore(CellType{i_mouse}==3), 'r',"filled")
    scatter(Cell_categorized_mouse_noPreWhisk{i_mouse}.corr_whiskProtrct_sound_zscore(CellType{i_mouse}==0), Cell_categorized_mouse_noPreWhisk{i_mouse}.corr_whiskVar_light_zscore(CellType{i_mouse}==0), 'k',"filled")
end
exportgraphics(gcf,'Fig6E.eps')
