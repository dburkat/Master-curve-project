function ShiftMCPlot(dataStruct, selection,type)

C = {'k','r','g', 'b','y','m','c'};

d = length(selection);


if (d == 1)
    MasterCurve = dataStruct(selection).MasterCurve;
    xShifted = dataStruct(selection).xShifted;
    yShifted = dataStruct(selection).yShifted;
    names = dataStruct(selection).header;
    
    switch type
        case 'plotFreq'
            plot(xShifted, yShifted, '.', 'MarkerSize',10);
            xlabel('log(w)');
            ylabel('log(G )');
            hold on
            plot(MasterCurve(:,1), MasterCurve(:,2),'-');
            hold off
             
        case 'plotTime'
            xData = log10(2*pi) - xShifted;
            plot(xData, yShifted, '.', 'MarkerSize',10);
            xlabel('log(t)');
            ylabel('log(G )');
            hold on
            xData = log10(2*pi) - MasterCurve(:,1);
            plot(xData, MasterCurve(:,2),'-');
            hold off
            
    end
    
    legend(names(1:length(names)-1),'Location','East');
    
    
    
    
else
    names = cell(1,d);
    plotHandles = zeros(1,d);
    MasterCurve = dataStruct(selection(1)).MasterCurve;
    xShifted = dataStruct(selection(1)).xShifted;
    yShifted = dataStruct(selection(1)).yShifted;
    info = dataStruct(selection(1)).info;
    names{1} = info{1};
    
    switch type
        case 'plotFreq'
            h1 = plot(xShifted, yShifted, [C{1}, '.']);
            plotHandles(1,1) = h1(1,1);
            xlabel('log(w)');
            ylabel('log(G )');
            
            hold on
            plot(MasterCurve(:,1),MasterCurve(:,2),[C{1}, '-']);
            
            for k = 2:d
                MasterCurve = dataStruct(selection(k)).MasterCurve;
                xShifted = dataStruct(selection(k)).xShifted;
                yShifted = dataStruct(selection(k)).yShifted;
                info = dataStruct(selection(k)).info;
                names{k} = info{1};
                h1 = plot(xShifted, yShifted, [C{k}, '.']);
                plotHandles(1,k) = h1(1,1);
                plot(MasterCurve(:,1),MasterCurve(:,2),[C{k}, '-']);
            end
            hold off
            
        case 'plotTime'
            
            xData = log10(2*pi) - xShifted;
            h1 = plot(xData, yShifted, [C{1}, '.']);
            plotHandles(1,1) = h1(1,1);
            xlabel('log(t)');
            ylabel('log(G )');
            
            hold on
            xData = log10(2*pi) - MasterCurve(:,1);
            plot(xData,MasterCurve(:,2),[C{1}, '-']);
            
            for k = 2:d
                MasterCurve = dataStruct(selection(k)).MasterCurve;
                xShifted = dataStruct(selection(k)).xShifted;
                yShifted = dataStruct(selection(k)).yShifted;
                info = dataStruct(selection(k)).info;
                names{k} = info{1};
                
                xData = log10(2*pi) - xShifted;
                h1 = plot(xData, yShifted, [C{k}, '.']);
                plotHandles(1,k) = h1(1,1);
                xData = log10(2*pi) - MasterCurve(:,1);
                plot(xData,MasterCurve(:,2),[C{k}, '-']);
            end
            hold off
    end
    
    legend(plotHandles(:), names{:}, 'Location', 'East');
    
    


end



return