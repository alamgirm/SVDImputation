function [imAllData] = de_discretize(handles)
%function [oh] = de_discretize(handles)
%de_discretize data
%
% handles.impData -> contains the imputed data
% handles.mapTable -> contains the mapping table
% handles.mapITable -> contains the inverse mapping table


oh = handles;
%initialize
imAllData = cell(size(oh.impData));

%copy the numerical data
wh = waitbar(0.0, 'Processing imputed numerical data ... Please wait.');
for i=1:size(oh.impData, 1)
    waitbar(i/size(oh.impData, 2), wh);
    for j=1:length(oh.numCols)
        imAllData(i, oh.numCols(j)) = {oh.impData(i,oh.numCols(j))};
    end;
end;
close(wh);

%if no cat data, no need to waste time
if isempty(oh.catCols)
    return;
end;
%build the encoding table
wh = waitbar(0.0, 'De-discretizing imputed categorical data ... Please wait.');
for i=1:size(oh.impData,1) %for each row
    waitbar(i/size(oh.impData,1), wh);
    for j=1:length(oh.catCols) %for value of catColumns
        catCol = oh.catCols(j);
   
       % value = floor(oh.impData(i,catCol)+0.5); %threshold bias
        value = floor(oh.impData(i,catCol)); %no threshold bias
        
        if isempty(value) || isnan(value)
            imAllData(i,catCol) = {'NaN'};
            continue;
        end;
       
       if isKey(oh.mapITable, value) == 0
           continue;
       end;
       key = oh.mapITable(value);
       imAllData(i,catCol) = {key};
    end;
end;
close(wh);
end % function end


