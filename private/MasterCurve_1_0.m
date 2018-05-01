function nextDataStruct = MasterCurve_1_0(data, colhead, reft, name)
%% ------------------------------SETUP-------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%Import the dataStructure from the base workspace.
% dataStruct = evalin('base','s');

%Program is parametrise so the row and columns of the Rheology data
%can change and the code will function.
a = size(data);
row = a(1,1);
col = a(1,2);

% b = size(dataStruct);
% colStruct = b(1,2) + 1;

nextDataStruct = struct('info',{}, 'header', {}, 'xraw', {}, 'yraw', {}, 'xShifted', {}, 'yShifted', {}, 'modelStruct',{}, 'checkMatrix', {}, 'MasterCurve', {});

y = zeros(row,col-1);
y(:,1:col-1) = data(:,1:col-1);
x = data(:,col);

% dataStruct(colStruct).info = {name, reft};
% dataStruct(colStruct).header = colhead;
% dataStruct(colStruct).xraw = x;
% dataStruct(colStruct).yraw = y;

nextDataStruct(1).info = {name, reft};
nextDataStruct(1).header = colhead;
nextDataStruct(1).xraw = x;
nextDataStruct(1).yraw = y;

refCol = reft;
disp(['ref temperature is', colhead(1,refCol)]);

%Apply vertical shifting for the y-axis values of each curve. 
yShifted = verticalShifter(y, colhead, refCol);
%yShifted = y;
%assignin('base', 'yshifted', yShifted);
%assignin('base', 'x', x);

%tic
xShifted = shifterSon(x, yShifted, col, row, refCol);
%toc

%The tolerance was set here once
tol = 1/6;

%assignin('base', 'xshifted', xShifted);


% dataStruct(colStruct).xShifted = xShifted;
nextDataStruct(1).yShifted = yShifted;
nextDataStruct(1).xShifted = xShifted;

%assignin('base', 'logat', getLogAT(refCol , xShifted));
nextDataStruct(1).modelStruct = getArrheniusModel(refCol, colhead, xShifted);


%% ------------------------------TRIMMER-----------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%The points are shifted, there is need to "trim" the master curve to obtian
%the final result. Store points to include in a checkMatrix, a 1 represents
%the point is appart of the Master Curve. 
ileading = col-1;
icurx = 1;
checkMatrix = zeros(row,col);

while true
    changedLeading = false;
    x1 = xShifted(icurx, ileading);
    x2 = xShifted(icurx+1, ileading);
    y1 = yShifted(icurx, ileading);
    y2 = yShifted(icurx+1, ileading);
    coords = getBracketed(x1, x2, xShifted);
            
    %--------------------What points to keep for the MasterCurve-----------
    d = size(coords);
    includedCoords = [];
    for k = 1:d(1,1)
      
        m = coords(k,1);
        n = coords(k,2);
        
        if (n == ileading || n == ileading-1)
            v = [xShifted(m,n) - x1; yShifted(m,n) - y1];
            s = [x2 - x1; y2 - y1];
        
            v2 = (dot(v,s)/dot(s,s))*s;
        
            diff = norm(v - v2);
        
            %include the point
            %modify tolerance inside of shifter functions
            if(diff < (tol*(x2-x1)) )
                includedCoords = [includedCoords ; coords(k,:)];
            end
            
        end
        
    end
    %----------------END:What points to keep for the MasterCurve-----------
    
    %Check if there is a point from ileading-1 to change leading lines
    %Check if point was already included in the MasterCurve
    d = size(includedCoords);
    for k = 1:d(1,1)
        
        %Changes the leading curve
        if includedCoords(k,2) == ileading - 1
            ileading = ileading - 1;
            icurx = includedCoords(k,1);
            changedLeading = true;
            
        end
        
        %adds to the Master Curve points that are either on ileading or
        %ileading-1. When a point from ileading-1 is included do not include
        %the second point from ileading
        %Makes sure not to include a point twice
        m = includedCoords(k,1);
        n = includedCoords(k,2);
        if (checkMatrix(m,n) == 0 && ~(changedLeading==true && k == d(1,1)))
            checkMatrix(m,n) = 1;
        end
        
    end
    
    if changedLeading == false
        icurx = icurx +1;
    end

    %Exit the loop when the last point is reached
    if(ileading == 1 && icurx == row)
        break;
    end


end %ends the big while loop

% dataStruct(colStruct).checkMatrix = checkMatrix;
% dataStruct(colStruct).MasterCurve = assembleMC(y,xShifted,checkMatrix);

nextDataStruct(1).checkMatrix = checkMatrix;
nextDataStruct(1).MasterCurve = assembleMC(yShifted,xShifted,checkMatrix);

%Do required changes to base workspace.
% assignin('base', 's' ,dataStruct);

end

%%
%Returns a matrix with the coordinates of points that fall within a
%bracketed region. Include the points x1 and x2 in the coords matrix
%x is  2D matrix. If no 
function y = getBracketed(x1, x2, x)
[m,n] = size(x);
y = [];
for i = 1:n
    for j = 1:m
        if(x1 <= x(j,i) && x(j,i) <= x2)
            coords = [j,i];
            y = [y; coords];
        end
    end
end

end

%%
%Returns the y for a value of x on a 3 point Lagrange poly. interpolation.
function yinterp = LagrangeInterp(i, xp, x, y)
p1 = y(i);
p2 = y(i+1);
p3 = y(i+2);
x1 = x(i);
x2 = x(i+1);
x3 = x(i+2);

p12 = p1*(xp - x2)/(x1-x2) + p2*(x1-xp)/(x1-x2);
p23 = p2*(xp-x3)/(x2-x3) + p3*(x2-xp)/(x2-x3);
yinterp = p12*(xp-x3)/(x1-x3) + p23*(x1-xp)/(x1-x3);

end

%%
%Returns the index value of left most point to be used in the interpolation
function y1 = getBracket(xPoint, x)

%first find the two point bracket of xPoint
for index = 1:length(x)-1
    if (x(index) <= xPoint && xPoint < x(index+1) )
        y1 = index;
        break
    end
end
if xPoint == x(length(x))
    y1 = length(x)-1;
end

%determine the third point that will be used in the Lagrange interp.
if(y1+2 > length(x))
    y1 = y1-1;
    
end

end

%%
%Calculate the log(a_T) value, so the amount by which the curves are
%shifted to the left and right of the curve at the reference temperature.

function logAT = getLogAT(refColumn, xShifted)
    logOmegaT = xShifted(1,:);
    logOmegaTref = xShifted(1,refColumn);
    logAT = logOmegaT - logOmegaTref;
    
end

%%
%Compare the shifted data to a well accepted theoretical model to validate
%the superpostition generated
function modelStruct = getArrheniusModel(refCol, colhead, xShifted)
modelStruct = struct('info', {}, 'fitParam', {}, 'logAt', {}, 'temp', {}, 'refT', {}, 'modeledLogAt',{});
logOmegaT = xShifted(1,:);
logOmegaTref = xShifted(1, refCol);
colheadSize = size(colhead);
%in the last column of this cell array there is the string for frequency,
%remove it.
colheadSize = colheadSize(1,2) - 1;
colheadTempCells = colhead(1, 1:colheadSize);

modelStruct(1).info = 'Arrhenius';
modelStruct(1).logAt = logOmegaT - logOmegaTref;
modelStruct(1).temp = str2double(colheadTempCells);
modelStruct(1).refT = str2double(colhead(1, refCol));

arrheniusModel = @(Ea, temp) (Ea/8.314).*(1./(temp + 273.15) - 1/(modelStruct(1).refT + 273.15));
Ea0 = 50;

[fitParam, resnorm] = lsqcurvefit(arrheniusModel, Ea0, modelStruct(1).temp, modelStruct(1).logAt)

modelStruct(1).fitParam = fitParam;
modelStruct(1).modeledLogAt = arrheniusModel(fitParam, modelStruct(1).temp);

assignin('base', 'modelStruct', modelStruct);

end


%%
%returnes an assembled MasterCurve by using the check matrix.
%this function was placed here to make code above cleaner.
function y = assembleMC(yShifted,xShifted, checkMatrix)
d = size(yShifted);
row = d(1,1);
col = d(1,2);

length = sum(sum(checkMatrix));
MasterCurve = zeros(length,2);
k = 1;

for j = 1:col
    for i = 1:row
        if(checkMatrix(i,j) == 1)
            MasterCurve(k,1) = xShifted(i,j);
            MasterCurve(k,2) = yShifted(i,j);
            k = k + 1;
        end
    end
end
y = sortrows(MasterCurve);

end

%% -------------------------VERTICAL SHIFTER-------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function yshifted = verticalShifter(y, colhead, refCol)

colhead;
a = size(y);
maxCol = a(1,2);
yshifted = zeros(a(1,1), a(1,2));
yshifted(:,refCol) = y(:,refCol);
Tref = str2double(colhead(1, refCol))

for k = refCol+1:maxCol
    yshifted(:,k) = log10((Tref/str2double(colhead(1,k)))) + y(:,k)
end

for k = refCol-1:-1:1
    yshifted(:,k) = log10((Tref/str2double(colhead(1,k)))) + y(:,k)
end

end

%% -----------------------------SHIFTER-----------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%This shifter is a mix of the algorithm outlined by Gergashova (SHIFTER2)
%and the algorithm developed by Daniel Burkat (SHIFTER1) in
%MasterCurve_0_7.m
%Named shifterSon because it is the product of the union between Gergoshova
%and Burkat TTS alorithms
function xShifted = shifterSon(x, y, col, row, refCol)



%store the best k values in kBest.
%n = 100, so 101 iterations to try was set as the standard. This means 
%that the program will try to 101 fits of the curve and the best one will 
% be chosen.
kBest = zeros(1, col-2);

%Loop from the top to the bottom
for i = 1:col-2
    
    points = 21;
    n = 100;
    
    UCy = y(:,i);
    UCx = x(:,1);
    LCy = y(:,i+1);
    LCx = x(:,1);
    
    %Find the OW, the OWlow is the first y value of the upper curve, OWhigh
    %is the last y value of the lower curve.
    OWlow = UCy(1,1);
    OWhigh = LCy(row,1);
    
    %Cut segment into 20 intervals (so 21 points), need to find the
    %respective interpolated x points for the UC and LC
    %Find point of first and last inresection kStart and kLast respectively
    
    yPoints = linspace(OWlow, OWhigh, points);
    UCxPoints = zeros(points,1);
    LCxPoints = zeros(points,1);
    
    for j = 1:points
        u1 = getBracket(yPoints(j), UCy);
        l1 = getBracket(yPoints(j), LCy);
        
        UCxPoints(j,1) = LagrangeInterp(u1, yPoints(1,j), UCy, UCx);
        LCxPoints(j,1) = LagrangeInterp(l1, yPoints(1,j), LCy, LCx);
    end
    
    
    
    distances = abs(UCxPoints - LCxPoints);
    kStart = min(distances) -0.1;
    kLast  = max(distances) + 0.1;
    step = (kLast - kStart)/n;
    kSSE = zeros(101,2);
    kIndex = 1;
    
    %Iterate over trail shift values
    for k = kStart:step:kLast
        %Check SSE for the k value and store it
        UCxShifted = UCxPoints + k;
        E = LCxPoints - UCxShifted;
        SSE = sum(E.^2);
        kSSE(kIndex,1) = k;
        kSSE(kIndex,2 ) = SSE;
        kIndex = kIndex + 1;
        
        
    end
    
    %Choose the shift value that lead to the min SSE
    [C, G] = min(kSSE(:,2));
    kBest(1,i) = kSSE(G,1);
    
    if(i == 4)
    assignin('base','UCxPoints', UCxPoints);
    assignin('base','LCxPoints', LCxPoints);
    assignin('base','yPoints', yPoints);
    assignin('base', 'kBest', kBest(1,i));
    end

end

%Assemble the Master Curve to the reference temperature
%Now that the best k is known, shift all the curves and assemble a master
%curve with all points included.
%Start from referance temp curve and go one direction, then in the opposite
xShifted = repmat(x,1,col-1);


%next for loops are to displace each curve to the best position.
%shift to the right
for i = refCol:-1:2
    k = kBest(i-1);
    shiftBy = k;
    for j = i-1:-1:1
        xShifted(:,j) = xShifted(:,j) + shiftBy;
    end
end
%shift to the left
for i = refCol:col-2
    k = kBest(i);
    shiftBy = k;
    for j = i+1:col-1
        xShifted(:,j) = xShifted(:,j) - shiftBy;
    end
end


end
