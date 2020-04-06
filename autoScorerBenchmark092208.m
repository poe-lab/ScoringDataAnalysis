function autoScorerBenchmark092208(numbUsers)
AS_File = 'C:\Sleepdata\Test_Data\Test Data\Scored_Files\File 2\File2_LAS_Final.xls';
filename1 = 'C:\Sleepdata\Test_Data\Test Data\Scored_Files\File 2\TR_File2_WL.xls';
filename2 = 'C:\Sleepdata\Test_Data\Test Data\Scored_Files\File 2\TR_File2_MS.xls';
filename3 = 'C:\Sleepdata\Test_Data\Test Data\Scored_Files\File 2\TR_File2_JR.xls';
filename4 = 'C:\Sleepdata\Test_Data\Test Data\Scored_Files\File 2\TR_File2_LM.xls';
[t_stamps,state]=xlsread(AS_File);
AS_timeStamps = t_stamps(5:end,2);
AS_states = state(5:end,3);
AS_track = state(5:end,4);
clear t_stamps state
for i = 1:numbUsers
    user{i} = xlsread(eval(strcat('filename', num2str(i))));
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
fid = fopen(['C:\Sleepdata\Results\Logic Auto-Scorer v User\' name '.xls'],'w');
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
fprintf(fid,'\t');
fprintf(fid,'IW');
fprintf(fid,'\n');
fclose(fid);


for j = 1:numbUsers
    fid = fopen(['C:\Sleepdata\Results\Logic Auto-Scorer v User\' name '.xls'],'a');
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
                stateAgree(t) = agree/p;
                percentMismatch(t,1:11) = numberMismatch(t,1:11)/numP(i);
            else
                stateAgree(t) = -1;
            end
            t = t + 1;
        end
    end
    
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
    fprintf(fid,'\t');
    fprintf(fid,num2str(stateAgree(7)));
    fprintf(fid,'\n');
    fprintf(fid,'Q1');
    fprintf(fid,'\t');
    fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', percentMismatch(:,1));
    fprintf(fid,'\n');
    fprintf(fid,'R1');
    fprintf(fid,'\t');
    fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', percentMismatch(:,2));
    fprintf(fid,'\n');
    fprintf(fid,'A1');
    fprintf(fid,'\t');
    fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', percentMismatch(:,3));
    fprintf(fid,'\n');
    fprintf(fid,'U1');
    fprintf(fid,'\t');
    fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', percentMismatch(:,4));
    fprintf(fid,'\n');
    fprintf(fid,'A2');
    fprintf(fid,'\t');
    fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', percentMismatch(:,5));
    fprintf(fid,'\n');
    fprintf(fid,'R2');
    fprintf(fid,'\t');
    fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', percentMismatch(:,6));
    fprintf(fid,'\n');
    fprintf(fid,'W1');
    fprintf(fid,'\t');
    fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', percentMismatch(:,7));
    fprintf(fid,'\n');
    fprintf(fid,'T1');
    fprintf(fid,'\t');
    fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', percentMismatch(:,8));
    fprintf(fid,'\n');
    fprintf(fid,'A3');
    fprintf(fid,'\t');
    fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', percentMismatch(:,9));
    fprintf(fid,'\n');
    fprintf(fid,'W2');
    fprintf(fid,'\t');
    fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', percentMismatch(:,10));
    fprintf(fid,'\n');
    fprintf(fid,'I1');
    fprintf(fid,'\t');
    fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', percentMismatch(:,11));
    fprintf(fid,'\n');
    fprintf(fid,'\n');
    clear percentAgree stateAgree
    fclose(fid);  
end

    
    