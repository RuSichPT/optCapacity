function [H, Ch, l, b] = generate3GPPChannels(aBS,aMS,numUsers,numChan,seed)
    % aBS, aMS - антенные решетки для BS MS
    % numUsers - кол-во пользователей
    % numChan - кол-во каналов
    % seed - сид ГПСЧ
    % H - [numUsers numTx numPath numChan] numUsers = numRx
    %% Sim param
    s = qd_simulation_parameters;
    s.use_3GPP_baseline = 1;
    s.show_progress_bars = 0;
    s.center_frequency = aBS.center_frequency;
    %% Layout
    max_dist = 200;
    l = qd_layout(s);
    l.tx_array = aBS;
    l.rx_array = aMS;
    l.no_rx = numUsers;  
    
    rng(seed)
    l.randomize_rx_positions(max_dist,1.5,1.5,0);                       % Assign random user positions
    l.rx_position(1,:) = l.rx_position(1,:) + max_dist + 20;            % Place users east of the BS
    
    floor = randi(5,1,l.no_rx) + 3;                                     % Set random floor levels
    for n = 1:l.no_rx
        floor(n) = randi(floor(n));
    end
    l.rx_position(3,:) = 3*(floor-1) + 1.5;
    
    % LOSonly, Freespace, 3GPP_38.901_UMa_NLOS page 101 QuADRiGa
    indoor_rx = l.set_scenario('3GPP_38.901_UMa_NLOS',[],[],0.8);       % Set the scenario
    l.rx_position(3,~indoor_rx) = 1.5;                                  % Set outdoor-users to 1.5 m height
    rng('shuffle');
    %%
    b = l.init_builder;
    rng(seed)
    b.gen_parameters();
    rng('shuffle');
    
    H = [];
    Ch = [];
    for i = 1:numChan
        b.gen_ssf_parameters(0);
        b.gen_ssf_parameters();
        cm = get_channels(b);
        Ch = cat(1,Ch,cm);
        H = cat(4,H,getChannelsFromQuaDRiGa(cm));
        disp("created " + i);
    end
end