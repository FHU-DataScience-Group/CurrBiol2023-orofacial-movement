clear
close all

features='protraction_cumwhisk';
%choose from 'pc1', 'protraction', 'cumwhisk', 'protraction_cumwhisk'

save_to_path2=features;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Leave-one-subject-out 
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('features.mat')


for n = 1:MaxN
    test_mask = (sid == n);
    if sum(test_mask) >= 1
        train_mask = (sid ~= n);

        %PCA
        [PCscore, W, ~, M] = fastPCA([cp_spec(train_mask,:); rw_spec(train_mask,:)]);
        spec_load = reshape(W(:,1),[24,10]);
        spec_load2 = reshape(W(:,2),[24,10]);
        if sum(sum(spec_load(5:10,5:end))) < 0
            PCscore(:,1) = -PCscore(:,1); 
            W(:,1) = -W(:,1);
        end
        if sum(sum(spec_load2(6:7,2:8))) > 0
            PCscore(:,2) = -PCscore(:,2);
            W(:,2) = -W(:,2);
        end
        cp_spec_pc1_train = PCscore(1:sum(train_mask),1);
        rw_spec_pc1_train = PCscore(sum(train_mask)+1:end,1);
        cp_spec_pc_test=(cp_spec(test_mask,:)-M)*W;
        rw_spec_pc_test=(rw_spec(test_mask,:)-M)*W;
        cp_spec_pc1_test=cp_spec_pc_test(:,1);
        rw_spec_pc1_test=rw_spec_pc_test(:,1);




        switch features
            case 'pc1';
                Xtrain = [cp_spec_pc1_train; rw_spec_pc1_train];%'
                Xtest = [cp_spec_pc1_test; rw_spec_pc1_test];%'

            case 'protraction';
                Xtrain = [cp_protraction(train_mask); rw_protraction(train_mask)];%'
                Xtest = [cp_protraction(test_mask); rw_protraction(test_mask)];%'

            case 'cumwhisk';
                Xtrain = [cp_cumwhisk(train_mask); rw_cumwhisk(train_mask)];%'
                Xtest = [cp_cumwhisk(test_mask); rw_cumwhisk(test_mask)];%'

            case 'protraction_cumwhisk';
                Xtrain = [cp_protraction(train_mask), cp_cumwhisk(train_mask); rw_protraction(train_mask), rw_cumwhisk(train_mask)];%'
                Xtest = [cp_protraction(test_mask), cp_cumwhisk(test_mask); rw_protraction(test_mask), rw_cumwhisk(test_mask)];%'



        end

        Ytrain = [zeros(sum(train_mask),1); ones(sum(train_mask),1)];
        Ytest = [zeros(sum(test_mask),1); ones(sum(test_mask),1)];




        B = glmfit(Xtrain, Ytrain, 'binomial');

        Ptest_pred = glmval(B,Xtest,'logit');
        Ytest_pred = Ptest_pred >= 0.5;


        % confusion matrix
        Ytest_cat = categorical(Ytest, [1,0], {'CP', 'RW'});
        Ytest_pred_cat = categorical(Ytest_pred, [1,0], {'CP', 'RW'});
        [CMarray, grpOrder] = confusionmat(Ytest_cat, Ytest_pred_cat);
        % 
        cat_label = categories(grpOrder);
        % table
        CMtable = array2table(CMarray, 'VariableNames', cat_label, 'RowNames', cat_label);
     

        TP = diag(CMarray);
        Npred = sum(CMarray,1);
        Nsup = sum(CMarray,2);
        % Accuracy
        accuracy = sum(TP)/sum(Nsup);
        accuracies(n)=accuracy;
        accuracy_table = array2table([accuracy; accuracy], 'VariableNames', {'Accuracy'});


        if ~exist([save_to_path,save_to_path2], 'dir')
            mkdir([save_to_path,save_to_path2]);
        end


        
        if size(Xtest,2)==2
            figure(1);
            clf;
            X1_MIN = min(Xtest(:,1))*1.05;
            X1_MAX = max(Xtest(:,1))*1.05;
            X2_MIN = min(Xtest(:,2))*1.05;
            X2_MAX = max(Xtest(:,2))*1.05;
            [x1,x2] = meshgrid(X1_MIN:(X1_MAX-X1_MIN)/50:X1_MAX, X2_MIN:(X2_MAX-X2_MIN)/50:X2_MAX);
            XX=[x1(:),x2(:)];
            p = x1;
            p(:) = glmval(B,XX,'logit');
            contourf(x1,x2,p,30);
            colormap(cool);
            colorbar;
            caxis([0 1])
            hold on;
            pos_mask = (Ytest == 1);
            neg_mask = ~pos_mask;
            plot(Xtest(pos_mask,1),Xtest(pos_mask,2),'o','MarkerEdgeColor','w','MarkerFaceColor','r','LineWidth',1);
            hold on;
            plot(Xtest(neg_mask,1),Xtest(neg_mask,2),'o','MarkerEdgeColor','w','MarkerFaceColor','b','LineWidth',1);
            hold off;
            xlabel('feature 1');
            ylabel('feature 2');
            title(sprintf('Distribution of test data: %s', mouse_name{n}),'interpreter','none');
            if ~isempty(save_to_path)
                filename = strcat(save_to_path,save_to_path2, '/', sprintf('%s_learned_dist_2d.eps', mouse_name{n}));
                exportgraphics(gcf, filename);
            end

        elseif size(Xtest,2)==1
            figure(1);
            clf;
            h1 = histogram(Xtest(Ytest==1,1));
            hold on;
            h2 = histogram(Xtest(Ytest==0,1));
            hold off;
            h1.Normalization = 'probability';
            %h1.BinWidth = 5;
            h2.Normalization = 'probability';
            %h2.BinWidth = 5;
            title(save_to_path2)
            if ~isempty(save_to_path)
                filename = strcat(save_to_path,save_to_path2, '/', sprintf('%s_learned_dist_1d.eps', mouse_name{n}));
                exportgraphics(gcf, filename);
            end     
        end
    end
end





filename = strcat(save_to_path, sprintf('result_accuracy.xls'));
T=table;
T.test_mouse=[mouse_name'; 'average'];
T.accuracy=[accuracies'; mean(accuracies)];
writetable(T,filename,'sheet', features);






