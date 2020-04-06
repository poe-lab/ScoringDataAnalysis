function UserComparisonsMatrix1Wake(numbUsers)
filename1 = 'C:\Users\Brooks\Google Drive\AirPuffExperiment\Results\AirPuffSleepScoredResults\Rat1231\LightCycle\4-GentleHandling\C_Rat1231LightCycle03142014_Kaustubh_KatherineCOMPLETE07292014.xls';
filename2 = 'C:\Users\Brooks\Google Drive\AirPuffExperiment\Results\AirPuffSleepScoredResults\Rat1231\LightCycle\4-GentleHandling\Rat1231LightCycle03142014_Kaustubh.xls';
% filename1 = 'C:\Sleepdata\Results\0420TR_GP_ctxSec1_2(1).xls';
% 
% filename2 = 'C:\Sleepdata\Results\0420TR_GP_Attempt1.xls';

filename3 = '';

for i = 1:numbUsers
    [numData, stringData] = xlsread(eval(strcat('filename', num2str(i))));
    %need to add an if statement so that corrected or manually scored files
    %can be compared
    if isequal(size(numData,2),3)
        user{i} = numData(:,3);
        clear numData stringData
    else
        clear numData
        stringData = stringData(3:end,3);
        [stateNumber] = stateLetter2NumberConverter(stringData);
        user{i} = stateNumber;
        clear stateNumber stringData
    end
end

n = length(user{1});

prompt={'Enter data analysis file name:'};
dlgTitle='Input for file management';
lineNo=1;
answer = inputdlg(prompt,dlgTitle,lineNo);
name=char(answer(1,:));
fid = fopen(['C:\Sleepdata\' name 'Matrix.xls'],'w');
fprintf(fid,'Total Agreement');
fprintf(fid,'\n');
fclose(fid);

fid = fopen(['C:\Sleepdata\' name 'Matrix.xls'],'a');
agree = 0;
for k = 1:n
    if user{1}(k,1) == user{2}(k,1)
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
        Index = find(user{a}(:,1) == i);
        p = length(Index);
        numP(i) = p;
        userState = user{a}(Index,1);
        if isempty(userState) == 0
            user2State = user{b}(Index,1);

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

numberMismatchRed = zeros(6,5);
for i = 1:6
    numberMismatchRed(i,1:5) = [(numberMismatch(i,1) + numberMismatch(i,4)) numberMismatch(i,2:3) numberMismatch(i,5:6)];
end
numberMismatchRed2 = zeros(5,5);
numberMismatchRed2(1,:) = numberMismatchRed(1,:) + numberMismatchRed(4,:);
numberMismatchRed2(2:5,:) = [numberMismatchRed(2:3,:); numberMismatchRed(5:6,:)];
clear numberMismatchRed
totalAgreeRed = 0;
for i = 1:5
    user1RedTotals(i) = sum(numberMismatchRed2(i,:));
    user2RedTotals(i) = sum(numberMismatchRed2(:,i));
    user1vUser2Red(i) = numberMismatchRed2(i,i)/user1RedTotals(i);
    user2vUser1Red(i) = numberMismatchRed2(i,i)/user2RedTotals(i);
    totalAgreeRed = totalAgreeRed + numberMismatchRed2(i,i);
end
totalEpochRed = sum(user1RedTotals);
percentAgreeRed = totalAgreeRed/totalEpochRed;

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
fprintf(fid,'\t');
fprintf(fid,'\t');
fprintf(fid,'\t');
fprintf(fid,'\t');
fprintf(fid,'\t');
fprintf(fid,'Wake');
fprintf(fid,'\t');
fprintf(fid,'NonREM');
fprintf(fid,'\t');
fprintf(fid,'REM');
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
fprintf(fid,'\t');
fprintf(fid,'\t');
fprintf(fid,'\t');
fprintf(fid,'\t');
fprintf(fid,'Wake');
fprintf(fid,'\t');
fprintf(fid,'%f\t %f\t %f\t %f\t %f\t', numberMismatchRed2(:,1));
fprintf(fid,num2str(user2RedTotals(1)));
fprintf(fid,'\t');
fprintf(fid,num2str(user2vUser1Red(1)));
fprintf(fid,'\n');

fprintf(fid,'QS');
fprintf(fid,'\t');
fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', numberMismatch(:,2));
fprintf(fid,num2str(user2Totals(2)));
fprintf(fid,'\t');
fprintf(fid,num2str(user2vUser1(2)));
fprintf(fid,'\t');
fprintf(fid,'\t');
fprintf(fid,'\t');
fprintf(fid,'\t');
fprintf(fid,'NREM');
fprintf(fid,'\t');
fprintf(fid,'%f\t %f\t %f\t %f\t %f\t', numberMismatchRed2(:,2));
fprintf(fid,num2str(user2RedTotals(2)));
fprintf(fid,'\t');
fprintf(fid,num2str(user2vUser1Red(2)));fprintf(fid,'\n');

fprintf(fid,'RE');
fprintf(fid,'\t');
fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', numberMismatch(:,3));
fprintf(fid,num2str(user2Totals(3)));
fprintf(fid,'\t');
fprintf(fid,num2str(user2vUser1(3)));
fprintf(fid,'\t');
fprintf(fid,'\t');
fprintf(fid,'\t');
fprintf(fid,'\t');
fprintf(fid,'REM');
fprintf(fid,'\t');
fprintf(fid,'%f\t %f\t %f\t %f\t %f\t', numberMismatchRed2(:,3));
fprintf(fid,num2str(user2RedTotals(3)));
fprintf(fid,'\t');
fprintf(fid,num2str(user2vUser1Red(3)));
fprintf(fid,'\n');

fprintf(fid,'QW');
fprintf(fid,'\t');
fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', numberMismatch(:,4));
fprintf(fid,num2str(user2Totals(4)));
fprintf(fid,'\t');
fprintf(fid,num2str(user2vUser1(4)));
fprintf(fid,'\t');
fprintf(fid,'\t');
fprintf(fid,'\t');
fprintf(fid,'\t');
fprintf(fid,'UH');
fprintf(fid,'\t');
fprintf(fid,'%f\t %f\t %f\t %f\t %f\t', numberMismatchRed2(:,4));
fprintf(fid,num2str(user2RedTotals(4)));
fprintf(fid,'\t');
fprintf(fid,num2str(user2vUser1Red(4)));
fprintf(fid,'\n');

fprintf(fid,'UH');
fprintf(fid,'\t');
fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', numberMismatch(:,5));
fprintf(fid,num2str(user2Totals(5)));
fprintf(fid,'\t');
fprintf(fid,num2str(user2vUser1(5)));
fprintf(fid,'\t');
fprintf(fid,'\t');
fprintf(fid,'\t');
fprintf(fid,'\t');
fprintf(fid,'TR');
fprintf(fid,'\t');
fprintf(fid,'%f\t %f\t %f\t %f\t %f\t', numberMismatchRed2(:,5));
fprintf(fid,num2str(user2RedTotals(5)));
fprintf(fid,'\t');
fprintf(fid,num2str(user2vUser1Red(5)));
fprintf(fid,'\n');

fprintf(fid,'TR');
fprintf(fid,'\t');
fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', numberMismatch(:,6));
fprintf(fid,num2str(user2Totals(6)));
fprintf(fid,'\t');
fprintf(fid,num2str(user2vUser1(6)));
fprintf(fid,'\t');
fprintf(fid,'\t');
fprintf(fid,'\t');
fprintf(fid,'\t');
fprintf(fid,'Total');
fprintf(fid,'\t');
fprintf(fid,'%f\t %f\t %f\t %f\t %f\n', user1RedTotals(:));


fprintf(fid,'Total');
fprintf(fid,'\t');
fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', user1Totals(:));
fprintf(fid,'\t');
fprintf(fid,'\t');
fprintf(fid,'\t');
fprintf(fid,'\t');
fprintf(fid,'\t');
fprintf(fid,'Agree Ratio');
fprintf(fid,'\t');
fprintf(fid,'%f\t %f\t %f\t %f\t %f\t', user1vUser2Red(:));
fprintf(fid,'\t');
fprintf(fid,'Total Agree');
fprintf(fid,'\t');
fprintf(fid,num2str(percentAgreeRed));
fprintf(fid,'\n');

fprintf(fid,'Agreement Ratio');
fprintf(fid,'\t');
fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\n', user1vUser2(:));

fprintf(fid,'Total Epochs');
fprintf(fid,'\t');
fprintf(fid,num2str(totalEpochs));
clear percentAgree stateAgree
fclose(fid);