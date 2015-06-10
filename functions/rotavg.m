function [avg_mat,varargout] =rotavg(array)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% rotavg.m - function to compute rotational average of (square) array
% by Bruno Olshausen
% 
% function f = rotavg(array)
%
% array can be of dimensions N x N x M, in which case f is of 
% dimension NxM.  N should be even.
%
test_size=size(array);
if ~((test_size(1)==1)||(test_size(2)==1)) 
	[N N M]=size(array);
	[X Y]=meshgrid(-N/2:N/2-1,-N/2:N/2-1);
	[theta rho]=cart2pol(X,Y);
	rho=round(rho);
	i=cell(N/2+1,1);
	for r=0:N/2
	  i{r+1}=find(rho==r);
	end
	f=zeros(N/2+1,M);
	for m=1:M
	  a=array(:,:,m);
	  for r=0:N/2
	    f(r+1,m)=mean(a(i{r+1}));
	  end
	  
	end
	avg_mat=zeros(N);
	for r=0:N/2
	    avg_mat(i{r+1})=f(r+1);
	end
	varargout{1}=f;
else
	N=1024;
	array(1:511)=[];
	[X Y]=meshgrid(-N/2:N/2-1,-N/2:N/2-1);
	[theta rho]=cart2pol(X,Y);
	rho=round(rho);
	i=cell(N/2+1,1);
	for r=0:N/2
	  i{r+1}=find(rho==r);
	end
	avg_mat=zeros(N);
	for r=0:N/2
	    avg_mat(i{r+1})=array(r+1);
	end

end

