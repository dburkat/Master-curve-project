function RawPlot(dataStruct, selected,type)

C = {'k','r','g','b','y','m','c'};

d = length(selected);

if( d == 1)

    xraw = dataStruct(selected).xraw;
    yraw = dataStruct(selected).yraw;
    names = dataStruct(selected).header;
    
    switch type
        case 'plotFreq'
            plot(xraw,yraw,'.', 'MarkerSize',10);
            xlabel('log(w)');
            ylabel('log(G )');
            legend(names(1:length(names)-1),'Location', 'SouthEast');
        case 'plotTime'
            xData = log10(2*pi)- xraw;
            plot(xData, yraw, '.', 'MarkerSize',10);
            xlabel('log(t)');
            ylabel('log(G )');
            legend(names(1:length(names)-1),'Location', 'SouthWest');
        
    end
    
    
    
else
    
    xraw = dataStruct(selected(1)).xraw;
    yraw = dataStruct(selected(1)).yraw;
    
    switch type
        case 'plotFreq'
            plot(xraw,yraw,[C{1}, 'x']);
            xlabel('log(w)');
            ylabel('log(G )');
            
            hold on
            for k = 2:d
                xraw = dataStruct(selected(k)).xraw;
                yraw = dataStruct(selected(k)).yraw;
                plot(xraw,yraw,[C{k}, 'x']);
            end
            hold off
            
        case 'plotTime'
            xData = log10(2*pi) - xraw;
            plot(xData,yraw,[C{1}, 'x']);
            xlabel('log(t)');
            ylabel('log(G )');
            
            hold on
            for k = 2:d
                xraw = dataStruct(selected(k)).xraw;
                yraw = dataStruct(selected(k)).yraw;
                
                xData = log10(2*pi) - xraw;
                plot(xData,yraw,[C{k}, 'x']);
            end
            hold off
            
    end
    
end


return