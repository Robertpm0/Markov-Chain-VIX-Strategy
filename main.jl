# TO DO:
#
# test on other indicies besides SPY
#
# try other time frames 
#
using CSV, DataFrames,Dates,Plots,Graphs,GraphRecipes
dfSpy = DataFrame(CSV.File("SPY (1).csv"))
dfVix = DataFrame(CSV.File("vix07.csv"))
#making dates same format
newDates=Dates.format.(dfSpy.Date,"mm/dd/yyyy")
dfSpy.Date = newDates


# search for missing dates
# removes them
function DateMatch()
    badIndex=[]
    temp2=0
    temp3=0
    for i ∈ range(1,size(dfVix,1))
        if temp2 == 0
            temp =i
        end
        if temp2==1
            temp = i-temp3
        end
        if dfVix.DATE[i] != dfSpy.Date[temp]
            temp2=1
            temp3 = temp3 +1
            append!(badIndex,i)
            print(dfVix.DATE[i])
        end
    end
    delete!(dfVix,badIndex)
end
DateMatch()
split = size(dfSpy,1) * 0.20+2
split = round(Int,split)



function MarkovItRaw()
    upupDay=0
    downupDay=0
    downdownDay=0
    updownDay=0
    dbu=0
    ubu=0
    dbd=0
    ubd=0
    failedUp=0
    failedDown=0
    ddp=0
    dup=0
    udp=0
    doup=0

    #upDates=[]
    #downDates=[]
    upParadoxCount=0
    downParadoxCount=0
    doubleDown=0
    doubleUp=0
    #using first 80% of data for proper 80/20 split
    for i ∈ range(2,size(dfVix,1)-split)
        if dfSpy."Adj Close"[i] > dfSpy."Adj Close"[i-1] && dfVix.CLOSE[i] > dfVix.CLOSE[i-1]
            doubleUp = doubleUp +1
            if dfSpy."Adj Close"[i+1] < dfSpy."Adj Close"[i] && dfVix.CLOSE[i+1] >= dfVix.CLOSE[i]
                upParadoxCount = upParadoxCount +1
                #append!(upDates,i+1)
            elseif dfSpy."Adj Close"[i+1] > dfSpy."Adj Close"[i] && dfVix.CLOSE[i+1] <= dfVix.CLOSE[i]
                failedUp=failedUp+1
            elseif dfSpy."Adj Close"[i+1] > dfSpy."Adj Close"[i] && dfVix.CLOSE[i+1] > dfVix.CLOSE[i]
                dup=dup+1
            elseif dfSpy."Adj Close"[i+1] < dfSpy."Adj Close"[i] && dfVix.CLOSE[i+1] < dfVix.CLOSE[i]
                udp =udp+1
            end
        elseif dfSpy."Adj Close"[i] < dfSpy."Adj Close"[i-1] && dfVix.CLOSE[i] < dfVix.CLOSE[i-1]
            doubleDown = doubleDown +1
            if dfSpy."Adj Close"[i+1] > dfSpy."Adj Close"[i] && dfVix.CLOSE[i+1] <= dfVix.CLOSE[i]
                downParadoxCount = downParadoxCount +1
                #append!(downDates,i+1)
            elseif dfSpy."Adj Close"[i+1] < dfSpy."Adj Close"[i] && dfVix.CLOSE[i+1] >= dfVix.CLOSE[i]
                failedDown=failedDown+1
            elseif dfSpy."Adj Close"[i+1] > dfSpy."Adj Close"[i] && dfVix.CLOSE[i+1] > dfVix.CLOSE[i]
                doup=doup+1
            elseif dfSpy."Adj Close"[i+1] < dfSpy."Adj Close"[i] && dfVix.CLOSE[i+1] < dfVix.CLOSE[i]
                ddp =ddp+1
            end
        elseif dfSpy."Adj Close"[i]>dfSpy."Adj Close"[i-1] && dfVix.CLOSE[i] <= dfVix.CLOSE[i-1]
            if dfSpy."Adj Close"[i] >dfSpy."Adj Close"[i+1] && dfVix.CLOSE[i] < dfVix.CLOSE[i+1]
                upupDay = upupDay +1
            elseif dfSpy."Adj Close"[i] <dfSpy."Adj Close"[i+1] && dfVix.CLOSE[i] > dfVix.CLOSE[i+1]
                updownDay = updownDay +1
            elseif dfSpy."Adj Close"[i+1]>dfSpy."Adj Close"[i] && dfVix.CLOSE[i+1] > dfVix.CLOSE[i]
                    ubu=ubu +1
            elseif dfSpy."Adj Close"[i+1]<dfSpy."Adj Close"[i] && dfVix.CLOSE[i+1] < dfVix.CLOSE[i]
                    ubd=ubd +1
            end
        elseif dfSpy."Adj Close"[i] < dfSpy."Adj Close"[i-1] && dfVix.CLOSE[i] >= dfVix.CLOSE[i-1]
            if dfSpy."Adj Close"[i+1] >dfSpy."Adj Close"[i] && dfVix.CLOSE[i] >= dfVix.CLOSE[i+1]
                downupDay = downupDay +1
            elseif dfSpy."Adj Close"[i+1] < dfSpy."Adj Close"[i] && dfVix.CLOSE[i] <= dfVix.CLOSE[i+1]
                downdownDay = downdownDay +1
            elseif dfSpy."Adj Close"[i+1]>dfSpy."Adj Close"[i] && dfVix.CLOSE[i+1] > dfVix.CLOSE[i]
                dbu=dbu +1
            elseif dfSpy."Adj Close"[i+1]<dfSpy."Adj Close"[i] && dfVix.CLOSE[i+1] < dfVix.CLOSE[i]
                dbd=dbd +1
            end
        end
    end
    return upParadoxCount,downParadoxCount,ubu,dbu,ubd,dbd,upupDay,downupDay,downdownDay,updownDay,failedDown,failedUp,ddp,doup,dup,udp
end


ucRaw,dcRaw,ubu,dbu,ubd,dbd,upupDay,downupDay,downdownday,updownday,fDown,fUp,ddp,doup,dup,udp = MarkovItRaw()


"""
Comparing Raw close to adj close
results are very similar....
this gives me more confidence
"""
#renaming some vars
upup = upupDay
updown = updownday
downup = downupDay
downdown = downdownday
dd1 = fDown
uu1 = fUp 



#determining if our markov chain captures all possible states
stateChanges=ucRaw+dcRaw+ubu+dbu+ubd+dbd+upupDay+downupDay+downdownday+updownday+dd1+uu1+ddp+doup+dup+udp
#as you can see our markov chain captures 99% of all possible states
CaptureRatio=stateChanges/(size(dfSpy,1)-split)


#getting transition edges
function EdgeIt()
    upSum = updown +upup + ubu +ubd
    downSum =downdown + downup + dbu +dbd
    upDoxSum = ucRaw + uu1 +udp +dup
    downDoxSum = dcRaw + dd1 + doup + ddp

    ud = updown / upSum
    uu = upup / upSum
    dd = downdown / downSum
    du = downup / downSum

    ud2 = ubd / upSum
    uu2 = ubu / upSum
    dd2 = dbd / downSum
    du2 = dbu / downSum

    uud = ucRaw / upDoxSum
    uuu = uu1 / upDoxSum
    ddu = dcRaw / downDoxSum
    ddd = dd1 / downDoxSum

    doup1=doup / downDoxSum
    dup1=dup / upDoxSum
    udp1=udp / upDoxSum
    ddp1=ddp / downDoxSum
    #creating 4x4 matrix
    vv =[uu ud uu2 ud2;
        du dd du2 dd2;
        uuu uud dup1 udp1;
        ddu ddd doup1 ddp1]
    # rounding to 2 for user friendly chart
    vv2 = round.(vv;digits=3)
    return vv2
end

edges = EdgeIt()


#created markov chain graph
MarkovResults=graphplot(edges,nodecolor=[3,2,3,2], z=8,fontsize=6,edgelabel=edges, edgelabel_offset=0.08, nodeshape=:hexagon, self_edge_size=0.12,names=["↑", "↓", "↑↑", "↓↓"])
savefig(MarkovResults,"mk35")

# we see 56% chance up green afetr a down paradox
# about 51% chance of another green after up paradox
# innteresting results
# i will trade according to these results


####################################
#       SIMULATING TRADING         #
#       last 20% of data           #
####################################

#simulating each direction individually
function TradeIt(tradeAmount,dir)
    if dir =="up"
        tradeCount =0
        wins =0
        profit =0
        bank=0
        startingBank=0
        tradeHistory=[]
        print("---------Simulating $tradeAmount Shares---------",'\n')
        #using last 20% of datat to simulate real trading
        for i ∈ range(size(dfVix,1)-split,size(dfVix,1)-4)
            if dfSpy."Adj Close"[i] > dfSpy."Adj Close"[i-1] && dfVix.CLOSE[i] > dfVix.CLOSE[i-1]
                if bank==0
                    bank = tradeAmount * dfSpy."Adj Close"[i]
                    startingBank=bank
                    print("Starting Bank: \$", bank,'\n')
                end
                print("---------Making Trade---------",'\n')
                tradeCount = tradeCount +1
                price = dfSpy."Adj Close"[i]
                shares = bank/price
                longEntry = shares * price
                exitPrice =  dfSpy."Adj Close"[i+1]
                longExit = shares * exitPrice
                pl = longExit - longEntry
                bank = bank + pl
                if pl >0
                    wins=wins+1
                    print("---------Profit of $pl ---------",'\n')
                end
            end
            append!(tradeHistory,bank)
        end
        print("Starting Bank: \$", startingBank,'\n')
        print("Ending bank: \$",bank,'\n')
        print("Win Rate: ", wins/tradeCount,'\n')
        print("Profit(%): ",(bank/startingBank)-1,'\n')
        return tradeHistory
    elseif dir =="down"
        tradeCount =0
        wins =0
        profit =0
        bank=0
        startingBank=0
        tradeHistory=[]
        print("---------Simulating $tradeAmount Shares---------",'\n')
        #using last 20% of datat to simulate real trading
        for i ∈ range(size(dfVix,1)-split,size(dfVix,1)-4)
            if dfSpy."Adj Close"[i] < dfSpy."Adj Close"[i-1] && dfVix.CLOSE[i] < dfVix.CLOSE[i-1]
                if bank==0
                    bank = tradeAmount * dfSpy."Adj Close"[i]
                    startingBank = bank
                    print("Starting Bank: \$", startingBank,'\n')
                end
                print("---------Making Trade---------",'\n')
                tradeCount = tradeCount +1
                price = dfSpy."Adj Close"[i]
                shares = bank/price
                longEntry = shares * price
                exitPrice =  dfSpy."Adj Close"[i+1]
                longExit = shares * exitPrice
                pl = longExit - longEntry
                bank = bank + pl
                if pl >0
                    wins=wins+1
                    print("---------Profit of $pl ---------",'\n')
                end
            end
            append!(tradeHistory,bank)
        end
        print("Starting Bank: \$", startingBank,'\n')
        print("Ending bank: \$",bank,'\n')
        print("Win Rate: ", wins/tradeCount,'\n')
        print("Profit(%): ",(bank/startingBank)-1,'\n')
        return tradeHistory
    end
end




#up goes long on up paradox
upHist=TradeIt(100,"up")
#down also goes long on up paradox
downHist=TradeIt(100,"down")





function CombinedStrat(tradeAmount)
    tradeCount =0
    wins =0
    bank=0
    startingBank=0
    tradeHistory=[]
    print("---------Simulating $tradeAmount Shares---------",'\n')
    #using last 20% of datat to simulate real trading
    for i ∈ range(size(dfVix,1)-800,size(dfVix,1)-4)
        if dfSpy."Adj Close"[i] < dfSpy."Adj Close"[i-1] && dfVix.CLOSE[i] < dfVix.CLOSE[i-1]
            if bank==0
                bank = tradeAmount * dfSpy."Adj Close"[i]
                startingBank=bank
                print("Starting Bank: \$", bank,'\n')
            end
            print("---------Making Long Trade---------",'\n')
            tradeCount = tradeCount +1
            price = dfSpy."Adj Close"[i]
            shares = bank/price
            longEntry = shares * price
            exitPrice =  dfSpy."Adj Close"[i+1]
            longExit = shares * exitPrice
            pl = longExit - longEntry
            bank = bank + pl
            if pl >0
                wins=wins+1
                print("---------Profit of $pl ---------",'\n')
            end
    elseif dfSpy."Adj Close"[i] > dfSpy."Adj Close"[i-1] && dfVix.CLOSE[i] > dfVix.CLOSE[i-1]
            if bank==0
                bank = tradeAmount * dfSpy."Adj Close"[i]
                startingBank=bank
                print("Starting Bank: \$", bank,'\n')
            end
            print("---------Making Short Trade---------",'\n')
            tradeCount = tradeCount +1
            price = dfSpy."Adj Close"[i]
            shares = bank/price
            longEntry = shares * price
            exitPrice =  dfSpy."Adj Close"[i+1]
            longExit = shares * exitPrice
            pl = longExit - longEntry
            bank = bank + pl
            if pl >0
                wins=wins+1
                print("---------Profit of $pl ---------",'\n')
            end
        end 
        push!(tradeHistory,bank)
    end
    profit =(bank/startingBank)-1
    print("Starting Bank: \$", startingBank,'\n')
    print("Ending bank: \$",bank,'\n')
    print("Win Rate: ", wins/tradeCount,'\n')
    print("Profit(%): ",profit,'\n')
    return tradeHistory,tradeCount,profit
end



tradeHist,tradeCount,profit=CombinedStrat(100)

#plotting strat preformance against SPY
plot(dfSpy.Close[end-split:end],label="SPY")
plot!(upHist/100,label="↑ paradox")
plot!(downHist/100,label="↓ paradox")
plot!(tradeHist/100,label="combined")


start=dfSpy.Close[end-split]
en = dfSpy.Close[end-4]

heldSPY=en/start-1

#our strat did 2% less than SPY
formance = profit-heldSPY

#exposed to only 20% of the last 800 days
exposure = tradeCount / split
#FINAL NOTES


# our combined strat gave us nearly 27% ≈ 2 years
# SPY did about 29%, 
# 2% underpreformance with 80% less exposure
# 
# we could easily optimize this strategy in the real world
# potential optimizers
# - stop losses
# - more leverage



