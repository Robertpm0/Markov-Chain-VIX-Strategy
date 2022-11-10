# Markov-Chain-VIX-Strategy
A markov chain analysis looking at the probability of up/down days following a same direction move from the SPY &amp;&amp; CBOE VIX.


## Motivation
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

\- Another thing we see is that the difference betweeen index prices of i+1 and i-1 will be dividied by the current index price,
this means that if there is an major move expected in the future this could increase the vix if the current price is lower than the previous day
and if the current price is higher than the day before we should see a decrease in our vix

\- on the left on the equation we see that the closest price below our index is divided by the current index price and then squared. This number is subtracted from our initial calculation, 

\-$\therefore$ as options move further away from their index it will decrease our vix

\- this makes alot of sense because if the closest strike is far awawy from the index, this typically means there is alot of people in the money and supporting lower prices aka the stock wont fall as far, and vice versa if the closest strike is far above the index this means people are buying options out of the money expecting a potential rise.

\- At the end of the day the vix is going to move down based on the support for both lower and higher prices, indicating investors are confident in the market. And when the vix is up, this is when investors are mostly confident in the prices near our current level and as time progresses and price remains mostly staionary
 
## Conclusion

My Results show that it is more likely for a up day following a down paradox day. This makes sense because the vix is fighting against time and $Q((k_i)$ so if the VIX is negative and the SPY is down this is a strong indcator investors are heavily buying options far away from the current price which could be assocaited to market confidence.

On the other hand my results show that when there is an up paradox day it is actually more likley for their to be another up day, why is this? The options levels can remain the exact same and even increase indicating strength in the markets but if it is not enough to out preform the change in time and $Q((k_i)$, the vix will incerase anyways. 

\- the main thing that makes the up paradox a less biased trade is because there is more forces imapcting the VIX positively, meaning it takes alot less options activity to cause positive vix day, less options acitivty further away from prices doesent necesarily mean a crash, but when there is heavy options activity out of the money this is almost always a good thing for the market and the VIX captures this activity allowing us to detemrine if the market is confident in the future








