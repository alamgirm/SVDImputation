function outData = ImputeByMean(inData)
%function outData = ImputeByMean(inData)
%imputes any NaN value in inData by column mean

totCol = size(inData, 2);
colMean = 0;
nanPos = [];
outData = inData;  %copy original data
%for each column find the mean and replace the missing value with the mean
%wh = waitbar(0.0, 'Doing mean imputation ... Please wait.');
for colCount = 1:totCol
    % colCount
%    waitbar(colCount/totCol, wh);
    colMean = nanmean(inData(:,colCount)); % column mean
    if isnan(colMean)
        colMean = 0.0;
    end;
    nanPos = isnan(inData(:,colCount));   %position of the missing values
    outData(nanPos,colCount) = colMean;   %impute by mean
end;
%close(wh);

    