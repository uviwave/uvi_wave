% Wavelet Toolbox (Uvi_Wave)
% Version 3.0  1-Jun-96
% Copyright 1996, Universidad de Vigo
% ftp server:  ftp.tsc.uvigo.es
%
% Wavelet Transform.
%    wt		- One dimensional Wavelet Transform
%    iwt  	- Inverse one dimensional Wavelet Transform
%    wt2d	- Two dimensional Wavelet Transform
%    iwt2d	- Inverse two dimensional Wavelet Transform
%    wtmethod	- Wavelet subband alignment method selection
%    format2d	- Script about the output format for 2D wavelet
%
% Multiresolution Analysis.
%    nssffb	- Non sub-sampled wavelet FIR filter bank
%    inssffb	- Inverse non sub-sampled wavelet FIR filter bank
%    nss2d	- 2D non sub-sampled wavelet FIR filter bank
%    inss2d	- Inverse 2D non sub-sampled wavelet FIR filter bank
%    aprox	- One dimensional multiresolution approximation signal
%    detail	- One dimensional multiresolution detail signal
%    multires	- Full one dimensional multiresolution analysis
%    mres2d	- 2D multiresolution approximation/detail image
%    wavelet	- Wavelet and scale functions calculation
%
% Filter Generation.
%    wspline	- Spline biorthogonal filters generation 
%    daub	- Daubechies orthogonal filters generation
%    maxflat	- Maximally flat orthogonal filters
%    symlets	- Least-asymmetric Daubechies orthogonal filters    
%    lemarie	- Battle-Lemarie orthogonal filters
%    remezflt	- Remez orthogonal wavelet filters generation
%
% Regularity estimation functions.
%    tempreg	- Holder regularity index based on a time approach
%    specreg	- Regularity estimate based on the spectrum
%    regdaub	- Holder regularity estimate for Daubechies' filters      
%
% Subband Processing Utilities.
%    bandsite	- Wavelet subband localization
%    bandext	- Wavelet subband extraction
%    bandins	- Wavelet subband insertion
%    bandmax	- Wavelet subband maxima extraction
%    elmin	- Wavelet transform minima deletion
%    localext	- Wavelet transform local limits extraction
%    center	- Wavelet subband alignment calculation
%    wtcenter	- Wavelet subband methodical alignment calculation
%    wvltsize	- Wavelet transform size calculation
%    maxrsize	- Inverse wavelet transform size calculation
%    siteband	- Wavelet Packet subband localization
%    extband    - Wavelet Packet subband extraction
%    insband	- Wavelet Packet subband insertion
%
% Scalogram.
%    morletw   - Morlet Wavelet calculation
%    scalog    - Scalogram calculation
%    srf       - 3D representation of a surface
%
% Wavelet Packet Transform.
%    wpk        - Direct Wavelet Packet Transform
%    iwpk       - Inverse Wavelet Packet Transform
%    wavepack	- Wavelet Packet functions calculation
%    wpk2d	- Direct Two Dimensional Wavelet Packet Transform
%    iwpk2d	- Inverse 2D Wavelet Packet Transform
%    pruneadd   - Tree pruning algorithm for additive costs
%    prunenon   - Pruning algorithm for non-additive costs
%    growadd    - Tree growth algorithm for additive costs
%    grownon    - Growth algorithm for non-additive costs
%    prune2d	- Quadtree pruning algorithm for additive costs
%    lpenerg    - Energy with l^p norm
%    shanent    - Shannon entropy of the coefficients
%    logenerg   - 'Log energy' functional
%    cwent      - Coifman-Wickerhauser entropy of the coefficients
%    weaklp     - Weak l^p norm
%    cmparea    - Compression area with squared coefficients
%    cmpnum     - Compression number
%
% Wavelet Packet Utilities. 
%    chformat   - Changes the format of basis and/or reorder the coefficients
%    coefext    - Extracts the coefficients corresponding to a certain basis
%    band2idx	- Level and node in the tree for each basis vector element
%    basis      - Script about the basis formats
%
% Viewing Utilities.
%    show	- 2D image viewing with brightening scaling
%    bandadj	- 2D wavelet transform subband bright normalization
%    nrm  	- Specific normalization process for bandadj
%    split	- Multi-plot matrix splitting
%    isplit	- One dimensional wavelet transform subband split
%    discplot	- Discrete-style one dimensional plot
%    tfplot	- Time-frequency plane tiling of 1D transforms
%    tree	- Decomposition tree for 1D wavelet or wavelet packet
%    band2d	- Subband partition for 2D transforms
%
% Demo programs.
%    genimg    	- Generation of a set of 11 different test images 
%    wtdemo    	- Menu for all the available demos 
%    wt___dmo  	- Demo on some 1D wavelet transform capabilities 
%    wt2d_dmo  	- Menu for 2D wavelet transform demos
%    wvt2ddmo	- Demo on some 2D wavelet capabilities
%    fmt2ddmo	- Demo on the output format for 2D wavelet transform
%    mrs__dmo  	- Demo on 1D / 2D multiresolution analysis
%    flds_dmo	- Menu for filter design demos
%    flt_dmo.m  - Submenu for the available filter families
%    daub_dmo	- Demo on orthogonal Daubechies' filters generation
%    wspl_dmo	- Demo on biorthogonal spline wavelets
%    syml_dmo	- Demo on 'Symlet' filters
%    flat_dmo	- Demo on maximally flat wavelet filters
%    btlmrdmo	- Demo on Battle-Lemarie filters
%    remezdmo	- Demo on Remez wavelet filters
%    reg__dmo   - Demo on regularity estimates
%    scaldmo    - Demo of the scalogram 
%    wpkdmo     - Menu for 1D wavelet packet transform demos
%    formatdm   - Demo on the formats of the wavelet packet basis
%    wp_dmo     - Demo on some 1D wavelet packet transform capabilities 
%    basisdmo   - Demo on 1D tree search algorithms
%    wpk2ddmo	- Menu for 2D wavelet packet transform demos
%    wp2d_dmo	- Demo on some 2D WP transform capabilities 
%    bas2ddmo	- Demo on Coifman-Wickerhauser basis selection algorithm for 2D
%    gnimgdmo  	- Shows images generated by genimg
%
%   Copyright 1996, Universidad de Vigo
%   All rights reserved.
