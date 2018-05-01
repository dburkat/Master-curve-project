%MCPlot takes in the whole data structure and a list of selected members to
%plot. Up to 7 Master curves can be placed on the same plot.
function MCPlot(dataStruct,selection,type)

C = {'k','r','g','b','y','m','c'};

d = length(selection);
if (d ==1)
    MasterCurve = dataStruct(selection).MasterCurve;
    info = dataStruct(selection).info;
    
    switch type
        case 'plotFreq'
            h1 = plot(MasterCurve(:,1), MasterCurve(:,2),[C{1},'x']);
            xlabel('log(w)');
            ylabel('log(G )');
            legend(h1, info{1}, 'Location', 'east');
        case 'plotTime'
            xData = log10(2*pi) - MasterCurve(:,1);
            h1 = plot(xData, MasterCurve(:,2), [C{1}, 'x']);
            xlabel('log(t)');
            ylabel('log(G )');        
            legend(h1, info{1}, 'Location', 'northeast');
    end
    
    
else
    
    names = cell(1,d);
    plotHandles = zeros(1,d);
    MasterCurve = dataStruct(selection(1)).MasterCurve;
    info = dataStruct(selection(1)).info;
    names{1} = info{1};
    
    switch type
        case 'plotFreq'
            h1 = plot(MasterCurve(:,1), MasterCurve(:,2), [C{1}, 'x']);
            plotHandles(1,1) = h1(1,1);
            xlabel('log(w)');
            ylabel('log(G )');
            hold on
            for k = 2:length(selection)
                MasterCurve = dataStruct(selection(k)).MasterCurve;
                info = dataStruct(selection(k)).info;
                names{k} = info{1};
                h1 = plot(MasterCurve(:,1),MasterCurve(:,2),[C{k}, 'x']);
                plotHandles(1,k) = h1(1,1);
            end
            hold off
            legend(plotHandles(:), names{:}, 'Location', 'southeast');
            
        case 'plotTime'
            xData = log10(2*pi) - MasterCurve(:,1);
            h1 = plot(xData, MasterCurve(:,2), [C{1}, 'x']);
            plotHandles(1,1) = h1(1,1);
            xlabel('log(t)');
            ylabel('log(G )');
            hold on
            for k = 2:length(selection)
                MasterCurve = dataStruct(selection(k)).MasterCurve;
                info = dataStruct(selection(k)).info;
                names{k} = info{1};
                xData = log10(2*pi) - MasterCurve(:,1);
                h1 = plot(xData,MasterCurve(:,2),[C{k}, 'x']);
                plotHandles(1,k) = h1(1,1);
            end
            hold off 
            legend(plotHandles(:), names{:}, 'Location', 'northeast');
    end
     
    
end

return