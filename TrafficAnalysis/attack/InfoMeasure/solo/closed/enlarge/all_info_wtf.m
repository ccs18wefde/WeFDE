addpath('../../../parallel_measure')
addpath('../../../ToolBox/util/')
addpath('../../../ToolBox/')
addpath('../../../../MIanalysis/');


parallel_handler(6);

% wtf 
exp_tag = {'WTF_0.9'};
world_size = {'top500', 'top1000','top2000'} 


bstrap_num = 0;

for e = 1:length(exp_tag)
    for ws = 1:length(world_size)
	wtf_combine(exp_tag{e}, world_size{ws}, bstrap_num);
    end
end
