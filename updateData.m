function [vocabData, sessionStats] = updateData(vocabData, sessionStats, wordIdx, isCorrect, timeTaken, baseKvalue)
%UPDATE DATA - Update and return vocabulary data and session statistics based on recent question and answer.

    % Get current word rating and user rating
    currentWordRating = vocabData{wordIdx, 4};
    currentUserRating = sessionStats{1};
    currentAvgTime = vocabData{wordIdx, 3};

    % Calculate new ratings and average time
    [newUserRating, newWordRating] = computeRating(currentUserRating, currentWordRating, isCorrect, timeTaken, currentAvgTime, baseKvalue);

    % Update the vocabulary data for the current word
    vocabData{wordIdx, 4} = newWordRating;
    
    % Calculate new average time taken
    vocabData{wordIdx, 3} = (currentAvgTime + timeTaken) / 2;

    % Update session stats
    sessionStats{1} = newUserRating;
    sessionStats{2} = sessionStats{2} + 1; % Increment total questions counter
    if isCorrect
        sessionStats{3} = sessionStats{3} + 1; % Increment correct answers counter
    end

    % Update recently used words
    sessionStats{4} = [wordIdx, sessionStats{4}(1:end-1)];

end

% This subfunction is starter code for calculating new ratings using the Elo rating system.
function [userRating, wordRating] = computeRating(userRating, wordRating, isCorrect, timeTaken, aveTimeTaken, baseKvalue)
    % Compute and return the new user rating and word rating based on the Elo rating system.
    correctChance = userRating / (userRating + wordRating);
    if isCorrect
        Kvalue = baseKvalue + (aveTimeTaken - timeTaken) / 10;
        Kvalue = min(max(Kvalue, 0.3 * baseKvalue), 1.5 * baseKvalue);
    else
        Kvalue = baseKvalue;
    end
    userRating = round(userRating + Kvalue * (isCorrect - correctChance));
    wordRating = round(wordRating - Kvalue * (isCorrect - correctChance));
end
