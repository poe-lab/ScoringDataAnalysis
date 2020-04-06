function UserScorerComparisonsMatrix(numbUsers)
filename1 = 'E:\Results_AW_AT_LM\Experiment6ATMod.xls';

filename2 = 'E:\Results_AW_AT_LM\TR_Exp 6 AW.xls';
%filename2 = 'E:\Results_AW_AT_LM\TR_Exp 6 LM.xls';
filename3 = '';

for i = 1:numbUsers
    user{i} = xlsread(eval(strcat('filename', num2str(i))));
end

n = length(user{1});

prompt={'Enter data analysis file name:'};
dlgTitle='Input for file management';
lineNo=1;
answer = inputdlg(prompt,dlgTitle,lineNo);
name=char(answer(1,:));
fid = fopen(['C:\Sleepdata\Baseline\' name 'Matrix.xls'],'w');
fprintf(fid,'Total Agreement');
fprintf(fid,'\n');
fclose(fid);

fid = fopen(['C:\Sleepdata\Baseline\' name 'Matrix.xls'],'a');
agree = 0;
for k = 1:n
    if user{1}(k,3) == user{2}(k,3)
        agree = agree + 1;
    end
end
percentAgree = agree/n;

t=1;
numberMismatch = zeros(6,6);
percentMismatch = zeros(6,6);
a = 1;
b = 2;
    
for i = 1:8
    if i == 7
    else
        agree = 0;
        Index = find(user{a}(:,3) == i);
        p = length(Index);
        numP(i) = p;
        userState = user{a}(Index,3);
        if isempty(userState) == 0
            user2State = user{b}(Index,3);

            for k = 1:p
                if userState(k,1) == user2State(k,1)
                    agree = agree + 1;
                else
                     switch user2State(k,1)
                        case 1
                            numberMismatch(t,1) =  numberMismatch(t,1) + 1;
                        case 2
                            numberMismatch(t,2) =  numberMismatch(t,2) + 1;
                        case 3
                            numberMismatch(t,3) =  numberMismatch(t,3) + 1;
                        case 4
                            numberMismatch(t,4) =  numberMismatch(t,4) + 1;
                        case 5
                            numberMismatch(t,5) =  numberMismatch(t,5) + 1;
                        case 6
                            numberMismatch(t,6) =  numberMismatch(t,6) + 1;  
                     end
                end
            end
        numberMismatch(t,t) = agree;
        end
        t = t + 1;
    end
end

for i = 1:6
    user1Totals(i) = sum(numberMismatch(i,:));
    user2Totals(i) = sum(numberMismatch(:,i));
    user1vUser2(i) = numberMismatch(i,i)/user1Totals(i);
    user2vUser1(i) = numberMismatch(i,i)/user2Totals(i);
end
totalEpochs = sum(user1Totals(:));
fprintf(fid,num2str(percentAgree));
fprintf(fid,'\n');
fprintf(fid,'\t');
fprintf(fid,'AW');
fprintf(fid,'\t');
fprintf(fid,'QS');
fprintf(fid,'\t');
fprintf(fid,'RE');
fprintf(fid,'\t');
fprintf(fid,'QW');
fprintf(fid,'\t');
fprintf(fid,'UH');
fprintf(fid,'\t');
fprintf(fid,'TR');
fprintf(fid,'\t');
fprintf(fid,'Total');
fprintf(fid,'\t');
fprintf(fid,'Agreement Ratio');
fprintf(fid,'\n');

fprintf(fid,'AW');
fprintf(fid,'\t');
fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', numberMismatch(:,1));

fprintf(fid,num2str(user2Totals(1)));
fprintf(fid,'\t');
fprintf(fid,num2str(user2vUser1(1)));
fprintf(fid,'\n');
fprintf(fid,'QS');
fprintf(fid,'\t');
fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', numberMismatch(:,2));

fprintf(fid,num2str(user2Totals(2)));
fprintf(fid,'\t');
fprintf(fid,num2str(user2vUser1(2)));
fprintf(fid,'\n');
fprintf(fid,'RE');
fprintf(fid,'\t');
fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', numberMismatch(:,3));

fprintf(fid,num2str(user2Totals(3)));
fprintf(fid,'\t');
fprintf(fid,num2str(user2vUser1(3)));
fprintf(fid,'\n');
fprintf(fid,'QW');
fprintf(fid,'\t');
fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', numberMismatch(:,4));

fprintf(fid,num2str(user2Totals(4)));
fprintf(fid,'\t');
fprintf(fid,num2str(user2vUser1(4)));
fprintf(fid,'\n');
fprintf(fid,'UH');
fprintf(fid,'\t');
fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', numberMismatch(:,5));

fprintf(fid,num2str(user2Totals(5)));
fprintf(fid,'\t');
fprintf(fid,num2str(user2vUser1(5)));
fprintf(fid,'\n');
fprintf(fid,'TR');
fprintf(fid,'\t');
fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', numberMismatch(:,6));

fprintf(fid,num2str(user2Totals(6)));
fprintf(fid,'\t');
fprintf(fid,num2str(user2vUser1(6)));
fprintf(fid,'\n');
fprintf(fid,'Total');
fprintf(fid,'\t');
fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\n', user1Totals(:));

fprintf(fid,'Agreement Ratio');
fprintf(fid,'\t');
fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\n', user1vUser2(:));

fprintf(fid,'Total Epochs');
fprintf(fid,'\t');
fprintf(fid,num2str(totalEpochs));
clear percentAgree stateAgree
fclose(fid);