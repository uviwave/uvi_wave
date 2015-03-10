% Wavelet Toolbox Filter Generation Section
% Version 3.0  1-Jun-96
%
% Filter Generation.
%    wspline	- Spline biorthogonal filters generation 
%    daub	- Daubechies orthogonal filters generation
%    maxflat	- Maximally flat orthogonal filters
%    symlets	- Least-asymmetric Daubechies orthogonal filters    
%    lemarie	- Battle-Lemarie orthogonal filters
%    remezflt	- Remez orthogonal wavelet filters generation       
%    remezwav	- z-Polynomial for Remez wavelet filters
%
% Auxiliary functions.
%    numcomb	- Combinatorial number 
%    trigpol	- Trigonometric polynomial
%    rh2rg	- Derives all the orthogonal filters from synthesis lowpass  
%    fact	- Factorial 
%    binewton	- Coefficients of Newton binomial 
%    calhpf	- Highpass analysis and synthesis filters 
%    chsign	- Change the sign of even or odd indexed samples
%    linealiz   - Removes the linearity of a phase vector
%    atang1	- Phase contribution of a complex pair of zeros
%    atang2	- Phase contribution of a real zero
%    dec2bina	- Decimal to binary basis
%    fc_cceps	- Complex cepstrum factorization
%    invcceps	- Complex cepstrum inversion
%    mycceps	- Variant of the complex cepstrum calculation
%    diezmo	- Decimates by a given factor
%
% Regularity estimation functions.
%    tempreg	- Holder regularity index based on a time approach
%    specreg	- Regularity estimate based on the spectrum
%    regdaub	- Holder regularity estimate for Daubechies' filters
%
%   Copyright 1996, Universidad de Vigo
%   All rights reserved.
