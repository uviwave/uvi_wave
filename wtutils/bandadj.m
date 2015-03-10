function wt=bandadj(wx,k,sizx,sizy)

%BANDADJ    Brights up low level subbands for viewing.
%  
%           BANDADJ(WT,K) creates a wavelet matrix W equal to WT 
%           but performs a kind of normalization over the bands 
%           independently in the range (0,1), fitting the mean value
%           of the band to 0.5, so as to give all them the same 
%           bright and when viewing. The parameter K is the number of
%           scales present in WT.
%	    For wavelet packet transform, use BANDADJ(WT,BASIS).
%
%	    BANDADJ(WT,(whatever),SIZX,SIZY) must be used when any dimension
%	    of the original signal is not a power of two. By default,
%	    these values are set the largest as possible (wavelet case)
%	    or to the size of WT (wavelet packet case).
%
%	    BANDADJ will run fine with one or two dimensional transforms.
%           The result of BANDADJ should not be used with IWT2D or IWPK2D
%           to obtain a reconstructed image, because the band amplitudes
%           are all altered.
%
%           See also:  SHOW, WT2D, IWT2D, WPK2D, IWPK2D.

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
%  Modified by: Santiago Gonzalez Sanchez
%       e-mail: Uvi_Wave@tsc.uvigo.es
%--------------------------------------------------------


wt=zeros(size(wx));
if nargin==2
	sizx=size(wx,2);
	sizy=size(wx,1);
end

if length(k)==1                 % Wavelet transform case
	if nargin==2
		sizx=maxrsize(sizx,k);
		sizy=maxrsize(sizy,k);
	end
	[t,x,y,xx,yy]=bandext(wx,k,k,0,sizx,sizy);        % Normalize the lowpass residue
	wt(y:yy,x:xx)=nrm(t);

	for i=k:-1:1                            % And the rest of the bands.
		[t,x,y,xx,yy]=bandext(wx,k,i,1,sizx,sizy);
		wt(y:yy,x:xx)=nrm(t);
		[t,x,y,xx,yy]=bandext(wx,k,i,2,sizx,sizy);
		wt(y:yy,x:xx)=nrm(t);
		[t,x,y,xx,yy]=bandext(wx,k,i,3,sizx,sizy);
		wt(y:yy,x:xx)=nrm(t);
	end
else                    % Wavelet Packet transform case
	for i=1:length(k)
		[t,x,y,xx,yy]=extband(wx,k,i,sizx,sizy);
		wt(y:yy,x:xx)=nrm(t);
	end
end



