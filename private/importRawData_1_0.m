function [status, data, colheaders] = importRawData_1_0(dataStruct)
clc
status = [];
data = [];
colheaders=[];

S = uiimport('-file');
if ~isempty(S);
    
    [status, data, colheaders] = preprocessing(S, dataStruct);
    
end
end


%% preprocessing orders the data appropriately and signals any problems in
%the data or if the same raw data has already been analyzed.
function [status, data, colhead] = preprocessing(S, dataStruct)

data = S.data;
colhead = S.colheaders;

%Program is parametrise so the row and columns of the Rheology data
%can change and code will function.
a = size(data);
row = a(1,1);
col = a(1,2);

b = size(dataStruct);
colStruct = b(1,2);

%Order the data matrix in appropriate order. Easier to work with if kept
%standard. The rightmost row MUST be the common x axis values. 
%The order needed is low to high when going top to bottom in the
%matrix, and low to high when going from right to left.
% _                               _
%|    <=== inreasing right to left |
%|||                               |
%|\/                               |   
%|incresing top to bottom          |
%|_                               _|
[data, colhead] = order(data, colhead);

status = {};
if size(dataStruct) > 0
    
    %Are there two identical columns.
    for k = 1:col
        column1 = data(:,k);
        for j = 1:col
            if k ~= j
                column2 = data(:,j);
                if isequal(column1, column2)
                    status = [status; 'WARNING: Two different columns have the same data series'];
                end
            end
        end
    end
 
%TODO: Figure out more ways to check the data, finish the below way.
%     %Are the column headers consistent with the first row of the data
%     for k = 1:col-2
%         header1 = str2double(colhead{k});
%         header2 = str2double(colhead{k+1});
%         column1 = data(1,k);
%         column2 = data(1,k+1);
%         
%         if(header1 > header2 && column1 < column2)
%             status = [status; 'WARNING: Inconsisten ordering between column and header']
%         end
%         
%     end
    
    %Check if the raw data already exist in the structure
    for k = 1:colStruct
        xraw = dataStruct(k).xraw;
        yraw = dataStruct(k).yraw;
        existingData = [yraw,xraw];
        if (isequal(data, existingData))
            status = [status; 'WARNING: This data was already analyzed and exists in workspace'];
        end
    end
    
end

if(size(status) == 0)
    status = {'OK: The data is ready to be analyzed'};
end

end

%% Returns a nxm vector of data arranged in appropriate order.
function [y1, y2] = order(data,colhead)
a = size(data);
m= a(1,1);
n= a(1,2);

%The MCR302 provides the frequency sweep data. For some reason the data
%given to me was ordered from high to low going from top to bottom. 
% It was more intuitive to work with data ordered low to high, going from 
%top to bottom. Order the data increasing when going from right to left.
checkVal = data(2,n) - data(1,n);
if(checkVal < 0)

    ascendingData = zeros(m,n);
    for k = 1:m
        ascendingData(k,:) = data(m+1-k,:);
    end
    data = ascendingData;
end

%Now make sure the order is increasing order from right to left for topmost
%value of the matrix. Use a insertion sort since this is a small data set.
for i = n-2:-1:1
    j = i;
    while ( j < n-1 && data(1,j+1) > data(1,j))
        temp = data(:,j+1);
        data(:,j+1) = data(:,j);
        data(:,j) = temp;
        temp = colhead(1,j+1);
        colhead(1,j+1) = colhead(1,j);
        colhead(1,j) = temp;
        j = j+1;
    end

end

y1 = data;
y2 = colhead;
end