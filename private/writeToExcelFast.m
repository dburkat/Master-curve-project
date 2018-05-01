function writeToExcelFast(filename, type, dataStruct, fromMatFile)

dateExport = {'Exported on:', date};
fromExport = {'From:', fromMatFile}; 

newfilename = filename;

if strcmp(type, 'MC')
    %save only the MC data
    curvesToWrite = length(dataStruct);
    
    maxRow = 0;
    for k = 1:curvesToWrite
        b = size(dataStruct(k).MasterCurve);
        if maxRow < b(1,1)
            maxRow = b(1,1);
        end
    end
    
    A = cell(maxRow + 6, 3*curvesToWrite);
    
    A{1,1} = dateExport{1,1};
    A{1,2} = dateExport{1,2};
    A{2,1} = fromExport{1,1};
    A{2,2} = fromExport{1,2};
    
    for k = 1:curvesToWrite
        info = dataStruct(k).info;
        header = dataStruct(k).header;
        
        A{5,3*k -2} = 'Series name:';
        A{5,3*k -1} = info{1};
        
        A{6,3*k -2} = 'RefT:';
        A{6,3*k -1} = header{info{2}};
        
        A{7,3*k -2} = 'Time';
        A{7,3*k -1} = 'Modulus';
        
        MasterCurve = dataStruct(k).MasterCurve;
        b = size(MasterCurve);
        for i = 1:b(1,1)
            A{7+i,3*k -2} = MasterCurve(i,1);
            A{7+i,3*k -1} = MasterCurve(i,2);
        end
        
    end
    
    xlswrite(newfilename, A,1,'A1');
    
    
else
    %save all the data to excel
    sheetsToWrite = length(dataStruct);
    
    for k = 1:sheetsToWrite

        %extract all data from dataStruct
        info = dataStruct(k).info;
        header = dataStruct(k).header;
        yraw = dataStruct(k).yraw;
        xraw = log(2*pi)- dataStruct(k).xraw;
        xrawSize = size(xraw);
        yrawSize = size(yraw);
        
        xShifted = log10(2*pi) - dataStruct(k).xShifted;
        yShifted = dataStruct(k).yShifted;
        
        checkMatrix = dataStruct(k).checkMatrix;
        
        modelStruct = dataStruct(k).modelStruct;
        
        MasterCurve = dataStruct(k).MasterCurve;
        MasterCurve(1,:) = log10(2*pi) - MasterCurve(1,:);
        MasterCurveSize = size(MasterCurve);
        
        %Locate the start locations for each data array 
        rows = yrawSize(1,1);
        cols = yrawSize(1,2);
        MCrows = MasterCurveSize(1,1);
        Head = 1;
        HeadSize = 5;
        RawData = Head+ HeadSize;
        RawDataSize = 2 + rows + 1;
        ShiftedTime = RawData + RawDataSize;
        ShiftedTimeSize = 2 + rows + 1;
        ShiftedModulus = ShiftedTime + ShiftedTimeSize;
        ShiftedModulusSize = 2 + rows + 1;
        MC = ShiftedModulus + ShiftedModulusSize;
        MCSize = 2 + MCrows;
        CheckMatrix = ShiftedTime;
        CheckMatrixSize = 2 + rows + 1;
        ModelFit = CheckMatrix + CheckMatrixSize;
        ModelFitSize = 6;
        ColSpace2 = cols+2;
        
        
        
        %Create the cell array
        A = cell(MC + MCSize, 2 + 2*cols);
        
        %Add the sheet information to the cell
        nameCell = {'Series name:' , info{1}};
        RefTCell = {'RefT:', header{info{2}}};
        
        A{Head,1} = dateExport{1,1};
        A{Head,2} = dateExport{1,2};
        A{Head+1,1} = fromExport{1,1};
        A{Head+1,2} = fromExport{1,2};
        A{Head+2,1} = nameCell{1,1};
        A{Head+2,2} = nameCell{1,2};
        A{Head+3,1} = RefTCell{1,1};
        A{Head+3,2} = RefTCell{1,2};
        
        %Add the raw data
        A{RawData, 1} = 'Raw data';
        for i = 1:cols
            A{RawData+1,i} = header{1,i};
            for j = 1:rows
                A{RawData+1+j, i} = yraw(j,i);
            end
        end
        
        i = cols+1;
        A{RawData+1, i} = header{1,i};
        for j = 1:rows
            A{RawData+1+j, i} = xraw(j,1);
        end
        
        
        %Add ShiftedTime
        A{ShiftedTime, 1} = 'Shifted time';
        for i = 1:cols
            A{ShiftedTime+1, i} = header{1,i};
            for j = 1:rows
                A{ShiftedTime+1+j, i} = xShifted(j,i);
            end
        end
        
        
        %Add CheckMatrix
        A{CheckMatrix, ColSpace2} = 'Check matrix';
        for i = 1:cols
            A{CheckMatrix+1, ColSpace2-1+i} = header{1,i};
            for j = 1:rows
                A{CheckMatrix+1+j, ColSpace2-1+i} = checkMatrix(j,i);
            end
        end
        
        %Add ShiftedModulus
        A{ShiftedModulus, 1} = 'Shifted modulus';
        for i = 1:cols
            A{ShiftedModulus +1, i} = header{1,i};
            for j = 1:rows
                A{ShiftedModulus+1+j, i} = yShifted(j,i);
            end
        end
        
        %Add model fit data
        A{ModelFit, ColSpace2} = 'Type of fit:';
        A{ModelFit, ColSpace2+1} = modelStruct(1).info;
        A{ModelFit+1, ColSpace2} = 'Fit parameter';
        A{ModelFit+1, ColSpace2+1} = modelStruct(1).fitParam;
        A{ModelFit+2, ColSpace2} = 'reference T';
        A{ModelFit+2, ColSpace2+1} = modelStruct(1).refT;
        A{ModelFit+3, ColSpace2} = 'Temp';
        A{ModelFit+4, ColSpace2} = 'log(at)';
        A{ModelFit+5, ColSpace2} = 'modeled log(at)';
        temperature = modelStruct(1).temp;
        logAt = modelStruct(1).logAt;
        modeledLogAt = modelStruct(1).modeledLogAt;
        for i = 1:cols
            A{ModelFit+3, ColSpace2+i} = temperature(1,i);
            A{ModelFit+4, ColSpace2+i} = logAt(1,i);
            A{ModelFit+5, ColSpace2+i} = modeledLogAt(1,i);
        end
        
        %Add MasterCurve data
        A{MC, 1} = 'Mastercurve';
        A{MC+1,1} = 'time';
        A{MC+1,2} = 'modulus';
        for j = 1:MCrows
            A{MC+1+j,1} = MasterCurve(j,1);
            A{MC+1+j,2} = MasterCurve(j,2);
        end
        
    
        xlswrite(newfilename, A, k, 'A1');
        
    end

end