function directory = mocapDataDir

% MOCAPDATADIR Return the directory where the data is stored.

dirSep = filesep;
directory = ['..' dirSep 'data' dirSep];