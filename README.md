ece566_bci_project
==================

Reproducing results of 
"Band-specific features improve finger flexion prediction from ECoG"
winning submission to the [BCI Competition IV](http://www.bbci.de/competition/iv/)

They based their methods on the theory that the cortex uses
amplitude modulation to encode information, they extracted useful features with
an equiripple Finite Impulse Response (FIR) band pass filter. 

They separated signal into bins of 1-60Hz, 60-100Hz and 100-200Hz
and then computed the signal power over 40ms windows.

They created three feature vectors for each EcOG channel, and used
a stepwise feature selection process, to additively create a set of features
for linear regression. They searched for the best features to add and continued until the correlation
on test wasn't increasing or until an iterative threshold.
 
Read more here: report/Classification_for_BCI.pdf
