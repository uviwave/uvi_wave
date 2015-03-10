function y=iwt(wx,rh,rg,k,tam,kl,del1,del2)

%   IWT  Discrete Inverse Wavelet Transform.
%
%        IWT (WX,RH,RG,K) calculates the 1D inverse wavelet transform 
%        of vector WX, which should be a K-scales direct wavelet
%        transform. If WX is a matrix, then it's supposed to hold a
%        wavelet transform vector in each of its rows, and every one
%        of them will be inverse transformed. The second argument RH 
%        is the synthesis lowpass filter and the third argument RG the 
%        synthesis highpass filter. 
%
%        IWT will calculate the size of the reconstructed vector(s) the
%        largest as possible (maybe 1 point larger than the original)
%        unless it is provided using IWT(WX,RH,RG,K,SIZ). A value of
%        0 for SIZ is the same as ommiting it.
%
%
%        IWT can be used to perform a single process of multiresolution
%        analysis. The way to do it is by selecting the scales whose
%        highpass bands (detail signals) should be ignored for 
%        reconstruction.
%
%        Using IWT(WX,RH,RG,K,SIZ,KL) where KL is a K-sized vector,
%        1's or 0's. An i-th coefficient of 0 means that the i-th scale 
%        detail (starting from the deepest) should be ignored. KL vector 
%        can be replaced by a single number for selecting just only the 
%        KL deepest scales.
%
%        An all-ones vector, or a single number equal to K, is the same 
%        as the normal inverse transform. 
%         
%	 IWT (WX,RH,RG,K,SIZ,KL,DEL1,DEL2) calculates the inverse
%        transform or performs the multiresolution analysis, but allowing
%        the users to change the alignment of the outputs with respect to 
%        the input signal. This effect is achieved by setting to DEL1 and 
%        DEL2 the analysis delays of H and G respectively, and calculating
%        the complementary delays for synthesis filters RH and RG. The 
%        default values of DEL1 and DEL2 are calculated using the function 
%        WTCENTER. 
%
%        See also: WT, WT2D, WTCENTER, WTMETHOD
%

% Restrictions:
%
%   - Synthesis filters from the same set as in analysis must be used.
%     If forced delays were used in analysis, the same delays should
%     be forced in synthesis (iwt calculates the complementary ones), 
%     so as to get a perfect vector reconstruction (or the equivalent 
%     in the case of not full reconstruction).
%
%   - The number of scales indicated in K, must match the number of 
%     them specified in the analysis process. Otherwise, the 
%     reconstruction will be absolutely erroneous. The same is
%     applied to the original vector size SIZ, but if it's not given,
%     or it's set to zero, IWT will give the recostructed vector the
%     largest size as possible.
%


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
%      Authors: Sergio J. Garcia Galan 
%               Cristina Sanchez Cabanelas 
%       e-mail: Uvi_Wave@tsc.uvigo.es
%--------------------------------------------------------



% -----------------------------------
%    CHECK PARAMETERS AND OPTIONS
% -----------------------------------

rh=rh(:)';	% Arrange the filters so that they are row vectors.
rg=rg(:)';

if nargin<6, 	% KL not given means reconstructing all bands.
	kl=k;
end;


if size(kl)==[1,1],		% If KL specifies the number of scales
	k1=zeros(1,k);		% then build the KL vector with KL ones
	k1(1:kl)=ones(1,kl);	% and K-KL zeros.
	kl=k1;
else
	if length(kl)~=k,	% Make sure that KL is K elements long.
		disp('KL should be a Single number (<=K) or a vector with K elements');
		return;
	end;

	for i=1:k		% And make sure that all nonzero elements in KL
		if kl(i)~=0, 	% are ones.
			kl(i)=1;
		end;
	end;	
end;



[liy,lix]=size(wx);

if lix==1			% If the input matrix is a column wavelet
	wx=wx';			% vector, we transpose it 
	trasp=1;		% and take note of it.
	[liy,lix]=size(wx);
end

% ----------------------------------
%    CHECK THE ORIGINAL LENGTH
% ----------------------------------

if (nargin<5)			% If no original size is given, set it 
	tam=0;			% to 'unknown'.
end;

if tam==0,			% If the original size is unknown 
	tam=maxrsize(lix,k);	% the maximum possible will be set.
	if tam==0,
		disp('Can''t determine the original length. K might be wrong');
		return;
	end
end
lo(1)=tam; 			% Keep in a vector the succesive sizes of
for i=1:k, 			% the wavelet bands.
        lo(i+1)=floor((lo(i)+1)/2);	
end


if lix~=sum(lo(2:k+1))+lo(k+1),	% Check the given size.
				% and arrange if possible
				% (the error can be in K)
	tam=maxrsize(lix,k);
	fprintf(1,'\nThe given size is not correct. Trying default size: ');
	fprintf(1,'%u\n',tam);
	if tam==0,	
		disp('No default size found. K might be wrong');
		return;
	end;
	lo(1)=tam; 
	for i=1:k, 
	        lo(i+1)=floor((lo(i)+1)/2);	
	end
	if lix~=sum(lo(2:k+1))+lo(k+1),	% If the default size is bad too, exit.
		disp('Default failed. K might be wrong');
		return
	end;
	fprintf(1,'(Check the result, may be wrong. If so, ckeck K)\n');
end


%--------------------------
%    DELAY CALCULATION 
%--------------------------

llp=length(rh);		% Length of the lowpass filter.
lhp=length(rg);		% Length of the highpass filter.

suml = llp+lhp-2;		% The total delay of the
difl = abs(lhp-llp);		% analysis-synthesis process
if rem(difl,2)==0		% must match the sum of the  
	suml = suml/2;		% analysis delay plus the synthesis  
end;				% delay. SUML holds this total
				% delay, which is different depending
				% on the kind of filters. 

% Calculate analysis delays as the reciprocal M. C.
dlpa=wtcenter(rg);
dhpa=wtcenter(rh);

if rem(dhpa-dlpa,2)~=0		% difference between them.
	dhpa=dhpa+1;		% must be even
end;

if nargin==8,			% Other experimental filter delays
	dlpa=del1;		% can be forced from the arguments,
	dhpa=del2;	
end;

dlp = suml - dlpa;		% Found the analysis delays, the 
dhp = suml - dhpa;		% synthesis are the total minus the
				% analysis ones.



%------------------------------
%    WRAPPAROUND CALCULATION 
%------------------------------

L=max([llp,lhp,dhp,dlp]);	% The number of samples for the
				% wrapparound.


%------------------------------
%     START THE ALGORITHM 
%------------------------------

for it=1:liy,			% For every row in WX ...

	ind=1+lo(k+1);		% Localize the 1st scale vector
	w=wx(it,1:lo(k+1)*2);	% y and set up the 1st iteration.
	
	for i=1:k
		lw=length(w);		% Length of the actual wavelet.
					% Cut it into two pieces :

		yl=w(1:lw/2);		% 1 - The lowpass vector...
		yl=[yl;zeros(1,length(yl))];	% interpolate it 
		yl=yl(:)';		% ending with a '0' so that 
		l=length(yl);		% the wrapparoud doesn't put
					% two samples toghether.
		pyl=yl;			% Then make the wrapparound for
		pl=length(pyl);		% this vector, which should match
		while L>pl		% with that left out in analysis.
			pyl=[pyl,yl];	% Once again, L can be greater than 
			pl=length(pyl);	% the vector, so it can be necessary			
		end 			% to cycle it.
		yl=[pyl(pl+1-L:pl),yl,pyl(1:L)];  % Attach the wrapparound.
	
		if (kl(i)~=0)		% Process the highpass band only if
					% KL specifies to do so.
			yh=w((lw/2+1):lw);	% 2 - The highpass vector.
			yh=[yh;zeros(1,length(yh))];	% The same operations
			yh=yh(:)';			% must be done to it.
			pyh=yh;				% ...
			pl=length(pyh);			% ...
			while L>pl			% ...
				pyh=[pyh,yh];		% ...
				pl=length(pyh);		% ...
			end 				% ...
			yh=[pyh(pl+1-L:pl),yh,pyh(1:L)];  % ...
		end;
	

		lx=length(yl);		% The length of each vector

		yl=conv(yl,rh);	% Do the lowpass systhesis filtering
		yl=yl(dlp+1+L:dlp+l+L);	% and leave out the filter delays
					% and the wrapparound.

		if (kl(i)~=0)		% If necessary, do the same with highpass.
			yh=conv(yh,rg);	
			yh=yh(dhp+1+L:dhp+l+L);	
			y1=yl+yh;		% Sum the two outputs
		else
			y1=yl;			% or get only the lowpass side.
		end;

		lx=length(y1);
		if lx>lo(k+1-i)		% If the added '0' was not needed
			y1=y1(1:lx-1);	% pick it out now, not before.
			lx=lx-1;	% (this reduces the next length)
		end

		if i<k				% If this wasn't the last scale
			ind=ind+lo(k+2-i);	% then set up the next one
			w=[y1,wx(it,(ind):(lo(k+1-i)+ind-1))];	
		end
	end
	y(it,:)=y1;		% One row vector reconstructed. 

end				% End if all vectors reconstructed

%------------------------------
%    END OF THE ALGORITHM 
%------------------------------


if trasp==1			% If the input wavelet was a column vector
	y=y';			% then transpose the result.
end
