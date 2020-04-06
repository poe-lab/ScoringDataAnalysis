function InterScorerAgreementAnalysis
%               Created on 08.01.2014 by Brooks A. Gross
% DESCRIPTION: This program is used to compare the agreement between scored files and
% provides percent agreement of each relative to the other.  The resulting
% matrices in the Excel spreadsheet: Column totals are for the first scored
% file, and row totals are for the second scored file. When looking at rows
% of states of a given column, the reviewer can see what the second scorer
% scored the epochs as when the first scorer scored it as the state labeled
% for that column.
% This program is based off of 'UserComparisonsMatrix1Wake.m' created by
% Brooks A. Gross.

working_dir = pwd;

% Call the first scored file:
current_dir='C:\SleepData';
cd(current_dir);
fileSelectedCheck = 0;

% Keep asking until a file is selected:
while isequal(fileSelectedCheck,0)
    [scoredFile{1}, scoredPath{1}] = uigetfile({'*.xls','Sleep Scored File (*.xls)'},...
        'Select the first scored file for comparison');
    if isequal(scoredFile{1},0) || isequal(scoredPath{1},0)
        uiwait(errordlg('You need to select a file. Please press the button again',...
            'ERROR','modal'));
        cd(current_dir);
    else
        filename1 = fullfile(scoredPath{1}, scoredFile{1});
        try
            [numData, stringData] = xlsread(filename1);
            fileSelectedCheck = 1;
            cd(working_dir);
            if isequal(size(numData,2),3)
                user{1} = numData(:,3);
                clear numData stringData
            else
                clear numData
                stringData = stringData(3:end,3);
                [stateNumber] = stateLetter2NumberConverter(stringData);
                user{1} = stateNumber;
                clear stateNumber stringData
            end
        catch %#ok<*CTCH>
            % If file fails to load, it will notify user and prompt to
            % choose another file.
            uiwait(errordlg('Check if the scored file is saved in Microsoft Excel format.',...
             'ERROR','modal'));
            fileSelectedCheck = 0;
        end
    end
end

% Call the second scored file:
cd(current_dir);
fileSelectedCheck = 0;
% Keep asking until a file is selected:
while isequal(fileSelectedCheck,0)
    [scoredFile{2}, scoredPath{2}] = uigetfile({'*.xls','Sleep Scored File (*.xls)'},...
        'Select the second scored file for comparison');
    if isequal(scoredFile{2},0) || isequal(scoredPath{2},0)
        uiwait(errordlg('You need to select a file. Please press the button again',...
            'ERROR','modal'));
        cd(current_dir);
    else
        filename2= fullfile(scoredPath{2}, scoredFile{2});
        try
            [numData, stringData] = xlsread(filename2);
            fileSelectedCheck = 1;
            cd(working_dir);
            if isequal(size(numData,2),3)
                user{2} = numData(:,3);
                clear numData stringData
            else
                clear numData
                stringData = stringData(3:end,3);
                [stateNumber] = stateLetter2NumberConverter(stringData);
                user{2} = stateNumber;
                clear stateNumber stringData
            end
        catch %#ok<*CTCH>
            % If file fails to load, it will notify user and prompt to
            % choose another file.
            uiwait(errordlg('Check if the scored file is saved in Microsoft Excel format.',...
             'ERROR','modal'));
            fileSelectedCheck = 0;
        end
    end
end

n = length(user{1});


agree = 0;
for k = 1:n
    if user{1}(k,1) == user{2}(k,1)
        agree = agree + 1;
    end
end
percentAgree = agree/n;

t=1;
numberMismatch = zeros(6,6);

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

numberMismatchRed = zeros(6,4);
for i = 1:6
    numberMismatchRed(i,1:4) = [(numberMismatch(i,1) + numberMismatch(i,4)) (numberMismatch(i,2) + numberMismatch(i,6)) numberMismatch(i,3) numberMismatch(i,5)];
end
numberMismatchRed2 = zeros(4,4);
numberMismatchRed2(1,:) = numberMismatchRed(1,:) + numberMismatchRed(4,:);
numberMismatchRed2(2,:) = numberMismatchRed(2,:) + numberMismatchRed(6,:);
numberMismatchRed2(3:4,:) = [numberMismatchRed(3,:); numberMismatchRed(5,:)];
clear numberMismatchRed
totalAgreeRed = 0;
for i = 1:4
    user1RedTotals(i) = sum(numberMismatchRed2(i,:));
    user2RedTotals(i) = sum(numberMismatchRed2(:,i));
    user1vUser2Red(i) = numberMismatchRed2(i,i)/user1RedTotals(i);
    user2vUser1Red(i) = numberMismatchRed2(i,i)/user2RedTotals(i);
    totalAgreeRed = totalAgreeRed + numberMismatchRed2(i,i);
end
totalEpochRed = sum(user1RedTotals);
percentAgreeRed = totalAgreeRed/totalEpochRed;

totalEpochs = sum(user1Totals(:));


prompt={'Enter data analysis file name:'};
dlgTitle='Input for file management';
lineNo=1;
answer = inputdlg(prompt,dlgTitle,lineNo);
name=char(answer(1,:));
% Full results sheet separating all states:
resultsFilename = ['C:\Sleepdata\' name 'Matrix.xls'];
warning off MATLAB:xlswrite:AddSheet
sheetName = 'Info';
rowHeaders = {'File1';'File2'};
xlswrite(resultsFilename,rowHeaders, sheetName, 'A1');
xlswrite(resultsFilename,{scoredFile{1}; scoredFile{2}}, sheetName, 'B1');

columnHeaders = {'AW','QS','RE','QW','UH','TR','Scorer1Total','AgreementRatio2v1'};
rowHeaders = {'AW';'QS';'RE';'QW';'UH';'TR';'Scorer2Total';'AgreementRatio1v2'};
sheetName = 'Results';
xlswrite(resultsFilename,columnHeaders, sheetName, 'B1');
xlswrite(resultsFilename,rowHeaders, sheetName, 'A2');
xlswrite(resultsFilename,[numberMismatch user1Totals' user2vUser1'], sheetName, 'B2');
xlswrite(resultsFilename,[user2Totals; user1vUser2], sheetName, 'B8');

rowHeaders = {'TotalEpochs';'TotalAgreement'};
xlswrite(resultsFilename,rowHeaders, sheetName, 'A10');
xlswrite(resultsFilename, [totalEpochs; percentAgree], sheetName, 'B10');


% Narrowed results sheet combining AW w/QW and QS w/TR:
sheetName = 'Narrow';
columnHeaders = {'Awake','NonREM','REM','UH','Scorer1Total','AgreementRatio2v1'};
rowHeaders = {'Awake';'NonREM';'REM';'UH';'Scorer2Total';'AgreementRatio1v2'};

xlswrite(resultsFilename,columnHeaders, sheetName, 'B1');
xlswrite(resultsFilename,rowHeaders, sheetName, 'A2');
xlswrite(resultsFilename,[numberMismatchRed2 user1RedTotals' user2vUser1Red'], sheetName, 'B2');
xlswrite(resultsFilename,[user2RedTotals; user1vUser2Red], sheetName, 'B6');

rowHeaders = {'TotalEpochs';'TotalAgreement'};
xlswrite(resultsFilename,rowHeaders, sheetName, 'A8');
xlswrite(resultsFilename, [totalEpochRed; percentAgreeRed], sheetName, 'B8');