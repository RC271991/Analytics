# Algorithms

The following is a brief description of the Machine Learning parameters and formulas for
reference.

### Localizied Weighted Regression

To solve for the coefficients and predicted line: <br />

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="https://www.codecogs.com/eqnedit.php?latex=w&space;=&space;e&space;^&space;{(\frac{{-(x^{(i)}&space;-&space;x)^2}}{2\tau^2&space;})}&space;\;&space;,where&space;\;&space;\tau&space;\;&space;is\;&space;the\;&space;bandwidth" target="_blank"><img src="https://latex.codecogs.com/gif.latex?w&space;=&space;e&space;^&space;{(\frac{{-(x^{(i)}&space;-&space;x)^2}}{2\tau^2&space;})}&space;\;&space;,where&space;\;&space;\tau&space;\;&space;is\;&space;the\;&space;bandwidth" title="w = e ^ {(\frac{{-(x^{(i)} - x)^2}}{2\tau^2 })} \; ,where \; \tau \; is\; the\; bandwidth" /></a> <br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="https://www.codecogs.com/eqnedit.php?latex=\beta&space;=&space;(X^{T}WX)^{-1}X^{T}Wy" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\beta&space;=&space;(X^{T}WX)^{-1}X^{T}Wy" title="\beta = (X^{T}WX)^{-1}X^{T}Wy" /></a> <br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://www.codecogs.com/eqnedit.php?latex=\tilde{y}&space;=&space;\beta_{0}&space;&plus;&space;(\beta_1x^1&space;&plus;&space;\beta_2x^{2}&space;...\;&space;\beta_{n-1}x^{n-1})" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\tilde{y}&space;=&space;\beta_{0}&space;&plus;&space;(\beta_1x^1&space;&plus;&space;\beta_2x^{2}&space;...\;&space;\beta_{n-1}x^{n-1})" title="\tilde{y} = \beta_{0} + (\beta_1x^1 + \beta_2x^{2} ...\; \beta_{n-1}x^{n-1})" /></a>
