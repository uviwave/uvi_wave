function y=iwt2d(wx,rh,rg,k,tamx,tamy,kl,del1,del2)

% IWT2D Two dimensional Inverse Wavelet Transform.
%
%	IWT2D(WX,RH,RG,K) calculates the two dimensional inverse 
%       wavelet transform of matrix WX, which is supposed to be a 
%       two dimensional K-scales direct wavelet transform of any 
%       matrix or image. RH is the synthesis lowpass filter and 
%       RG is the synthesis highpass filter.
%
%       The original image size can be provided by specifying
%       IWT2D (WX,RH,RG,K,SIZX,SIZY). If any of SIZX or SIZY is not
%       given or set to zero, IWT2D will calculate the maximum for 
%       the direction.
%
%       IWT2D can be used to perform a single process of multiresolution
%       analysis. The way to do it is by selecting the scales whose
%       highpass bands (detail signals) should be ignored for 
%       reconstruction.
%
%       Using IWT2D (WX,RH,RG,K,SIZX,SIZY,KL) where KL is a K-sized vector,
%       1's or 0's. An i-th coefficient of 0 means that the i-th scale 
%       detail images (starting from the deepest) should be ignored.
%       The KL vector can be replaced by a single number for selecting 
%       just only the KL deepest scales.
%
%       An all-ones vector, or a single number equal to K, is the same 
%       as the normal inverse transform. 
%         
% 	IWT2D (WX,RH,RG,K,SIZX,SIZY,KL,DEL1,DEL2) calculates the inverse
%       transform or performs the multiresolution analysis, but allowing
%       the users to change the alignment of the outputs with respect to 
%       the input signal. This effect is achieved by setting to DEL1 and 
%       DEL2 the analysis delays of H and G respectively, and calculating
%       the complementary delays for synthesis filters RH and RG. The 
%       default values of DEL1 and DEL2 are calculated using the function 
%       WTCENTER. 
%
%       See also: WT, WT2D, WTCENTER, WTMETHOD
%

%
% Restrictions:
%
%   - Synthesis filters from the same set as in analysis must be used.
%     If forced delays were used in analysis, the same delays should
%     be forced in synthesis (iwt2d calculates the complementary ones),
%     so as to get a perfect image reconstruction (or the equivalent 
%     in the case of not full reconstruction)..
%
%   - The number of scales indicated in K, must match the number of 
%     them specified in the analysis process. Otherwise, the 
%     reconstruction will be absolutely erroneous. The same is
%     applied to the original image size (SIZX,SIZY), but if it's not 
%     given or it's set to zero, IWT will give the recostructed image 
%     the largest size as possible.
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
%       Author: Sergio J. Garcia Galan 
%       e-mail: Uvi_Wave@tsc.uvigo.es
%--------------------------------------------------------


% -----------------------------------
%    CHECK PARAMETERS AND OPTIONS
% -----------------------------------

rh=rh(:)';	% Arrange the filters so that they are row vectors.
rg=rg(:)';


if nargin<7, 	% KL not given means reconstructing all bands.
	kl=k;
end;


if size(kl)==[1,1],		% If KL specifies the number of scales
	k1=zeros(1,k);		% then build the KL vector with KL ones
	k1(1:kl)=ones(1,kl);	% and K-KL zeros.
	kl=k1;
else
	if length(kl)~=k,	% Make sure that KL is K elements long.
		disp('KL should be a Single number or a vector with K elements');
		return;
	end;

	for i=1:k		% And make sure that all nonzero elements in KL
		if kl(i)~=0, 	% are ones.
			kl(i)=1;
		end;
	end;	
end;


% ----------------------------------
%    CHECK THE ORIGINAL LENGTH
% ----------------------------------

[ly,lx]=size(wx);

if nargin==4,			% If the original size is not given
	tamx=0;			% then set it to 'Unknown'
	tamy=0;
end


if tamy==0,			% If the original size is 'Unknown'
	tamy=maxrsize(ly,k);	% set it to the maximum possible
	if tamy==0,
		disp('Can''t determine the original height. K might be wrong');
		return;
	end
end;
if tamx==0,
	tamx=maxrsize(lx,k);
	if tamx==0,
		disp('Can''t determine the original width. K might be wrong');
		return;
	end
end;

lox(1)=tamx;			% Now keep in two vectors the succesive
for i=1:k			% sizes of the wavelet sub-images
        lox(i+1)=floor((lox(i)+1)/2);	
end
loy(1)=tamy;
for i=1:k
        loy(i+1)=floor((loy(i)+1)/2);	
end

% -----------------------------------------------------------
%    MAKE SURE THAT THE ORIGINAL SIZE IS CORRECT, SO THAT 
%    CALLS TO 'IWT' DO NOT FILL THE SCREEN WITH WARNINGS.
%    (THAT'S, MAKE WARNINGS HERE AND ONCE)
%    THIS ALSO SAVES 'IWT' FROM MAKING REPEATED EXTRA CHECKS.
% -----------------------------------------------------------

try=0;
if lx~=sum(lox(2:k+1))+lox(k+1),	% Check the given width.
	tamx=maxrsize(lx,k);		% and arrange if possible (remember
					% that the error can be in K)
	fprintf(1,'\nThe given width is not correct. Trying default width: ');
	fprintf(1,'%u',tamx);
	if tamx==0,	
		fprintf(1,'\nNo default width found. K might be wrong\n');
		return
	end
	lox(1)=tamx; 
	for i=1:k, 
	        lox(i+1)=floor((lox(i)+1)/2);	
	end
	if lx~=sum(lox(2:k+1))+lox(k+1),	% If the default width is bad too, exit.
		fprintf(1,'\nDefault failed. K might be wrong\n');
		return
	end
	try=1;
end
if ly~=sum(loy(2:k+1))+loy(k+1),	% Check the given height.
	tamy=maxrsize(ly,k);	% and arrange if possible (remember
				% that the error can be in K)
	fprintf(1,'\nThe given height is not correct. Trying default height: ');
	fprintf(1,'%u',tamy);
	if tamy==0,	
		fprintf(1,'\nNo default height found. K might be wrong\n');
		return
	end
	loy(1)=tamy; 
	for i=1:k, 
	        loy(i+1)=floor((loy(i)+1)/2);	
	end
	if ly~=sum(loy(2:k+1))+loy(k+1),	% If the default height is bad too, exit.
		fprintf(1,'\nDefault failed. K might be wrong\n');
		return
	end
	try=1; 
end
if try==1, 
	fprintf(1,'\n(Check the result, may be wrong. If so, ckeck K)\n');
end


%------------------------------
%   SETUP ARRAYS & OFFSETS
%------------------------------

tw=wx;				% Copy the wavelet image 
py=1;				% and set up the first offsets.
px=1;

y=zeros(tamy,tamx);		% Set up reconstruction image


%------------------------------
%     START THE ALGORITHM 
%------------------------------

for ind=k:-1:1			% For every scale (downwards)

		% Get the actual wavelet subimage, composed 
		% by four wavelet bands:

	t=tw(py:py+2*loy(ind+1)-1,px:px+2*lox(ind+1)-1);  % Get the actual
	[lwy,lwx]=size(t);	

		% Let's call IWT to make the vertical inverse  
		% wavelet transform of the actual wavelet sub-image:

	if nargin>7
		tx(1:loy(ind),1:lwx)=iwt(t(:,1:lwx)',rh,rg,1,loy(ind),kl(k-ind+1),del1,del2)';
	else
		tx(1:loy(ind),1:lwx)=iwt(t(:,1:lwx)',rh,rg,1,loy(ind),kl(k-ind+1))';
	end

		% And the horizontal inverse wavelet transform:

	if nargin>7
		tx(1:loy(ind),1:lox(ind))=iwt(tx(1:loy(ind),:),rh,rg,1,lox(k-ind+1),kl(ind),del1,del2);
	else
		tx(1:loy(ind),1:lox(ind))=iwt(tx(1:loy(ind),:),rh,rg,1,lox(ind),kl(k-ind+1));
	end

	if loy(ind)<lwy		% If the reconstructed sub-image is
		py=py+1;	% larger than the expected, then increase
	end			% the offset for the next iteration.
	if lox(ind)<lwx
		px=px+1;
	end

		% Have the result of one scale. 
		% Set up the next one:

	tw(py:py+loy(ind)-1,px:px+lox(ind)-1)=tx(1:loy(ind),1:lox(ind));

end		% End loop of scales.

%------------------------------
%    END OF THE ALGORITHM 
%------------------------------


y=tw;		% The result of the last scale is the reconstructed
		% image.

y=y(py:py+tamy-1,px:px+tamx-1);	% We cut the image to the original size
				% if this was given. Also, the added  
				% 'blank' rows and columns are removed. 
