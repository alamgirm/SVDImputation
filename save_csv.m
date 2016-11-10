function save_csv(fName, data)
%function save_csv(fName, data)
%saves the cell array data to a csv file

 wh = waitbar(0.0, 'Saving imputed data ... Please wait.');
    fid = fopen(fName, 'w');
    if fid > 0
        for i=1:size(data,1) %for each row
            waitbar(i/size(data,1), wh);
            
            for j=1:size(data, 2)-1 % for each col
                aVal = cell2mat(data(i, j));
                
                if isnumeric(aVal)
                    if isnan(aVal)
                        fprintf(fid,',');
                    else
                        fprintf(fid,'%5.2f, ', aVal);
                    end;
                else
                        fprintf(fid,'%s, ', aVal);
                end;
            end; %for j
            %handle the last value of the row without ,
            aVal = cell2mat(data(i, j+1));
                
             if isnumeric(aVal)
                     fprintf(fid,'%5.2f', aVal);
             else
                     fprintf(fid,'%s', aVal);
             end;
                
             %wrie new line
             fprintf(fid,'\n');
         end; % for i
         fclose(fid);
    end; %fid > 0

    close(wh);