function [oh] = analyze_data(handles)
%function analyze_data(handles)

oh = handles;

%if inDataValid is 1, then cat data have been converted to num data
if oh.inDataValid
    oh.catgData = 'No';
    oh.numCFeatures = 0; 
    oh.numInstances = size(handles.inData, 1);
    oh.numNFeatures  = size(handles.inData, 2);

    dataSrc = oh.inData;
    oh.numOptSV = ceil(oh.numNFeatures/2);
else
    if isempty(handles.inCatData) == 0 %we have categorical data
        oh.catgData = 'Yes';
        oh.numCFeatures = length(handles.catCols);
    else
        oh.catgData = 'No';
    end;
    
    oh.numInstances = size(handles.inNumData, 1);
    oh.numNFeatures  = length(handles.numCols);
    oh.numOptSV = ceil((oh.numCFeatures+oh.numNFeatures)/2);
    dataSrc = oh.inAllData;
end;

missData = zeros(size(dataSrc));
%nan can be double as well as cell array
CNaN{1} = NaN; 
for i=1:size(dataSrc,1)
    for j=1:size(dataSrc,2)
        cellVal = dataSrc(i,j);
        if  isnumeric(cellVal) ||  iscellstr(cellVal) %an array
            if isnumeric(cellVal) &&  isnan(cellVal)
               missData(i,j) = 1; 
            else
                continue;
            end;
        else
             missData(i,j) = isequaln(cellVal, CNaN); 
        end    
    end;
end;


%total count of missing data
missCount = sum(sum(missData==1));

if missCount > 0
    oh.missingData = 'Yes';
    oh.missingRate = sprintf('%0.2f',100*missCount/(size(missData,1)*size(missData,2)));
    
    %univariate pattern
    %missing value is in only one column, and ALL other columns have no MV
    [mvVals, mvCols] = sort(sum(missData));
    if sum(mvVals(1:end-1)) == 0
        oh.missingPattern = 'Univariate';
    elseif mvCols == [1:size(missData,2)]
        oh.missingPattern = 'Monotone';
    else
        oh.missingPattern = 'Arbitrary';    
    end;   
else
   oh.missingData = 'No'; 
   oh.missingRate = '0';
   oh.missingPattern = 'N/A'; 
end;

%find the rows with no missing data
missSum = sum(missData,2); % row wise sum
noMDRows = dataSrc(missSum==0,:); %take those rows

if isempty(noMDRows) || oh.numNFeatures == 0 %no luck  
    return;
end;

%do an SVD
if oh.inDataValid
    if isempty(oh.numCols)
         [U, SV, V] = svd(noMDRows);
    else
         [U, SV, V] = svd(noMDRows(:,oh.numCols));
    end
else
    [U, SV, V] = svd(cell2mat(noMDRows(:,oh.numCols)));
end
%find the cumulative sum of VS that represent at least 95% energy
sm = cumsum(diag(SV));

oh.numOptSV = sum(sm <= oh.lvlEnergy*sm(end)/100.0);
if oh.numOptSV == 0
    oh.numOptSV = ceil((oh.numCFeatures+oh.numNFeatures)/2);
end;

end % function ends
    

