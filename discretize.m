function [oh] = discretize(handles)
%function [oh] = discretize(handles)
%discretize data
%handles.inAllData -> contains all data
%on return
% handles.inData -> contains the data
% handles.mapTable -> contains the mapping table

oh = handles;

%copy the num
lastCode = 1; %encoded data
%build the encoding table
wh = waitbar(0.0, 'Discretizing data ... Please wait.');
for j=1:length(oh.catCols) %for each column  
    waitbar(j/length(oh.catCols), wh);
    for i=1:size(oh.inCatData,1) %for each row
        key = oh.inCatData(i,j);
        
        if iscellstr(key)
            key = char(key);
        else
            oh.inData(i,oh.catCols(j)) = NaN;
            continue;
        end;
            
        if isKey(oh.mapTable, key) == 0 %key doesnt exist so add
          oh.mapTable(key) = lastCode;
          oh.mapITable(lastCode) = key;
          oh.inData(i,oh.catCols(j)) = lastCode;
          lastCode = lastCode + 1;
        else %key exists, take the code
            oh.inData(i,oh.catCols(j)) = oh.mapTable(key);
        end; 
    end;
end;
close(wh);

%set the flag
oh.inDataValid = 1; 
end % function
