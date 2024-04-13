function [vocabData, sessionStats, anotherQ] = singleQuestion(vocabData, sessionStats, numChoices, baseKvalue)
% SINGLEQUESTION Handles the logic for presenting a single vocabulary question.
%
% This function manages the display of a single question from the vocabulary data,
% tracks user responses, and updates session statistics.

    %% Local Function Definitions

    % Finds if the index is already used in the session
    function isFound = wasFound(sessionStats, idx)
        isFound = ismember(idx, sessionStats{4});
    end

    % Finds a random index from a given array
    function idx = randomIndex(array)
        idx = array(randi(length(array)));
    end

    %% Main Code

    % Extract user rating and find the closest word ratings not already used
    uRating = sessionStats{1};
    [minIndices, minDiffs] = findMinDiffs(vocabData, uRating, sessionStats);

    % Randomly pick one of the closest words
    indexOfTestWord = randomIndex(minIndices);

    % Generate choices for the question
    [choices, answerIndex] = generateChoices(vocabData, numChoices, indexOfTestWord);

    % Display the question and capture the user's response
    userInput = displayAndCapture(vocabData{indexOfTestWord, 1}, choices);

    % Check the response and update the session data
    [vocabData, sessionStats, anotherQ] = handleResponse(userInput, answerIndex, vocabData, sessionStats, indexOfTestWord, baseKvalue);

end

%% Supporting Functions

function [minIndices, minDiffs] = findMinDiffs(vocabData, uRating, sessionStats)
    minDiff = inf;
    minIndices = [];
    for i = 1:size(vocabData, 1)
        wordRating = vocabData{i, 4};
        if ~wasFound(sessionStats, i) && abs(uRating - wordRating) <= minDiff
            if abs(uRating - wordRating) < minDiff
                minDiff = abs(uRating - wordRating);
                minIndices = i;
            else
                minIndices(end+1) = i;
            end
        end
    end
end

function [choices, answerIndex] = generateChoices(vocabData, numChoices, indexOfTestWord)
    choices = cell(1, numChoices);
    usedIndices = indexOfTestWord;
    choices{randi(numChoices)} = vocabData{indexOfTestWord, 2}; % Assign correct answer to a random choice

    for i = 1:numChoices
        if isempty(choices{i})
            while true
                idx = randi(size(vocabData, 1));
                if ~ismember(idx, usedIndices)
                    choices{i} = vocabData{idx, 2};
                    usedIndices(end+1) = idx;
                    break;
                end
            end
        end
    end

    answerIndex = find(strcmp(choices, vocabData{indexOfTestWord, 2}));
end

function userInput = displayAndCapture(testWord, choices)
    fprintf('What is the definition of %s?\n', testWord);
    for i = 1:length(choices)
        fprintf('%d. %s\n', i, choices{i});
    end
    tic;
    userInput = input('Enter the number of your answer please: ');
    fprintf('It took you %.1f seconds to solve it\n', toc);
end

function [vocabData, sessionStats, anotherQ] = handleResponse(userInput, answerIndex, vocabData, sessionStats, indexOfTestWord, baseKvalue)
    if userInput == answerIndex
        fprintf('Correct!\n');
        isCorrect = true;
    else
        fprintf('Sorry, the correct answer was %d\n', answerIndex);
        isCorrect = false;
    end
    if userInput > 0 && userInput <= length(choices)
        [vocabData, sessionStats] = updateData(vocabData, sessionStats, indexOfTestWord, isCorrect, toc, baseKvalue);
        anotherQ = 1;
    else
        anotherQ = 0;
    end
end
