function [g,rg]=calhpf(h,rh)

% CALHPF   Obtain high pass analysis and synthesis filters 
%          in a biortoghonal filterbank.
%
%          [G,RG]=CALHPF(H,RH) Calculate highpass analysis 
%          and synthesis filters in a biortoghonal scheme, using 
%          their relation to lowpass synthesis and analysis filters.
%
%          The function returns the analysis filter in G, and 
%          the synthesis filter in RG.
%
%          Only for real FIR filters.
%         
%          The relations between the filters are the following:
%
%          Grev[n]=(-1)^(n+1)*RH[-n+1];
%          G=Grev(length(Grev):-1:1); 
%
%          RG[n]=(-1)^(n+1)*Hrev[-n+1];
%          Hrev=H[length(H):-1:1];
%
%          See also: CHSIGN, SPLINE

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
%       Author: Nuria Gonzalez Prelcic
%       e-mail: Uvi_Wave@tsc.uvigo.es
%--------------------------------------------------------

lrh=length(rh);    

if (rem(lrh,2))   % rh has odd length 
   nrh=(lrh-1)/2; % Support [-nrh,nrh]            
else              % rh has even length
   nrh=lrh/2-1;     % Support [-nrh,nrh+1]
end 


if (rem(nrh,2))   % nrh is odd
   flag=1;
else              % nrh is even 
   flag=0;
end 

grev=chsign(rh(lrh:-1:1),flag);
g=grev(lrh:-1:1);


lh=length(h);

if (rem(lh,2))   % h has odd length 
   nh=(lh-1)/2; % Support [-nh,nh]
else              % h has even length
   nh=lh/2-1;     % Support [-nh,nh+1]
end

if (rem(nh,2))% nh is odd
      flag=1;
else
      flag=0;     % nh is even  
end

rg=chsign(h,flag);
