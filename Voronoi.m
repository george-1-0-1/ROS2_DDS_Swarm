% Parameters
num_robots = 10;             % Number of robots
time_steps = 50;            % Number of time steps
field_size = 20;            % Size of the 2D field (20x20)
comm_radius = 5;            % Communication radius for each robot

% Initialize random positions for each robot in the field
robot_positions = field_size * rand(num_robots, 2);

% Set up figure
figure;
axis([0 field_size 0 field_size]);
hold on;
grid on;
title('Voronoi Partitioning with DDS Communication Between Robots');
xlabel('X Position');
ylabel('Y Position');

% Main simulation loop
for t = 1:time_steps
    cla;  % Clear the plot for each time step

    % Compute Voronoi partitioning based on robot positions
    [vx, vy] = voronoi(robot_positions(:,1), robot_positions(:,2));
    
    % Plot Voronoi diagram
    plot(vx, vy, 'k--');  % Plot Voronoi edges as dashed lines
    
    % Plot each robot and its region
    for i = 1:num_robots
        % Plot robot position
        plot(robot_positions(i,1), robot_positions(i,2), 'bo', 'MarkerSize', 8, 'DisplayName', sprintf('Robot %d', i));
        text(robot_positions(i,1) + 0.3, robot_positions(i,2), sprintf('R%d', i));

        % Randomly move the robot within a small range
        robot_positions(i,:) = robot_positions(i,:) + 0.5 * (rand(1, 2) - 0.5);

        % Ensure the robot stays within its Voronoi cell
        if robot_positions(i,1) < 0
            robot_positions(i,1) = 0;
        elseif robot_positions(i,1) > field_size
            robot_positions(i,1) = field_size;
        end
        if robot_positions(i,2) < 0
            robot_positions(i,2) = 0;
        elseif robot_positions(i,2) > field_size
            robot_positions(i,2) = field_size;
        end
    end

    % Visualize DDS communication within each Voronoi region
    for i = 1:num_robots
        for j = i+1:num_robots
            % Calculate the distance between robots i and j
            distance = norm(robot_positions(i, :) - robot_positions(j, :));
            
            % If within communication radius, draw a line representing communication
            if distance <= comm_radius
                plot([robot_positions(i,1), robot_positions(j,1)], ...
                     [robot_positions(i,2), robot_positions(j,2)], 'g--');
            end
        end
    end

    % Display the legend
    legend(sprintf('Time Step: %d', t));

    % Pause for a short period to create an animation effect
    pause(0.1);
end

hold off;
