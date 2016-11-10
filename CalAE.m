function ae = CalAE(A, B)
%function ae = CalAE(A, B)
%calculates AE for categorical data

ae = 0;
for i=1:size(A,1) %for each row
    for j=1:size(A,2) % for each col
        ae = ae + strcmp(A(i,j), B(i,j));
    end;
end;

ae = ae/(size(A,1)*size(A,2));
end % function