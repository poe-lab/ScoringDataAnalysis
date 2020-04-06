function UserScorerComparisonsExtreme(numbUsers)
filename1 = 'E:\Results_AW_AT_LM\Experiment1ATMod.xls';
filename2 = 'E:\Results_AW_AT_LM\TR_Exp 1 LM_Mod.xls';
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
fid = fopen(['C:\Sleepdata\Test_Data\Test Data\Scored_Files\File 2\' name 'Xtreme.xls'],'w');
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
fclose(fid);

[rval] = corrcoef([user{1}(:,3) user{2}(:,3)]);

%for j = 1:numbUsers

fid = fopen(['C:\Sleepdata\Test_Data\Test Data\Scored_Files\File 2\' name 'Xtreme.xls'],'a');
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
for i = 1:8
    if i == 7
    else
        agree = 0;
        Index = find(user{1}(:,3) == i);
        p = length(Index);
        numP(i) = p;
        userState = user{1}(Index,3);
        if isempty(userState) == 0
            user2State = user{2}(Index,3);

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
            stateAgree(t) = agree/p;
            %percentMismatch(t,1:6) = numberMismatch(t,1:6)/sum(numberMismatch(t,1:6));
            percentMismatch(t,1:6) = numberMismatch(t,1:6)/numP(i);
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
fprintf(fid,'\n');
for i = 1:6
    fprintf(fid,'\t');
    fprintf(fid,num2str(numP(i)));
end
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
fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'R');
fprintf(fid,'\n');
fprintf(fid,num2str(rval(1,2)));
fprintf(fid,'\n');
clear percentAgree stateAgree
fclose(fid);

% for j = 1:numbUsers
%     REM = [];
%     if user{j}(1,3) == 3
%         REM(1,1) = user{j}(1,2);
%         REM(1,2) = 1;
%         REM(1,3) = 1;
%         r = 1;
%     else
%         r = 0;
%     end
% 
%     for m = 2:n
%         if user{j}(m,3) == 3
%             if user{j}(m-1,3) == 3
%                 REM(r,2) = REM(r,2) + 1;
%             else
%                 r = r + 1;
%                 REM(r,1) = user{j}(m,2);
%                 REM(r,2) = 1;
%             end
%         end
%     end
% 
%     singSeqLength = [];
%     REM(1,3) = length(REM(:,1));
%     if isempty(REM(1,1))== 0
%         singlets = REM(1,3);
%         sequences = 0;
%         inSequence = 0;
%         singSeqLength = [REM(1,1) (REM(1,2)*10) 0];
%     end
% 
%     if isempty(REM(2,1))== 0
%         p = 1;
%         for m = 2:REM(1,3)
%             difference = REM(m,1) - (REM(m-1,1) + 10*REM(m-1,2));
%             if difference > 60
%                 inSequence = 0;
%                 p = p + 1;
%                 singSeqLength(p,1:3) = [REM(m,1) (REM(m,2)*10) 0];
%             else
%                 singlets = singlets - 1;
%                 if inSequence == 0
%                     sequences = sequences + 1;
%                 end
%                 singSeqLength(p,2) = REM(m,1) + REM(m,2)*10 - singSeqLength(p,1);
%                 singSeqLength(p,3) = 1;
%                 inSequence = 1;
%             end
% 
%         end
%     end
% 
%     fid2 = fopen(['C:\Sleepdata\Results\Christine_results_04302008\' name 'REM_EpisodesUser' num2str(j) '.xls'],'a');
% 
%     fprintf(fid2,'REM Start');
%     fprintf(fid2,'\t');
%     fprintf(fid2,'REM Length');
%     fprintf(fid2,'\t');
%     fprintf(fid2,'Total REM Episodes');
%     fprintf(fid2,'\n');
% 
%     s = REM(1,3);
%     for i = 1:s
%         fprintf(fid2,num2str(REM(i,1)));
%         fprintf(fid2,'\t');
%         fprintf(fid2,num2str(REM(i,2)));
%         fprintf(fid2,'\t');
%         fprintf(fid2,num2str(REM(i,3)));
%         fprintf(fid2,'\n');
%     end
% 
% 
%     fprintf(fid2,'Start Time');
%     fprintf(fid2,'\t');
%     fprintf(fid2,'Length (s)');
%     fprintf(fid2,'\t');
%     fprintf(fid2,'Type');
%     fprintf(fid2,'\n');
% 
%     u = length(singSeqLength(:,1));
%     for i = 1:u
%         fprintf(fid2,num2str(singSeqLength(i,1)));
%         fprintf(fid2,'\t');
%         fprintf(fid2,num2str(singSeqLength(i,2)));
%         fprintf(fid2,'\t');
%         if singSeqLength(i,3)==0
%             fprintf(fid2,'Singlet');
%         else
%             fprintf(fid2,'Sequenc');
%         end
%         fprintf(fid2,'\n');
%     end
%     fprintf(fid2,'Total Singlets');
%     fprintf(fid2,'\t');
%     fprintf(fid2,'Total Sequences');
%     fprintf(fid2,'\n');
%     fprintf(fid2, num2str(singlets));
%     fprintf(fid2,'\t');
%     fprintf(fid2, num2str(sequences));
%     fprintf(fid2,'\n');
%     fclose(fid2);
% end    
%end

    
    