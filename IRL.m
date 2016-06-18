%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Project <Deep Inverse Reinforcement Learning>
% Motive  : Using autoencoder and IRL to guess what people want to do
% Date    : 2016/04/26
% Author  : Kun Da Lin
% Comments: Language: Matlab. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
qtable = zeros(6,6,4);
%Q(state,x1)=  oldQ + alpha * (R(state,x1)+ (gamma * MaxQ(x1)) - oldQ);
round = 0;
count=0;
Error=0;
%% IRL initialization
gamma=0.9;
%expert_vector = [0   ,0   ,0   ,0  ,0.9 ,0   ,0   ,0   ,0.81,0.73,0.66,0.59,0   ,0   ,0   ,0.53 ]';
%expert_vector = [0   ;0.9   ;0.81   ;0  ;0 ;0   ;0.73   ;0   ;0;0;0.66;0;0;0   ;0.59;0.53 ;0];
[ expert_vector ,expert_map_matrix]= creat_expert_experience;
%16*1 encoder
%expert_vector =[1.43144100000000;1.46610000000000;2.12949000000000;1.49049000000000;1.34144100000000;4.21703100000000;0;2.28510000000000;1.43144100000000;0;1.43144100000000;0;0.900000000000000;0.900000000000000;1.99754100000000;0];
%expert_vector = reshape(expert_vector,4,4);
%expert_vector = reshape(expert_vector,16,1);
%old_appentice_vector=[2.32922790000000,1.71000000000000,0,0,1.08656721000000,0,0,0,1.34513447420579,0.184431473499924,0,0,2.05908730571244,0.136100486840685,0.0297259979155518,0.0119725151825620]' 
%old_appentice_vector=[2.34020511000000;1.29172108509000;1.57103579273626;0;1.53900000000000;0.656100000000000;0.617167109990127;0;0;0;0;0;0;0;0;0];
%old_appentice_vector=[0.550021537767442;0.766045549250938;0.0984770902183612;0;1.46960694773976;0.661292096327609;0;0;1.77190821000000;2.17044984909132;0;0;0;0.841402018885184;0;0;0.246885117967228];
%old_appentice_vector=[0.550021537767442;0.766045549250938;0.0984770902183612;0;1.46960694773976;0.661292096327609;0;0;1.77190821000000;2.17044984909132;0;0;0;0.841402018885184;0;0;3];
[ old_appentice_vector ] = creat_learner_experience;
w=expert_vector-old_appentice_vector;
[ reward_matrix ] = get_reward_matrix( w );
wall_reward=w(end);
%initial F,a
F=ones(16,1)*0.9;
a=0.1;

while round<150
% map_matrix = [1,1,1,1,1,1;
%               1,0,0,0,0,1;
%               1,0,0,0,0,1;
%               1,0,0,0,0,1;
%               1,0,0,0,0,1;
%               1,1,1,1,1,1];
map_matrix=zeros(6,6);
  %qtable = zeros(6,6,4);        
% expert_matrix = [ 1,1   ,1   ,1   ,1   ,1;
%                   1,0   ,0   ,0   ,0   ,1;
%                   1,0.9 ,0   ,0   ,0   ,1;
%                   1,0.81,0.73,0.66,0.59,1;
%                   1,0   ,0   ,0   ,0.53,1;
%                   1,1   ,1   ,1   ,1   ,1];


 
 %%  IRL:After failed ,compare learn_appentice_vector and expert_vector then caculate new reward function
 
        if(count~=0)
        learn_appentice_vector=appentice_vector;
        learn_appentice_vector=[learn_appentice_vector;learn_wall];
        
        delta_mu=expert_vector-learn_appentice_vector;
        Error=sum(abs(delta_mu));
        w= w+F.*delta_mu;
            for i=1:16
                if(expert_vector(i,1)==learn_appentice_vector(i,1))
                    F=F*(1-a);
                else
                    F=F+(1-F)*a;
                end
            end

        [ reward_matrix ] = get_reward_matrix( w );
        wall_reward=w(end);
        
        appentice_vector=zeros(15,1);
        learn_wall=0;
        
        else
            
           learn_wall=0;
           appentice_vector=zeros(15,1);
        end 
  
round=round+1;
position_x=1;
position_y=1;
count=0;
frame=0;
%% after obtain the new reward function , throw into RL again then obtain new policy
    
while ~((position_x==6 && position_y==6) || count>50)
    aph=0.7;
	b=0.8;


count=count+1;
rand_action = floor(mod(rand*10,4))+1;
rand_number=rand;
[max_q, max_index] = max([qtable(position_x,position_y,1) qtable(position_x,position_y,2) qtable(position_x,position_y,3) qtable(position_x,position_y,4)]);

if(qtable(position_x,position_y,rand_action)>=qtable(position_x,position_y,max_index))
    action = rand_action;
else
    action = max_index;
end
% show picture    
    frame=frame+1;
    matrix=produce_state_picture( position_x,position_y );
    I=reshape(matrix,30,30);
    imshow(I);
    imshow(I,[]); 
    imshow(I,'InitialMagnification','fit');
    Map(frame)=getframe;

% %epsilon=1-1/(1+exp(-round));
% epsilon=1-round/50;
% 
% if(rand_number<epsilon)
%     action = rand_action;
% else
%     action = max_index;
% end


% action = max_index;
map_matrix(position_x,position_y)=count;

pre_position_x=position_x;
pre_position_y=position_y;

switch action
     
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
        reward=wall_reward;
        b=0;
        %disp('wall');
  
    
    elseif(position_x==6 && position_y==6)
        % show picture         
        matrix=produce_state_picture( position_x,position_y );
        I=reshape(matrix,30,30);
        imshow(I);
        imshow(I,[]); 
        imshow(I,'InitialMagnification','fit');
        Map(frame)=getframe;
        
        appentice_vector=appentice_vector+encoder(position_x,position_y)*power(gamma,count);
        reward=reward_matrix(position_x,position_y);
        b=0;
    else
        appentice_vector=appentice_vector+encoder(position_x,position_y)*power(gamma,count);
        %appentice_matrix(position_x-1,position_y-1)=appentice_matrix(position_x-1,position_y-1)+power(gamma,count);
        reward=reward_matrix(position_x,position_y);
    end  
    
    
  [max_qtable, max_qtable_index] = max([qtable(position_x,position_y,1) qtable(position_x,position_y,2) qtable(position_x,position_y,3) qtable(position_x,position_y,4)]);
  %disp(['position_x: ' num2str(position_x) ' position_y: ' num2str(position_y)]);
  %disp(['count: ' num2str(count)]);
 

   old_q=qtable(pre_position_x,pre_position_y,action);
   new_q=old_q+aph*(reward+b*max_qtable-old_q);
   qtable(pre_position_x,pre_position_y,action)=new_q;
   
   %disp('map');
   %disp(map_matrix);
   
   
end


  disp(['round: ' num2str(round) ' count: ' num2str(count)]);
  disp(['Error: ' num2str(Error) ]);
  save_error(round,:)=Error;
  save_data(round,:)=count;
  %  if(round==20)  
% disp(['round: ' num2str(round) ' count: ' num2str(count)]);
%  end
   %disp('qtable');
   %disp(qtable);

    
end
 figure(1);
 plot(save_data);
 title('Learning');
 xlabel('episode');
 ylabel('step');
 
 figure(2);
 flip_reward_matrix=permute(reward_matrix,[2 1 3]);
 surf(flip_reward_matrix);
 title('Reward function');
 xlabel('x');
 ylabel('y');
 zlabel('reward');
 
 figure(3); 
 plot(save_error(2:end,1));
 title('Error');
 xlabel('episode');
 ylabel('Ue-Ui');
 
 disp('expert:');
 disp(expert_map_matrix);
 disp('learner:');
 disp(map_matrix);
 
 
 
 