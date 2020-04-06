function autoScorerBenchmark092208Narrow(numbUsers)
AS_File = 'C:\Sleepdata\Results\Christine_results_04302008\247\247_FinalAS.xls';
filename1 = 'C:\Sleepdata\Results\Christine_results_04302008\247\TR_2006-8-4_12-42-46_csc16v8_J2Mod.xls';
filename2 = 'C:\Sleepdata\Results\Christine_results_04302008\247\TR_061208_247_ESCompleteMod.xls';
filename3 = 'C:\Sleepdata\Results\Christine_results_04302008\247\TR_2006-8-4_12-42-46_csc16_JMod.xls';
filename4 = 'C:\Sleepdata\Results\Christine_results_04302008\247\TR_247_MegMod.xls';

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
fid = fopen(['C:\Sleepdata\Results\Logic Auto-Scorer v User\' name 'Narrow.xls'],'w');
fprintf(fid,'Total Agreement');
fprintf(fid,'\t');        
fprintf(fid,'Wake');
fprintf(fid,'\t');
fprintf(fid,'Sleep');
fprintf(fid,'\t');
fprintf(fid,'REM');
fprintf(fid,'\n');
fclose(fid);


for j = 1:numbUsers
    fid = fopen(['C:\Sleepdata\Results\Logic Auto-Scorer v User\' name 'Narrow.xls'],'a');
    
    agree1 = 0;
    t=1;
    numberMismatch = zeros(3,8);
    percentMismatch = zeros(3,8);
    for i = 1:3
        switch i
            case 1
                Index = find((user{j}(:,3) == 1)|(user{j}(:,3) == 4));
                s1 = 1; s2 = 4; s3 = 8;
            case 2
                Index = find((user{j}(:,3) == 2)|(user{j}(:,3) == 6));
                s1 = 2; s2 = 6; s3 = 0;
            case 3
                Index = find(user{j}(:,3) == 3);
                s1 = 3; s2 = 0; s3 = 0;
        end
        agree = 0;

        p = length(Index);
        userState = user{j}(Index,3);
        if isempty(userState) == 0
            AutoState = AS(Index,1);

            for k = 1:p
                if (AutoState(k,1) == s1 | AutoState(k,1) == s2| AutoState(k,1) == s3)
                    agree = agree + 1;
                    agree1 = agree1 + 1;
                else
                         switch AutoState(k,1)
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
                            case 7
                                numberMismatch(t,7) =  numberMismatch(t,7) + 1;
                            case 8
                                numberMismatch(t,8) =  numberMismatch(t,8) + 1;
                         end
                end
            end
            stateAgree(t) = agree/p;
            percentMismatch(t,1:8) = numberMismatch(t,1:8)/p;
        else
            stateAgree(t) = -1;
        end
        t = t + 1;
    end
    percentAgree = agree1/n;
      
    fprintf(fid,num2str(percentAgree));
    fprintf(fid,'\t');        
    fprintf(fid,num2str(stateAgree(1)));
    fprintf(fid,'\t');
    fprintf(fid,num2str(stateAgree(2)));
    fprintf(fid,'\t');
    fprintf(fid,num2str(stateAgree(3)));
    fprintf(fid,'\n');
    fprintf(fid,'AW');
    fprintf(fid,'\t');
    fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', percentMismatch(:,1));
    fprintf(fid,'\n');
    fprintf(fid,'QS');
    fprintf(fid,'\t');
    fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', percentMismatch(:,2));
    fprintf(fid,'\n');
    fprintf(fid,'RE');
    fprintf(fid,'\t');
    fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', percentMismatch(:,3));
    fprintf(fid,'\n');
    fprintf(fid,'QW');
    fprintf(fid,'\t');
    fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', percentMismatch(:,4));
    fprintf(fid,'\n');
    fprintf(fid,'UH');
    fprintf(fid,'\t');
    fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', percentMismatch(:,5));
    fprintf(fid,'\n');
    fprintf(fid,'TR');
    fprintf(fid,'\t');
    fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', percentMismatch(:,6));
    fprintf(fid,'\n');
    fprintf(fid,'NS');
    fprintf(fid,'\t');
    fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', percentMismatch(:,7));
    fprintf(fid,'\n');
    fprintf(fid,'IW');
    fprintf(fid,'\t');
    fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t', percentMismatch(:,8));
    fprintf(fid,'\n\n');

    clear percentAgree stateAgree
    fclose(fid);
end

    
    