function f = f_get_polyFunc_from_array(x_array, y_array, piece_num, mini_per_len, degree)
%F_GET_PDF_FROM_CDF 此处显示有关此函数的摘要
%   此处显示详细说明
format long
syms x
% explion = (x_array(2)-x_array(1))/1e3;
dif_array = diff(y_array);
temp1 = find(dif_array>0);
temp2 = find(dif_array<0);
if isempty(temp1) || isempty(temp2) % 说明这是单调函数,可以开始polyfit (如果两个都是空的，说明是直线）
    total_len = length(x_array);
    piece_num_local = piece_num;
    piece_num_temp = floor(total_len/mini_per_len);
    if piece_num_temp <= piece_num_local
        piece_num_local = piece_num_temp;
    end
%     
%     per_len_local = per_len;
%     piece_num = floor(total_len/per_len_local);
    if piece_num_local == 0
        piece_num_local = 1;
        per_len_local = total_len;
    else
        per_len_local = floor(total_len/piece_num_local);
    end
%     piece_num_local
    %     if rem(total_len,per_len) > ceil(per_len/2)
    %         piece_num = piece_num + 1;
    %     end
    x_cell = cell(1,piece_num_local);
    y_cell = cell(1,piece_num_local);
    x_point = 1;
    
    f_poly_cell = cell(1,piece_num_local);
    f_cell = num2cell(zeros(1,piece_num_local)); % 定义一个全0的cell
    %     f_mat_func_cell = cell(1,piece_num);
    exp_str = '0';
    for i = 1:piece_num_local
        start_idx = x_point;
        if i ~= piece_num_local
            end_idx = start_idx+per_len_local;
        else
            end_idx = length(x_array);
        end
        x_cell{i} = x_array(start_idx:end_idx);
        y_cell{i} = y_array(start_idx:end_idx);
        
        f_poly_cell{i} = polyfit(x_cell{i},y_cell{i},degree);
        for j = 1:degree+1
            f_cell{i} = f_cell{i} + f_poly_cell{i}(j)*(x)^(degree+1-j);
        end
        if i == 1
%             exp_str = [exp_str,'+ ((x>x_array(',num2str(start_idx),')|abs(x-x_array(',num2str(start_idx),'))<=',num2str(explion),')', ...
%                 ' & (x<x_array(',num2str(end_idx),')|abs(x-x_array(',num2str(end_idx),'))<=',num2str(explion),')', ...
%                 ').*f_cell{',num2str(i),'}'];
            exp_str = [exp_str,'+ (x>=x_array(',num2str(start_idx),') & x<=x_array(',num2str(end_idx),')).*f_cell{',num2str(i),'}'];
        else
            exp_str = [exp_str,'+ (x>x_array(',num2str(start_idx),') & x<=x_array(',num2str(end_idx),')).*f_cell{',num2str(i),'}'];
        end

        %         f_mat_func_cell{i} = matlabFunction(f_cell{i});
        %     plot(x2_cell{i},f2_mat_func_cell{i}(x2_cell{i}),'r:');
        % %         if i == 1
        % %             exp_str = [exp_str,'+ ((x>x_array(',num2str(x_point),')|abs(x-x_array(',num2str(x_point),'))<=',num2str(explion),')', ...
        % %                 ' & (x<x_array(',num2str(x_point+per_len_local),')|abs(x-x_array(',num2str(x_point+per_len_local),'))<=',num2str(explion),')', ...
        % %                 ').*f_cell{',num2str(i),'}'];
        % %         elseif i ~= piece_num
        % %             exp_str = [exp_str,'+ (x>x_array(',num2str(x_point),')', ...
        % %                 ' & (x<x_array(',num2str(x_point+per_len_local),')|abs(x-x_array(',num2str(x_point+per_len_local),'))<=',num2str(explion),')', ...
        % %                 ').*f_cell{',num2str(i),'}'];
        % %         else
        % %             exp_str = [exp_str,'+ (x>x_array(',num2str(x_point),')', ...
        % %                 ' & (x<x_array(end)|abs(x-x_array(end))<=',num2str(explion),')', ...
        % %                 ').*f_cell{',num2str(i),'}'];
        % % %             exp_str = [exp_str,'+ (x>=x_array(',num2str(x_point),') ', ...
        % % %                 '& x<=x_array(end)).*f_cell{',num2str(i),'}'];
        % %         end
        
        x_point = end_idx;
    end
    f = eval(exp_str);
    
else % 非单调函数，需要再划分
    if temp1(1) < temp2(1)
        div_point = temp2(1);
    elseif temp1(1) > temp2(1)
        div_point = temp1(1);
    end
    x1_array = x_array(1:div_point);
    y1_array = y_array(1:div_point);
    f1 = f_get_polyFunc_from_array(x1_array, y1_array, piece_num, mini_per_len, degree);
    x2_array = x_array(div_point:end);
    y2_array = y_array(div_point:end);
    f2 = f_get_polyFunc_from_array(x2_array, y2_array, piece_num, mini_per_len, degree);
    f = (x>=x_array(1) & x<=x_array(div_point)).*f1+(x>x_array(div_point) & x <= x_array(end)).*f2;
end

end

