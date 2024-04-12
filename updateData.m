function [vocabData, sessionStats]=updateData(vocabData, sessionStats, ...
    wordIdx, isCorrect, timeTaken, baseKvalue)
% Update and return vocabulary data and session statistics given the most
% recent question and user answer.

% Pre:
% vocabData is a cell array; each row stores the data of one word in the
%   vocabulary.
% sessionStats is a cell array containing the statistics of the entire
%   session.
% wordIdx is the index of the word used in the most recent question; it is
%   the row index of that word in vocabData.
% isCorrect is true (1) if user had answered the question correctly; it is
%   false (0) otherwise.
% timeTaken is the actual time, in tenths of a second, user took to answer 
%   the question; it is an integer value.
% baseKvalue:  Base "k value" for determining user and word ratings

% Post:
% vocabData and sessionStats are updated based on correctness and time
%   taken to answer the question.

% *** Write your code below to perform the following tasks: ***
% (1) Calculate new user rating and word rating--call subfunction
%     computeRating.
% (2) Calculate new average time user takes to define the word with index
%     wordIdx.
% (3) Update vocabData and sessionStats.
% The following two statements are dummy initializations of the return 
% parameters; replace them with your code.


[numWords, ~]=size(vocabData);

wordRating=vocabData{wordIdx,4} ;  
userRating=sessionStats{1}; 
aveTimeTaken=vocabData{wordIdx,3}; 

[userRating, wordRating]=computeRating(userRating, wordRating,isCorrect, ...
    timeTaken, aveTimeTaken, baseKvalue);
for i=1:1:numWords
    %word, definition, time to answer, rating
    vocabData{i,3}= aveTimeTaken; 
    vocabData{i,4}= wordRating; 
end 
sessionStats{1}= userRating; 


sessionStats{2}=sessionStats{2}+1; 
if isCorrect==true
    sessionStats{3}=sessionStats{3}+1; 
end
%update reccently used words 
for i=2:1:length(sessionStats{4})-1
    sessionStats{4}(i+1)=sessionStats{4}(i);
end 
sessionStats{4}(1)=wordIdx;
%sessionStats{1} is the user rating
%sessionStats{2} is the total number of questions answered
%sessionStats{3} is the number of questions answered correcly
%sessionStats{4} is a vector storing the indices of the "recently" used words
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DO NOT MODIFY the following subfunction.
function [userRating, wordRating]=computeRating(userRating, wordRating, ...
    isCorrect, timeTaken, aveTimeTaken, baseKvalue)
% Compute and return the new user rating and word rating.
% Pre:
% userRating - User rating before user answered the most recent question
% wordRating - Word rating before user answered most recent question (on
%              that word)
% isCorrect - True (1) if user answered correctly; false(0) otherwise.
% timeTaken - Actual time, in tenths of a second, user took to answer the
%             question.  (An integer value)
% aveTimeTaken - Estimated time, in tenths of a second, for answering the 
%                question.  (An integer value)
% baseKvalue - Base "k value" for determining user and word ratings
% Post:
% userRating and wordRating are updated based on a variant of the Elo 
% rating system.

% Calculate chance that user will get correct answer for this test:
correctChance=userRating/(userRating+wordRating);

% Calculate actual Kvalue and if necessary adjust it to be in the interval
% [0, 1.5*baseKvalue] if the user answers correctly.  If user answers
% incorrectly Kavlue is baseKvalue.
if isCorrect
    Kvalue= baseKvalue+(aveTimeTaken-timeTaken)/10;
    Kvalue= min(max(Kvalue, 0.3*baseKvalue), 1.5*baseKvalue);
else
    Kvalue= baseKvalue;
end

% Update both user rating and word rating
userRating= round(userRating+Kvalue*(isCorrect-correctChance));
wordRating= round(wordRating-Kvalue*(isCorrect-correctChance));
