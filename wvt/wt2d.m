function y=wt2d(x,h,g,k,del1,del2)

%WT2D   Two dimensional Wavelet Transform. 
%
%       WT2D(X,H,G,K) calculates the 2D wavelet transform of matrix
%       X at K scales. H is the analysis lowpass filter and G is the 
%       highpass one.
%
%	At every scale, the lowpass residue is placed at the top-left
%	corner of the corresponding subimage, the horizontal high 
%       frequency band at the top-right, the vertical high frequency 
%       band at the bottom-left and the diagonal high frequency band 
%       at the bottom-right. Every successive wavelet subimage 
%       substitutes the residue of the previous scale.
%	
%		Example with 2 scales:
%					 _______
%	2nd scale substituting the  -->	|_|_|   | <-- 1st scale 
%	first scale lowpass residue	|_|_|___|     horiz. detail	
%					|   |   | 
%		        1st scale ---->	|___|___| <-- 1st scale 
%		      vertical detail		    diagonal detail
%
%       WT2D (X,H,G,K,DEL1,DEL2) will perform the transformation
%       but allowing the user to change the alignment of the output
%       subimages with respect to the input image. This effect is 
%       achieved by setting to DEL1 and DEL2 the delays of H and
%       G respectively. The default values of DEL1 and DEL2 are 
%       calculated using the function WTCENTER. 
%
%       Run the script 'FORMAT2D' for more help on the output format.	
%       See also: IWT2D, WT, WTMETHOD


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
%       Author: Sergio J. Garcia Galan 
%       e-mail: Uvi_Wave@tsc.uvigo.es
%--------------------------------------------------------


% -----------------------------------
%    CHECK PARAMETERS AND OPTIONS
% -----------------------------------

h=h(:)';			% Arrange the filters so that they
g=g(:)';			% are row vectors.


[ly,lx]=size(x);		% The original image size


%------------------------------
%     SETUP WAVELET SIZES  
%------------------------------

lox(1)=lx;			% Keep in two vectors the succesive 
loy(1)=ly;			% wavelet widths and heights.
for i=1:k			
        lox(i+1)=floor((lox(i)+1)/2);	
        loy(i+1)=floor((loy(i)+1)/2);	
end
l1=sum(lox(2:k+1))+lox(k+1);	% The final wavelet width.
l2=sum(loy(2:k+1))+loy(k+1);	% The final wavelet height


%------------------------------
%   SETUP ARRAYS & OFFSETS
%------------------------------
				
y=zeros(l2,l1);			% Set up matrix.

px=l1-lx+1;			% The offsets to put the wavelet  
py=l2-ly+1;			% sub-image into the final matrix

tx=x;				% Copy the original.


%------------------------------
%     START THE ALGORITHM 
%------------------------------

for ind=1:k			% For every scale...

	[lxy,lxx]=size(tx);	

	lwx=floor((lxx+1)/2)*2; % Get the piece size for the present step.
	lwy=floor((lxy+1)/2)*2;

	%%% Now let's call WT to make the wt over the rows %%%
	%%% of the present sub image			   %%%

	if nargin>4
		tw(1:lxy,1:lwx)=wt(tx(1:lxy,1:lxx),h,g,1,del1,del2);
	else
		tw(1:lxy,1:lwx)=wt(tx(1:lxy,1:lxx),h,g,1);
	end;

	%%% And now over the columns  %%%

	if nargin>4
		tw(1:lwy,1:lwx)=wt(tw(1:lxy,1:lwx)',h,g,1,del1,del2)';
	else
		tw(1:lwy,1:lwx)=wt(tw(1:lxy,1:lwx)',h,g,1)';
	end

	if lwx>lxx		% Actualize the offsets if the wavelet
		px=px-1;	% stage is '1 point' greater than the
	end			% original sub-image. (*)
	if lwy>lxy
		py=py-1;
	end

	y(py:py+lwy-1,px:px+lwx-1)=tw;	% Place the wavelet stage into 
	tx=tw(1:lwy/2,1:lwx/2);		% the result vector and set up 
	tw=[];				% the next scale.

end				% end of all scales.

%------------------------------
%    END OF THE ALGORITHM 
%------------------------------
