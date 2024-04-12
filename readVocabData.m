function [vocabData, uRating] = readVocabData(inFilename)
% Read input data file and return the vocabulary data and user rating.
% inFilename is the name of the input data file to be read:
%   * First line of data file:  the number of words in the vocabulary,
%     followed by the user rating for this vocabulary.
%   * Each remaining line is the data for one word in the vocabulary; there
%     are four data items on each line:  the average time-to-answer (in 
%     tenths of a second), the rating of the word, the word, the word's 
%     definition.
%   * Within each line, data items are delimited by tabs.
% vocabData is a 2-d cell array; its number of rows is the number of words 
% in the vocabulary and its number of columns is 4. Each row stores the  
% data for one word in the vocabulary:
%   * The first column of any particular row stores a word
%   * The second column of that row stores the word's definition
%   * The third column of that row stores the average time-to-answer (in 
%     tenths of a second)
%   * The fourth column of that row stores the difficulty rating of the 
%     word
% uRating is the user rating read from line 1 of the data file.
fid=fopen(inFilename,'r');
L= fgetl(fid);
info= textscan(L,'%f %f','delimiter','\t');
numWords=info{1};
vocabData = cell(numWords,4);
uRating=info{2};
for i=1:1:numWords
    L= fgetl(fid); % read a line from the file with identifier fid; L is then a char vector
    info= textscan(L,'%f %f %s %s','delimiter', '\t');
    ca=cellstr2str(info);
    vocabData{i,3}= ca{1}; % t stores the type double vector in cell 1 (the scalar 200 in this case)
    vocabData{i,4}= ca{2}; % r stores the type double vector in cell 2 (the scalar 1000 in this case)
    vocabData{i,1}= ca{3}; % w stores the char vector 3aberrant1
    vocabData{i,2}= ca{4}; % d stores the char vector 4deviating from normal or correct2  
end 
fclose(fid);