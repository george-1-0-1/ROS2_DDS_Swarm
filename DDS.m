% Parameters
num_robots = 20;          % Number of robots
time_steps = 100;         % Number of time steps
comm_radius = 5         % Communication radius for each robot (e.g., 5 units)

% Initialize random positions for each robot in a 20x20 grid
robot_positions = 20 * rand(num_robots, 2);
robot_velocities = 0.5 * (rand(num_robots, 2) - 0.5);  % Random small velocities for each robot

% Set up figure
figure;
hold on;
axis([0 20 0 20]);
grid on;
title('DDS Communication Simulation Between Robots');
xlabel('X Position');
ylabel('Y Position');

% Main simulation loop
for t = 1:time_steps
    cla;  % Clear the plot for each time step
    
    % Update robot positions
    robot_positions = robot_positions + robot_velocities;

    % Plot each robot
    for i = 1:num_robots
        plot(robot_positions(i,1), robot_positions(i,2), 'bo', 'MarkerSize', 8, 'DisplayName', sprintf('Robot %d', i));
        text(robot_positions(i,1) + 0.3, robot_positions(i,2), sprintf('R%d', i));
    end
    
    % Visualize DDS communication (line between robots within comm_radius)
    for i = 1:num_robots
        for j = i+1:num_robots
            % Calculate the distance between robots i and j
            distance = norm(robot_positions(i, :) - robot_positions(j, :));
            
            % If within communication radius, draw a line representing communication
            if distance <= comm_radius
                % Line represents DDS communication link
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
