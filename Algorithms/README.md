# Algorithms
The following is a brief description of the Machine Learning parameters and formulas for
reference. It doesn't go in depth of how the formulas are developed; rather than, it displays the math of how I developed the parameters
and algorithms that are in the individual code scripts.

### Localizied Weighted Regression

Formulas for weights, coefficients, and predicted line: <br />

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="https://www.codecogs.com/eqnedit.php?latex=W&space;=&space;e&space;^&space;{(\frac{{-(x^{(i)}&space;-&space;x)^2}}{2\tau^2&space;})}&space;\;&space;,where&space;\;&space;\tau&space;\;&space;is\;&space;the\;&space;bandwidth" target="_blank"><img src="https://latex.codecogs.com/gif.latex?W&space;=&space;e&space;^&space;{(\frac{{-(x^{(i)}&space;-&space;x)^2}}{2\tau^2&space;})}&space;\;&space;,where&space;\;&space;\boldsymbol{\tau}&space;\;&space;is\;&space;the\;&space;bandwidth" title="W = e ^ {(\frac{{-(x^{(i)} - x)^2}}{2\tau^2 })} \; ,where \; \boldsymbol{\tau} \; is\; the\; bandwidth" /></a> <br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="https://www.codecogs.com/eqnedit.php?latex=\beta&space;=&space;(X^{T}WX)^{-1}X^{T}Wy" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\beta&space;=&space;(X^{T}WX)^{-1}X^{T}Wy" title="\beta = (X^{T}WX)^{-1}X^{T}Wy" /></a> <br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://www.codecogs.com/eqnedit.php?latex=\tilde{y}&space;=&space;\beta_{0}&space;&plus;&space;(\beta_1x^1&space;&plus;&space;\beta_2x^{2}&space;...\;&space;\beta_{n-1}x^{n-1})" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\tilde{y}&space;=&space;\beta_{0}&space;&plus;&space;(\beta_1x^1&space;&plus;&space;\beta_2x^{2}&space;...\;&space;\beta_{n}x^{n})" title="\tilde{y} = \beta_{0} + (\beta_1x^1 + \beta_2x^{2} ...\; \beta_{n}x^{n})" /></a>

### Linear Regression by Gradient Descent

Formulas for coefficients and predicted line: <br />

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="https://www.codecogs.com/eqnedit.php?latex=\beta_{j}&space;=&space;\beta_{j}&space;-&space;\frac{\alpha}{m}&space;\sum_{i&space;=&space;1}^{m}[(h_{\theta}{(x_{i}})&space;-&space;y)x_{i}],&space;\;&space;where\;&space;\boldsymbol{\alpha}\;&space;is\;&space;the\;&space;learning\;rate" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\beta_{j}&space;=&space;\beta_{j}&space;-&space;\frac{\alpha}{m}&space;\sum_{i&space;=&space;1}^{m}[(h_{\theta}{(x_{i}})&space;-&space;y)x_{i}],&space;\;&space;where\;&space;\boldsymbol{\alpha}\;&space;is\;&space;the\;&space;learning\;rate" title="\beta_{j} = \beta_{j} - \frac{\alpha}{m} \sum_{i = 1}^{m}[(h_{\theta}{(x_{i}}) - y)x_{i}], \; where\; \boldsymbol{\alpha}\; is\; the\; learning\;rate" /></a> <br />

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://www.codecogs.com/eqnedit.php?latex=\tilde{y}&space;=&space;\beta_{0}&space;&plus;&space;(\beta_1x^1&space;&plus;&space;\beta_2x^{2}&space;...\;&space;\beta_{n-1}x^{n-1})" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\tilde{y}&space;=&space;\beta_{0}&space;&plus;&space;(\beta_1x^1&space;&plus;&space;\beta_2x^{2}&space;...\;&space;\beta_{n}x^{n})" title="\tilde{y} = \beta_{0} + (\beta_1x^1 + \beta_2x^{2} ...\; \beta_{n}x^{n})" /></a>


### Linear Regression by QR Decomposition:

Formula: <br />

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="https://www.codecogs.com/eqnedit.php?latex=Ax&space;=&space;b" target="_blank"><img src="https://latex.codecogs.com/gif.latex?Ax&space;=&space;b" title="Ax = b" /></a> <br />


&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="https://www.codecogs.com/eqnedit.php?latex=\textup{A}&space;=&space;\textup{QR}&space;=&space;Q\begin{bmatrix}&space;R_1\\0&space;\end{bmatrix}&space;=&space;[Q_1,Q_2]\begin{bmatrix}&space;R_1\\0&space;\end{bmatrix}&space;=&space;Q_1R_1" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\textup{A}&space;=&space;\textup{QR}&space;=&space;Q\begin{bmatrix}&space;R_1\\0&space;\end{bmatrix}&space;=&space;[Q_1,Q_2]\begin{bmatrix}&space;R_1\\0&space;\end{bmatrix}&space;=&space;Q_1R_1" title="\textup{A} = \textup{QR} = Q\begin{bmatrix} R_1\\0 \end{bmatrix} = [Q_1,Q_2]\begin{bmatrix} R_1\\0 \end{bmatrix} = Q_1R_1" /></a>

### Gaussian Discriminant Analysis

Parameters and Formulas: <br />

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="https://www.codecogs.com/eqnedit.php?latex=Model:&space;\arg&space;\max_y&space;p(y|x)&space;=&space;\arg&space;\max_y&space;p(x|y)p(y)" target="_blank"><img src="https://latex.codecogs.com/gif.latex?Model:&space;\arg&space;\max_y&space;p(y|x)&space;=&space;\arg&space;\max_y&space;p(x|y)p(y)" title="Model: \arg \max_y p(y|x) = \arg \max_y p(x|y)p(y)" /></a>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="https://www.codecogs.com/eqnedit.php?latex=p(y)&space;=&space;\phi^{y}(1-\phi)^{(1-y)}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?p(y)&space;=&space;\phi^{y}(1-\phi)^{(1-y)}" title="p(y) = \phi^{y}(1-\phi)^{(1-y)}" /></a>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="https://www.codecogs.com/eqnedit.php?latex=p(x|y&space;=&space;0)&space;=&space;\frac{1}{(2pi)^{\frac{n}{2}}|\sum|^{\frac{1}{2}}}exp(-1/2&space;(x&space;-&space;u_0)^{T}&space;(\sum)^{-1}(x-u_0))" target="_blank"><img src="https://latex.codecogs.com/gif.latex?p(x|y&space;=&space;0)&space;=&space;\frac{1}{(2pi)^{\frac{n}{2}}|\sum|^{\frac{1}{2}}}exp(-1/2&space;(x&space;-&space;u_0)^{T}&space;(\sum)^{-1}(x-u_0))" title="p(x|y = 0) = \frac{1}{(2pi)^{\frac{n}{2}}|\sum|^{\frac{1}{2}}}exp(-1/2 (x - u_0)^{T} (\sum)^{-1}(x-u_0))" /></a> <br />

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="https://www.codecogs.com/eqnedit.php?latex=p(x|y&space;=&space;1)&space;=&space;\frac{1}{(2pi)^{\frac{n}{2}}|\sum|^{\frac{1}{2}}}exp(-1/2&space;(x&space;-&space;u_1)^{T}&space;(\sum)^{-1}(x-u_1))" target="_blank"><img src="https://latex.codecogs.com/gif.latex?p(x|y&space;=&space;1)&space;=&space;\frac{1}{(2pi)^{\frac{n}{2}}|\sum|^{\frac{1}{2}}}exp(-1/2&space;(x&space;-&space;u_1)^{T}&space;(\sum)^{-1}(x-u_1))" title="p(x|y = 1) = \frac{1}{(2pi)^{\frac{n}{2}}|\sum|^{\frac{1}{2}}}exp(-1/2 (x - u_1)^{T} (\sum)^{-1}(x-u_1))" /></a>

### Logistic Regression by Gradient Descent

Beta and Gradient: <br />

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="https://www.codecogs.com/eqnedit.php?latex=\beta_{j}&space;=&space;\beta_{j}&space;-&space;\frac{\alpha}{m}&space;\sum_{i&space;=&space;1}^{m}[(h_{\theta}{(x_{i}})&space;-&space;y)x_{i}],\;&space;where\;&space;\boldsymbol{\alpha}\;&space;is\;&space;the\;&space;learning\;rate\;and\;h_{\theta}(x_{i})&space;=&space;\frac{1}{1&plus;exp^{-\beta^{T}x}}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\beta_{j}&space;=&space;\beta_{j}&space;-&space;\frac{\alpha}{m}&space;\sum_{i&space;=&space;1}^{m}[(h_{\theta}{(x_{i}})&space;-&space;y)x_{i}],\;&space;where\;&space;\boldsymbol{\alpha}\;&space;is\;&space;the\;&space;learning\;rate\;and\;h_{\theta}(x_{i})&space;=&space;\frac{1}{1&plus;exp^{-\beta^{T}x}}" title="\beta_{j} = \beta_{j} - \frac{\alpha}{m} \sum_{i = 1}^{m}[(h_{\theta}{(x_{i}}) - y)x_{i}],\; where\; \boldsymbol{\alpha}\; is\; the\; learning\;rate\;and\;h_{\theta}(x_{i}) = \frac{1}{1+exp^{-\beta^{T}x}}" /></a>
