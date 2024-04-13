**Vocabulary Quiz Project**

This MATLAB project is designed to facilitate vocabulary learning through interactive quizzes. It includes functions for reading vocabulary data, managing session statistics, presenting questions, and updating vocabulary data based on user responses.

**Features**

Load Vocabulary Data: Read vocabulary data from a file to initialize quiz sessions.
Interactive Quiz Sessions: Present users with vocabulary questions, offering multiple choices and tracking response times.
Dynamic Difficulty Adjustment: Adjust the difficulty based on user performance using an Elo-like rating system.
Session Tracking: Maintain and update session statistics including user ratings and word familiarity.
Project Structure

The project consists of several MATLAB functions working together to manage and run the vocabulary quizzes:

readVocabData.m: Reads vocabulary data from a specified file.
singleQuestion.m: Manages the presentation of a single vocabulary question, collects user input, and displays results.
updateData.m: Updates vocabulary data and session statistics based on the user's answer.
outputVocabData.m: Writes updated vocabulary data and session statistics to a file.

Copyright
Portions of this project are designated as starter code and are derived from Cornell University's CS 1112 class materials. These portions are clearly marked within the code comments as originating from Cornell CS 1112. Use of these materials in this project does not imply endorsement by Cornell University of the other contents of this project.
