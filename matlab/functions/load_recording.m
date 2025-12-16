function [desired_pos, actual_pos, t_sim] = load_recording(file_path)

    experimental_data = readtable(file_path);
    time_stamp = experimental_data(:,1).Var1;
    desired_pos = experimental_data(:,2).Var2;
    actual_pos = experimental_data(:,3).Var3;
    
    % Calculate cumulative time
    t_sim = cumsum(time_stamp);

    % Remove duplicate time points (caused by 0s in time_stamp)
    [t_sim, unique_idx] = unique(t_sim, 'stable');
    
    % Apply the same filter to the data vectors
    desired_pos = desired_pos(unique_idx);
    actual_pos = actual_pos(unique_idx);

end