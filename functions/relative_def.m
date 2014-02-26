function [  ] = relative_def(inp,oup)
% Finds relative defocus between successive images using Phase correlation
% Depends on function pcorr(), max defocus range is 30nm, if differnce between mages is more then increase in line 12
cd ../data
load(inp)
cd ../functions
max_val(1:num)=0;
defocus(1:num)=0;

for imcount=1:num-1
    
    
    for def=1:.5:30
        pmat=pcorr(stack(imcount).raw,stack(imcount+1).raw,def,c_size);
        maxi=max(abs(pmat(:)));
        if(max_val(imcount)<maxi)
            max_val(imcount)=maxi;
            defocus(imcount)=def;
        end
    def    
    end
    imcount
end
clear stack
cd ../data
save(oup)
cd ../functions
end