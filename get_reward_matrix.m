function [ reward_matrix ] = get_reward_matrix( w )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%w=[-0.443962361899460;-4.01425270287066;-0.921027797817580;-4.95312992910000;-2.97174202878589;-4.72735174084071;-2.25430214201363;-6.36284821194240;-0.611338339794940;0;-1.42073417889612;-0.438443106884234;-1.02949972721149;-1.67272791021482;-1.91657683767107];
    for i = 1:6
        for j=1:6            
            reward_matrix(i,j)=(encoder(i,j)'*w(1:15))/sum(encoder(i,j));
        end
    end

end

