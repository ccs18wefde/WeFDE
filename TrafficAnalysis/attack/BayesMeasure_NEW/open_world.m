function open_world(vec, findex)

addpath('ToolBox');

% chunk:  no chunk(0), chunk(1) 
% NO_DIRECT = 0: turn on direct measure
% NO_DIRECT = 1: turn OFF direct measure
CHUNK = 1
NO_DIRECT = 0

% parameters
bstrap_num = 10;
mcarlo_num = 5000;
reModel_krate = 0.5;

% selector:     bootstrap 1; subsampling 2
selector = 2;

reader_closed = TrainMatrixReader('dataset_open_world/monitored/no_defense/');
reader_open = TrainMatrixReader('dataset_open_world/non_monitored/0-2000/');


Tmatrix{1} = reader_closed.TrainMatrix;
label{1} = reader_closed.Label;
Tmatrix{2} = reader_open.TrainMatrix;
label{2} = reader_open.Label;

prior = PriorWebsites('Open_World_Zipf', reader_closed.Rank, reader_open.Rank);


info = EvaluatorMachine(Tmatrix, label, vec, prior);

% prepare for parallel
ent_summary = cell(bstrap_num+1,1);         % ent collector
info_list = cell(bstrap_num+1,1);           % multi-copies stored in info_list 
for i = 1:(bstrap_num+1)
    info_list{i} = info;
end

parfor j = (1+NO_DIRECT):(bstrap_num+1)
    if j ~= 1
        info_list{j}.reModel(reModel_krate, selector);
    end
    info_list{j}.GenerateSamples(mcarlo_num);
    ent_summary{j} = info_list{j}.Evaluate(0);

    if CHUNK == 1
      temp = ent_summary{j};
      parsave([findex, j], temp);
    end
%    parfor_progress;
end

% save ent_summary
pathname = strcat('debug_indiv/ent_summary_', int2str(findex), '.mat');
save(pathname, 'ent_summary');


end
