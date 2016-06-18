function [ learner_appentice_vector ] = creat_learner_experience(  )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
   appentice_matrix=zeros(4,4); 
   appentice_vector=zeros(15,1);
   learn_wall=0;
   gamma=0.9;
   count=0;
   position_x=2;
   position_y=2;
while ~((position_x==6 && position_y==6) || count>30)
   
count=count+1;
rand_action = floor(mod(rand*10,4))+1;

% action = max_index;
map_matrix(position_x,position_y)=count;

pre_position_x=position_x;
pre_position_y=position_y;

switch rand_action
     
    case 1
        position_y = pre_position_y-1;   %up
    case 2
        position_y = pre_position_y+1;  %down
    case 3
        position_x = pre_position_x-1;  %left
    case 4
        position_x = pre_position_x+1;  %right
    
end

    if(position_x==0 || position_x==7 || position_y==0 || position_y==7)
        learn_wall = learn_wall + power(gamma,count);
        position_x = pre_position_x;
        position_y = pre_position_y;
       
   
    else
        %appentice_matrix(position_x-1,position_y-1)=appentice_matrix(position_x-1,position_y-1)+power(gamma,count);
        appentice_vector=appentice_vector+encoder(position_x,position_y)*power(gamma,count);
    end   
    
 
  disp(['position_x: ' num2str(position_x) ' position_y: ' num2str(position_y)]);
 %disp(['count: ' num2str(count)]);   

end
learner_appentice_vector=appentice_vector;
learner_appentice_vector=[learner_appentice_vector;learn_wall];
end

