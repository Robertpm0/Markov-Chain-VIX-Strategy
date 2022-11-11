# Markov-Chain-VIX-Strategy
4 state markov chain analysis looking at the probability of up/down days following a same direction move from the SPY &amp;&amp; CBOE VIX.

(ran on data 2007 to current)

![mk35](https://user-images.githubusercontent.com/95504207/201275217-4252e55a-2c8d-4d98-8fb9-60a117eb6e29.png)

Final results on an 80/20 split gave me a 27% return over the last 800 days no stop losses just buy on i and sell on i+1 ...

I plan to improve this strategy by implementing stop losses and potentially adding leverage later on....

### Things I still need to do

\- test on entirety of spy and vix datasets. eg: before year 2000

\-run strategy randomly chosen 20% samples to ensure profitability of strategy

\-enhance backtesting

\- run analysis against other major indices. Some that have potential: IXIC, DJI, BTC

\- implement alpaca API


## Motivation
![ss](https://user-images.githubusercontent.com/95504207/201195956-2d4e4581-a77c-4082-9a7f-07b16ba125ac.PNG)
https://twitter.com/zerohedge/status/1569348935357014016?s=20&t=kn1azbjUlhsLAMshFIxl1Q

\- In this tweet from @zerohedge arises a common should I say, trade strategy, that I see many talk about

\- typically the VIX and SPY move in the opposite direction

\- heres why

![vixformula](https://www.cboe.com/_img/general/vix-formula-01.png)

\- the fundamental reasoning behind the VIX's opposite movement is as follows

\- the vix takes into account previous, current, and future options prices relative to our current market

\- the calculation of the VIX is dependent on two main things, Price $K$, and Time $T$

\- we notice $T$ is used as a denominator and an exponent in this equation, 

\- $\therefore$ as Time increases, it will positively impact the VIX level

\- $Q(k_i) is a factor that pulls the vix in whichever direciton the options are moving

\- Another thing we see is that the difference betweeen index prices of i+1 and i-1 will be dividied by the current index price,
this means that if there is an major move expected in the future this could increase the vix if the current price is lower than the previous day
and if the current price is higher than the day before we should see a decrease in our vix

\- on the right on the equation we see that the closest price below our index is divided by the current index price and then squared. This number is subtracted from our initial calculation, 

\- This calculaiton will grow larger as the price increases $\therefore$ decreasing our VIX if all else remains constant. If Investors start buying options close to the index this would also bring this calculation down and increase the vix's overall calculation, which makes alot of sense if we are assuming the vix is a measure of risk in the market.


\- The vix does a very well job of measuring risk in our markets and when there are days that major indices move the same direction as the vix, it typically is a sign of a strong anticipation in the options market,the change in time to options expiring, or there are the cases where the mear stength of the price can pull the vix in the same direciton as we see in calculation $Q(K_i)
 
## Conclusion

My Results show that it is more likely for a up day following a down paradox day. This makes sense because the vix is fighting against time and $Q((k_i)$ so if the VIX is negative and the SPY is down this is a strong indcator investors are heavily buying options far away from the current price which could be assocaited to market confidence.

On the other hand my results show that when there is an up paradox day it is actually more likley for their to be another up day, why is this? The options levels can remain the exact same and even increase indicating strength in the markets but if it is not enough to out preform the change in time and $Q((k_i)$, the vix will incerase anyway, this could cause unnecessary shorting that could end up in a splurge of covering (buying) of the shares as the price continues to rise regaurdless of this vix increase. 

\- the main thing that makes the up paradox a less biased trade is because there is more forces imapcting the VIX positively, meaning it takes alot less options activity to cause positive vix day, less options acitivty further away from prices doesent necesarily mean a crash, but when there is heavy options activity out of the money this is almost always a good thing for the market and the VIX captures this activity allowing us to detemrine if the market is confident in the future








