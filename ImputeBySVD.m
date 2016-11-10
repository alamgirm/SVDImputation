function outData = ImputeBySVD(inData, nSV, nIt )
%function outData = ImputeBySVD(inData, nSV, nIt )
%imputes missing values in inData using SVD
% nSV -> number of singular values to use
% nIt -> number of iteration to apply for improving the result

%outData contains the full data with imputed values

newSV = []; % selected singular values
impData = zeros(size(inData)); %array of imputed data

nanPos = isnan(inData); % position of the missing  values
outData = ImputeByMean(inData);  %first do a mean imputation


%iterate thru for better imputation
for it=1:nIt
    [U, SV, V] = svd(outData);
    newSV = zeros(size(SV));
    %copy only the desired singular values
    for i=1:nSV
        newSV(i,i) = SV(i,i);
    end;
    
   %impute
   impData = U*newSV*V';
   
   %copy the imputed values back to the array
   outData(nanPos) = impData(nanPos);
end;


    