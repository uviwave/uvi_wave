%BASIS    Script with help on the basis format used for specifying
%         the wavelet packet transform in the Uvi_Wave toolbox.

%--------------------------------------------------------
% Copyright (C) 1994, 1995, 1996, by Universidad de Vigo 
%                                                      
%                                                      
% Uvi_Wave is free software; you can redistribute it and/or modify it      
% under the terms of the GNU General Public License as published by the    
% Free Software Foundation; either version 2, or (at your option) any      
% later version.                                                           
%                                                                          
% Uvi_Wave is distributed in the hope that it will be useful, but WITHOUT  
% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or    
% FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License    
% for more details.                                                        
%                                                                          
% You should have received a copy of the GNU General Public License        
% along with Uvi_Wave; see the file COPYING.  If not, write to the Free    
% Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.             
%                                                                          
%      Authors: Santiago Gonzalez Sanchez
%		Nuria Gonzalez Prelcic 
%       e-mail: Uvi_Wave@tsc.uvigo.es
%--------------------------------------------------------

echo on

% * One dimensional wavelet packet transform
% ==========================================
%
% There are two possible formats when specifying a 1-D wavelet
% packet basis.

% In order to illustrate the differences between them we are going
% to begin defining an example filter bank structure:
%
%
%                         ______
%                        |
%                  ______|       ______
%                 |      |      |
%                 |      |______|
%           ______|             |
%                 |             |______
%                 |
%                 |______
%
%
% (Upper branchs are highpass filterings, lower branchs are lowpass).

% In the next paragraphs these formats will be defined.

% Press any key to continue ...
pause
%----------------------------------------------------------

% 1) Order according to the filter bank scheme.
%
% This first option is known in the literature as "natural order".
%
% It gives the basis ordered as the filter bank structure.
% The vector indicates the depth of every terminal node in the
% tree.
% The vector elements always begin with the branch which
% performs the lowpass filter iteration.
%
% Then, the basis vector for the previous
% example would be:
%                    basis=[1, 3, 3, 2]
%
% The wavelet packet coefficients obtained using such
% format are ordered in the same way.
%
% With this basis format the output subbands are not
% ordered in frequency.

% Press any key to continue ...
pause
%----------------------------------------------------------

% 2) Order according to the frequency decomposition (subbands).
%
% This basis format provides the coefficients ordered in frequency.
% This option is interesting because you can specify the
% parameter 'basis' in terms of a specific subband splitting. 
% So, you do not need to think about the filter bank structure
% that implement the desired frequency splitting. 
%   
% Let's suppose we need to perform the following subband
% decomposition (that coincides with the one obtained by
% the filter bank proposed at the beginning of this file):
% 
%
%
%                 |                |       |   |   |
%                 |                |       |   |   |
%                 |                |       |   |   |
%                 |                |       |   |   |
%               -------------------------------------------> f
%                 0               Fs/4            Fs/2 
%
% 
% With this format, the 'basis' elements always begin with 
% the 'most' lowpass subband. 
% In this case, the vector elements will be:
%
%              basis=[1, 2, 3, 3]
%
% Think about this ... It is not trivial to know which is the
% filter bank structure that performs this subband decomposition.
% (And this is a simple case).

% Press any key to continue ...
pause
%----------------------------------------------------------

% REMARKS:
%
%  - By default, the basis selection functions return the parameter
%    basis in the first format .
%
%  - Using the function 'chformat' you can easily change from one
%    basis format to the other one. Moreover, you can change the
%    order of the output of the wpk function.
%

% Press any key to continue ...
pause
%----------------------------------------------------------

% * Two dimensional wavelet packet transform
% ==========================================
%
% The basis for two dimensional signals is similar to 
% the 1-D case. Basis  vector goes over the terminal nodes of the
% filter bank tree, holding a value for each node. That value is
% the depth level in the tree. Notice that a basis format 'frequency
% ordered' was not considered for the 2-D case.
%	
% Now, there is four possible branches descending from a node.
% The nodes/subbands are sorted in this order: lowpass approximation,
% vertical detail, horizontal detail and diagonal detail.

% Press any key to continue ...
pause
%----------------------------------------------------------

% For example, the decomposition depicted as follows
%
%		   ______   diagonal detail
%                 |     
%                 |     
%                 |            
%                 |______   horizontal detail   
%		  |
%                 |       _____   \
%            -----|	 |_____    | 
%                 |______|_____    |  vertical detail, subdivided
%		  |      |_____	  /
%                 |
%		  |	  _____   \
%                 |______|_____    |
%			 |_____    |  lowpass approximation, subdivided in other 4 bands
%			 |_____   /
%
%
% corresponds to BASIS = [2,2,2,2, 2,2,2,2, 1, 1]. The transform signal would be a 
% matrix ordered this way:
%			     ___ ___
%                           |_|_|   |
%                           |_|_|___|
%                           |_|_|   |
%                           |_|_|___|
%
% Another example: the basis for obtaining a 3 scales wavelet transform
% would be [3,3,3,3,2,2,2,1,1,1].

echo off
