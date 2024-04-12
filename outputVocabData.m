function outputVocabData(vocabData, sessionStats, outFilename)
% Write all vocabulary data, including the user rating for the data, to file.
% vocabData is a cell array; each row stores the data of one word in the
%   vocabulary.
% sessionStats is the 1x4 cell array containing the statistics of the 
%   entire session; it is organized as:
%   {userRating, totalCount, correctCount, history}
% outFilename names the output data file to be written:
%   * output data file has the same format and the same number of lines as
%     the input data file used to start the session.
%   * First line of data file:  the number of words in the vocabulary,
%     followed by the user rating for this vocabulary at the end of the
%     session.
%   * Each remaining line is the data for one word in the vocabulary.  The
%     estimated time and word rating for each word reflect the result of
%     the session.
%   * Within each line, data items are delimited by tabs.

% Write you code below.
[nr,~]=size(vocabData);
fid=fopen(outFilename, 'w');
fprintf(fid,'%d\t',nr);
fprintf(fid,'%d\n',sessionStats{1});

%Prints information in vocabData to the selected file 
for r=1:nr
    fprintf(fid,'%d\t',vocabData{r,3});
    fprintf(fid,'%d\t',vocabData{r,4});
    fprintf(fid,'%s\t',vocabData{r,1});
    fprintf(fid,'%s\n',vocabData{r,2});
end 

fclose(fid);

