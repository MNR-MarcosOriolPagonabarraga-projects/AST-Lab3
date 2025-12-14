function [desired_pos, actual_pos, t_sim] = load_recording(file_path)

    experimental_data = readtable(file_path);
    time_stamp = experimental_data(:,1).Var1;
    desired_pos = experimental_data(:,2).Var2;
    actual_pos = experimental_data(:,3).Var3;
    t_sim = cumsum(time_stamp);

end