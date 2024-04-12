function [vocabData, sessionStats, anotherQ]=singleQuestion(vocabData, ...
    sessionStats, numChoices, baseKvalue)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%function wasFound
% finds if the index of the word with the lowest difference between urating
%and wordrating is in the session stats array
function isFound=wasFound(sessionStats,x)
for j=1:15
    if x==sessionStats{4}(j)
        isFound=true;
    else
        isFound=false;
    end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %function randomValue
% % finds a random value in an array
    function valueinArray=RandomValue(arrayUsed)
    wordpresented=randi(length(arrayUsed));
    valueinArray=arrayUsed(wordpresented);
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%2.1
%finds the minimum, or many minimums, of the difference of the Urating and
%wordRating
[rowsofVD, ~]=size(vocabData);
minsoFar=1000;
uRating=sessionStats{1};
% [vocabData, uRating]=readVocabData(inFilename);
for i=1:1:rowsofVD
    wordRating=vocabData{i,4};
    isFound=wasFound(sessionStats,i);
    if abs(uRating-wordRating)<minsoFar
        if isFound==false
           minsoFar=abs(uRating-wordRating);
        end
    end
end 
k=1;
arrayofminvalues=[];
for i=1:1:rowsofVD
    wordRating=vocabData{i,4};
    isFound=wasFound(sessionStats,i);
    if abs(uRating-wordRating)==minsoFar
        if isFound==false
           arrayofminvalues(k)=i;
           k=k+1;
        end
    end
end 
%%randomly picks an index of minimum values out of many minimums
indexOfTestWord=RandomValue(arrayofminvalues);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%2.2

%numChoices is the number of choices to present to the user for this question.
answerIndex=randi(numChoices);

%create cellarray to store definitions 
choices=cell(1,numChoices);
usedIndexes=[];
usedIndexes(1)=indexOfTestWord;
for i=1:1:numChoices 
    alreadyUsed=true;
    while alreadyUsed==true
    %randomly chooses definition from the vocabData
    %defIndex=randi(2,rowsofVD);
    defIndex=randi(rowsofVD);
    %Check if its already been used
    alreadyUsed=false;
        for k=1:length(usedIndexes)
            if defIndex==usedIndexes(k) && defIndex~=answerIndex
                % rect answer 
                alreadyUsed=true;
            end
        end 
    end
    usedIndexes(i)=defIndex;
    choices{i}=vocabData{defIndex,2};
end 
%randomly pick a number and replace definiton at that index with correct
%definiton

choices{answerIndex}=vocabData{indexOfTestWord, 2};

%Display the question by printing elements in the cellarray 
%print the word that is being tested 
fprintf('What is the definition of %s\n',vocabData{indexOfTestWord,1})
%print all the definitions 
for l=1:1:length(choices)
    %adds the number to each 
    fprintf('%d',l)
    defExpression=['. ' choices{l}];
    fprintf('%s\n',defExpression)
end 
%right after displaying the question and possible choices, timer starts

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%2.3
%T is vaulue of timer
tic
userInput=input('enter the number of your answer please: ');
T=toc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%gives response if answer is correct or false
isthisCorrect=false;
if (userInput==answerIndex)
    isthisCorrect=true;
    fprintf('Correct!\n')
    fprintf('It took you %.1f seconds to solve it',T)
    fprintf('\n')
elseif userInput~=answerIndex  && userInput~=0
    fprintf('Sorry, the correct answer was %1.0f\n', answerIndex)
    fprintf('\n')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%2.4
%calls updata data unless user wants to end
if (userInput<=numChoices && userInput~=0)
    [vocabData, sessionStats]=updateData(vocabData,sessionStats, indexOfTestWord, isthisCorrect, T, baseKvalue);
    anotherQ=1;
else 
    anotherQ=0;
end

end
