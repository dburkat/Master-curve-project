%ArrheniusPlot takes in the whole data structure and a list of selected members to
%plot. Up to 7 Arrhenius plots can be placed on the same plot.
function ArrheniusPlot(dataStruct,selection,type)

C = {'k','r','g','b','y','m','c'};

d = length(selection);
if(d==1)
   
    modelStruct = dataStruct(selection).modelStruct;
    info = dataStruct(selection).info;
    
    switch type
        case 'plotFreq'
            yData1 = log10(2*pi) - modelStruct.logAt;
            yData2 = log10(2*pi) - modelStruct.modeledLogAt;
            
            h1 = plot(modelStruct.temp,yData1, [C{1}, 'x']);
            xlabel('Temperature');
            ylabel('log(w/at)');
            hold on
            h2 = plot(modelStruct.temp, yData2, [C{2}, '-']);
            hold off
            
            
            
        case 'plotTime'
            h1 = plot(modelStruct.temp,modelStruct.logAt,[C{1},'x']);
            xlabel('Temperature');
            ylabel('log(at)');
            hold on
            h2 = plot(modelStruct.temp,modelStruct.modeledLogAt, [C{2},'-']);
            hold off
            
            
            
    end
    plotHandles = zeros(1,2);
    plotHandles(1,1) = h1(1,1);
    plotHandles(1,2) = h2(1,1);
    
    names = cell(1,2);
    names{1,1} = info{1};
    names{1,2} = 'best fit';
    
    legend(plotHandles(:), names{:}, 'Location', 'East');
    
    
else
    
    names= cell(1,2*d);
    plotHandles = zeros(1,2*d);
    modelStruct = dataStruct(selection(1)).modelStruct;
    info = dataStruct(selection(1)).info;
    
    switch type 
        case 'plotFreq'
            yData1 = log10(2*pi) - modelStruct.logAt;
            yData2 = log10(2*pi) - modelStruct.modeledLogAt;
            
            h1 = plot(modelStruct.temp, yData1, [C{1},'x']);
            xlabel('Temperature');
            ylabel('log(w/at)');
            hold on 
            h2 = plot(modelStruct.temp, yData2, [C{1}, '-']);
            plotHandles(1,1) = h1(1,1);
            plotHandles(1,2) = h2(1,1);
            names{1,1} = info{1};
            names{1,2} = 'best fit';
            
            for k = 2:length(selection)
                modelStruct = dataStruct(selection(k)).modelStruct;
                info = dataStruct(selection(k)).info;
                yData1 = log10(2*pi) - modelStruct.logAt;
                yData2 = log10(2*pi) - modelStruct.modeledLogAt;
                
                h1 = plot(modelStruct.temp, yData1, [C{k}, 'x']);
                h2 = plot(modelStruct.temp, yData2, [C{k}, '-']);
                plotHandles(1,2*k-1) = h1(1,1);
                plotHandles(1,2*k) = h2(1,1);
                names{1,2*k-1} = info{1};
                names{1,2*k} = 'best fit';
                
            end
            hold off
            legend(plotHandles(:), names{:}, 'Location', 'southeast');
            
        case 'plotTime'
            h1 = plot(modelStruct.temp, modelStruct.logAt, [C{1},'x']);
            xlabel('Temperature');
            ylabel('log(at)');
            hold on
            h2 = plot(modelStruct.temp, modelStruct.modeledLogAt, [C{1}, '-']);
            plotHandles(1,1) = h1(1,1);
            plotHandles(1,2) = h2(1,1);
            names{1,1} = info{1};
            names{1,2} = 'best fit';
            
            for k = 2:length(selection)
                modelStruct = dataStruct(selection(k)).modelStruct;
                info = dataStruct(selection(k)).info;
                h1 = plot(modelStruct.temp, modelStruct.logAt, [C{k},'x']);
                h2 = plot(modelStruct.temp, modelStruct.modeledLogAt, [C{k}, '-']);
                plotHandles(1,2*k-1) = h1(1,1);
                plotHandles(1,2*k) = h2(1,1);
                names{1,2*k-1} = info{1};
                names{1,2*k} = 'best fit';
                
            end
            hold off
            legend(plotHandles(:), names{:}, 'Location', 'northeast');
    end
    
    
    
end

return