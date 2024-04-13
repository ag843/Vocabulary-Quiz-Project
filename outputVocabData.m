function outputVocabData(vocabData, sessionStats, outFilename)
%OUTPUTVOCABDATA Write vocabulary data to a file with session statistics.
%
%   OUTPUTVOCABDATA(vocabData, sessionStats, outFilename) writes vocabulary
%   data from the cell array vocabData to a file specified by outFilename.
%   The file includes the overall user rating from sessionStats.
%
%   vocabData is a cell array where each row corresponds to one word's data.
%   sessionStats is a 1x4 cell array: {userRating, totalCount, correctCount, history}.
%   outFilename is the name of the file where the data will be written.

    % Determine the number of words in the vocabulary
    [numRows, ~] = size(vocabData);

    % Open the file for writing
    fid = fopen(outFilename, 'w');
    if fid == -1
        error('Failed to open file %s for writing.', outFilename);
    end

    try
        % Write the header with the number of words and user rating
        fprintf(fid, '%d\t%d\n', numRows, sessionStats{1});

        % Write each word's data to the file
        for idx = 1:numRows
            fprintf(fid, '%d\t%d\t%s\t%s\n', ...
                    vocabData{idx, 3}, vocabData{idx, 4}, ...
                    vocabData{idx, 1}, vocabData{idx, 2});
        end
    catch
        % Close file and rethrow error if writing fails
        fclose(fid);
        rethrow(lasterror);
    end

    % Close the file
    fclose(fid);
end
