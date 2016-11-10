function [numData, numCols, catData, catCols] = pre_process_data(allData)
%function [numData, numCols, catData, catCols] = pre_process_data(allData)

numData = [];
numCols = [];
catData = {};
catCols = [];

totCol = size(allData, 2);
totRow = size(allData, 1);

numColCount = 0;
catColCount = 0;


%first go thru one row of data to determine which
%col is a numeric col, and which one is a categorical
for j=1:totCol
    cellVal = cell2mat(allData(1, j));
    %if we happen to have a missing data,
    %keep trying till all rows
    if isnumeric(cellVal) && isnan(cellVal)
        k = 2;
        while k <= totRow
            cellVal = cell2mat(allData(k, j));
            if isnan(cellVal) == 0
                break;
            end;
            k = k+1;
        end;
    end;
    
    if(isnumeric(cellVal))
        numCols(end+1) = j;
    else
        catCols(end+1) = j;
    end
end;

numColCount = length(numCols);
catColCount = length(catCols);
numData = zeros(totRow, numColCount);
catData = cell (totRow, catColCount);


%process numeric data
wh = waitbar(0.0, 'Preprocessing numeric data ... Please wait');
for i= 1:totRow;
    waitbar(i/totRow, wh);
    for j=1:length(numCols)
        cellVal = cell2mat(allData(i, numCols(j)));
        
       % [i,j]
        if isempty(cellVal) || isnan(cellVal)
            numData(i,j) = NaN; 
        else
            numData(i,j) = cellVal;
        end;
    end;
end;
close(wh);

if isempty(catCols)
    return;
end;
%process category data
wh = waitbar(0.0, 'Preprocessing category data ... Please wait');
for i=1:totRow;
    waitbar(i/totRow, wh);
    for j=1:length(catCols)
        cellVal = cell2mat(allData(i, catCols(j)));
        if isnan(cellVal)
            catData(i,j) = {NaN};
            continue;
        end;
        
        cellVal = strtrim(cellVal);
        if isempty(cellVal)
            catData(i,j) = {NaN}; 
        else
            catData(i,j) = {cellVal};
        end;
    end;
end;
close(wh);



    
