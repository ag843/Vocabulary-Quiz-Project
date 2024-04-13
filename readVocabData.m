function [vocabData, uRating] = readVocabData(inFilename)
%READVOCABDATA Read vocabulary data and user rating from a file.
%
%   [vocabData, uRating] = READVOCABDATA(inFilename) reads vocabulary data
%   from the file specified by inFilename. The file's first line contains
%   the number of words and user rating. Each subsequent line contains data
%   for one word.
%
%   inFilename is the name of the input data file.
%   vocabData is a cell array with each row containing data for one word:
%     1. Word
%     2. Definition
%     3. Time-to-answer (tenths of a second)
%     4. Difficulty rating
%   uRating is the user rating for the vocabulary.

    % Open the file for reading
    fid = fopen(inFilename, 'r');
    if fid == -1
        error('Failed to open file %s for reading.', inFilename);
    end
    
    try
        % Read the first line for number of words and user rating
        firstLine = fgetl(fid);
        info = textscan(firstLine, '%f %f', 'Delimiter', '\t');
        numWords = info{1};
        uRating = info{2};

        % Initialize vocabData
        vocabData = cell(numWords, 4);

        % Read each word's data
        for i = 1:numWords
            line = fgetl(fid);
            data = textscan(line, '%f %f %s %s', 'Delimiter', '\t');
            vocabData{i, 3} = data{1}; % Average time-to-answer
            vocabData{i, 4} = data{2}; % Difficulty rating
            vocabData{i, 1} = data{3}{1}; % Word
            vocabData{i, 2} = data{4}{1}; % Definition
        end
    catch err
        % Close file on error and rethrow the error
        fclose(fid);
        rethrow(err);
    end

    % Close the file after reading
    fclose(fid);
end
