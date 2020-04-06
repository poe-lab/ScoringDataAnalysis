function autoScorerUserMatrix(numbUsers)
AS_File = 'C:\Sleepdata\Baseline\Auto-Scored Files\LM_Exp05AS_BAG_Corrected';
filename1 = 'TR_Exp 5 LM.xls';
filename2 = 'TR_Exp 11 LM.xls';
filename3 = 'TR_Experiment11Meg.xls';
filename4 = '';
[t_stamps,state]=xlsread(AS_File);
AS_timeStamps = t_stamps(5:end,2);
AS_states = state(5:end,3);
AS_track = state(5:end,4);
clear t_stamps state
for i = 1:numbUsers
    fileTarget = eval(strcat('filename', num2str(i)));
    user{i} = xlsread(['C:\Sleepdata\Baseline\Manually Scored Files\' fileTarget]);
end

n = length(user{1});
AS(1:n,1) = zeros;
for h = 1:n
    AS_states{h,1};
    switch AS_states{h,1}
        case '    AW'
            AS(h,1)=1;
        case '    QS'
            AS(h,1)=2;
        case '    RE'
            AS(h,1)=3;
        case '    QW'
            AS(h,1)=4;
        case '    UH'
            AS(h,1)=5;
        case '    TR'
            AS(h,1)=6;
        case '    NS'
            AS(h,1)=7;
        case '    IW'
            AS(h,1)=8;
    end
end

prompt={'Enter data analysis file name:'};
dlgTitle='Input for file management';
lineNo=1;
answer = inputdlg(prompt,dlgTitle,lineNo);
name=char(answer(1,:));

fid = fopen(['C:\Sleepdata\Baseline\' name 'ASvUserMatrix.xls'],'w');
fprintf(fid,'Auto-Scorer v User');
fprintf(fid,'\n');
fclose(fid);

for j = 1:numbUsers
    fid = fopen(['C:\Sleepdata\Baseline\' name 'ASvUserMatrix.xls'],'a');
    agree = 0;
    for k = 1:n
        if user{j}(k,3) == AS(k,1)
            agree = agree + 1;
        end
    end
    percentAgree = agree/n;

    t=1;
    numberMismatch = zeros(6,7);

    for i = 1:8
        if i == 7
        else
            agree = 0;
            Index = find(user{j}(:,3) == i);
            p = length(Index);
            numP(i) = p;
            userState = user{j}(Index,3);
            if isempty(userState) == 0
                user2State = AS(Index,1);

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
                            case 8
                                numberMismatch(t,7) =  numberMismatch(t,7) + 1;
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
    user2Totals(7) = sum(numberMismatch(:,7));  %Intermediate Waking total scored by Auto-Scorer.

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
    F = eval(strcat('filename', num2str(j)));
    fprintf(fid,F);
    fprintf(fid,'\n');
    fprintf(fid,'Total Agreement');
    fprintf(fid,'\n');
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
    fprintf(fid,'NREM');
    fprintf(fid,'\t');
    fprintf(fid,'%f\t %f\t %f\t %f\t %f\t', numberMismatchRed2(:,2));
    fprintf(fid,num2str(user2RedTotals(2)));
    fprintf(fid,'\t');
    fprintf(fid,num2str(user2vUser1Red(2)));
    fprintf(fid,'\n');
    
    fprintf(fid,'RE');
    fprintf(fid,'\t');
    fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', numberMismatch(:,3));
    fprintf(fid,num2str(user2Totals(3)));
    fprintf(fid,'\t');
    fprintf(fid,num2str(user2vUser1(3)));
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
    fprintf(fid,'Total');
    fprintf(fid,'\t');
    fprintf(fid,'%f\t %f\t %f\t %f\t %f\n', user1RedTotals(:));

    fprintf(fid,'IW');
    fprintf(fid,'\t');
    fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', numberMismatch(:,7));
    fprintf(fid,num2str(user2Totals(7)));
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

    fprintf(fid,'Total');
    fprintf(fid,'\t');
    fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\n', user1Totals(:));

    fprintf(fid,'Agreement Ratio');
    fprintf(fid,'\t');
    fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\n', user1vUser2(:));

    fprintf(fid,'Total Epochs');
    fprintf(fid,'\t');
    fprintf(fid,num2str(totalEpochs));
    fprintf(fid,'\n');
    fprintf(fid,'\n');
    fprintf(fid,'\n');
    fclose(fid);
    clear percentAgree numberMismatch
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          Tracking Data Code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j = 1:numbUsers
    fid = fopen(['C:\Sleepdata\Baseline\' name 'ASvUserTrackingMatrix.xls'],'a');
    agree = 0;
    for k = 1:n
        if user{j}(k,3) == AS(k,1)
            agree = agree + 1;
        end
    end
    percentAgree = agree/n;
    
    t=1;
    numberMismatch = zeros(7,11);
    percentMismatch = zeros(7,11);
    for i = 1:8
        if i == 7
        else
            agree = 0;
            Index = find(user{j}(:,3) == i);
            p = length(Index);
            numP(i) = p;
            userState = user{j}(Index,3);
            if isempty(userState) == 0
                cpuState = AS(Index,1);
                cpuTrack = AS_track(Index,1);
                for k = 1:p
                    if userState(k,1) == cpuState(k,1)
                        agree = agree + 1;
                    else
                         switch cpuTrack{k,1}
                            case 'Q1'
                                numberMismatch(t,1) =  numberMismatch(t,1) + 1;
                            case 'R1'
                                numberMismatch(t,2) =  numberMismatch(t,2) + 1;
                            case 'A1'
                                numberMismatch(t,3) =  numberMismatch(t,3) + 1;
                            case 'U1'
                                numberMismatch(t,4) =  numberMismatch(t,4) + 1;
                            case 'A2'
                                numberMismatch(t,5) =  numberMismatch(t,5) + 1;
                            case 'R2'
                                numberMismatch(t,6) =  numberMismatch(t,6) + 1;
                            case 'W1'
                                numberMismatch(t,7) =  numberMismatch(t,7) + 1;
                            case 'T1'
                                numberMismatch(t,8) =  numberMismatch(t,8) + 1;
                            case 'A3'
                                numberMismatch(t,9) =  numberMismatch(t,9) + 1;
                            case 'W2'
                                numberMismatch(t,10) =  numberMismatch(t,10) + 1;
                            case 'I1'
                                numberMismatch(t,11) =  numberMismatch(t,11) + 1;
                        end
                    end
                end
                stateAgree(t) = agree;
               
            else
                stateAgree(t) = -1;
            end
            t = t + 1;
        end
    end
    numberMismatch = numberMismatch(1:6,:);
    F = eval(strcat('filename', num2str(j)));
    fprintf(fid,F);
    fprintf(fid,'\n');
    fprintf(fid,'Total Agreement');
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
    fprintf(fid,'\n');
    fprintf(fid,num2str(percentAgree));
    fprintf(fid,'\t');        
    fprintf(fid,num2str(stateAgree(1)));
    fprintf(fid,'\t');
    fprintf(fid,num2str(stateAgree(2)));
    fprintf(fid,'\t');
    fprintf(fid,num2str(stateAgree(3)));
    fprintf(fid,'\t');
    fprintf(fid,num2str(stateAgree(4)));
    fprintf(fid,'\t');
    fprintf(fid,num2str(stateAgree(5)));
    fprintf(fid,'\t');
    fprintf(fid,num2str(stateAgree(6)));
    %fprintf(fid,'\t');
    %fprintf(fid,num2str(stateAgree(7)));
    fprintf(fid,'\n');
    fprintf(fid,'Q1');
    fprintf(fid,'\t');
    fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', numberMismatch(:,1));
    fprintf(fid,'\n');
    fprintf(fid,'R1');
    fprintf(fid,'\t');
    fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', numberMismatch(:,2));
    fprintf(fid,'\n');
    fprintf(fid,'A1');
    fprintf(fid,'\t');
    fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', numberMismatch(:,3));
    fprintf(fid,'\n');
    fprintf(fid,'U1');
    fprintf(fid,'\t');
    fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', numberMismatch(:,4));
    fprintf(fid,'\n');
    fprintf(fid,'A2');
    fprintf(fid,'\t');
    fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', numberMismatch(:,5));
    fprintf(fid,'\n');
    fprintf(fid,'R2');
    fprintf(fid,'\t');
    fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', numberMismatch(:,6));
    fprintf(fid,'\n');
    fprintf(fid,'W1');
    fprintf(fid,'\t');
    fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', numberMismatch(:,7));
    fprintf(fid,'\n');
    fprintf(fid,'T1');
    fprintf(fid,'\t');
    fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', numberMismatch(:,8));
    fprintf(fid,'\n');
    fprintf(fid,'A3');
    fprintf(fid,'\t');
    fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', numberMismatch(:,9));
    fprintf(fid,'\n');
    fprintf(fid,'W2');
    fprintf(fid,'\t');
    fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', numberMismatch(:,10));
    fprintf(fid,'\n');
    fprintf(fid,'I1');
    fprintf(fid,'\t');
    fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', numberMismatch(:,11));
    fprintf(fid,'\n');
    fprintf(fid,'\n');
    clear percentAgree stateAgree
    fclose(fid);  
end

    
    