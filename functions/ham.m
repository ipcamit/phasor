function [ham_img] = ham(img)
%Ham: takes a "double" image as an input and returns a hammed image
%hamming is done using sin function
[m,n]=size(img);

for count=1:m
    if count < 0.2*m
        img(count,:)=img(count,:).* sin((count-1)* (pi/(.4*m)));
    elseif count>0.75*m
        img(count,:)=img(count,:).* sin(pi/2 + (count-1)* (pi/(.4*m)));
    end
end
for count=1:n
    if count < 0.2*n
        img(:,count)=img(:,count).* sin((count-1)* (pi/(.4*n)));
    elseif count>0.75*n
        img(:,count)=img(:,count).* sin(pi/2 + (count-1)* (pi/(.4*n)));
    end
end
ham_img=img;
end
