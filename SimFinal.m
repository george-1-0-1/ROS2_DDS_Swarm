% Swarm Robotics Simulation with ROS 2 and Voronoi Partition
clc; clear; close all;

% Parameters
numBots = 10;                  % Number of robots
workspaceSize = [0 10 0 10];   % Simulation workspace bounds
goalPositions = rand(numBots, 2) * 10; % Random goal locations
botPositions = repmat([5, 5], numBots, 1); % Start near center
failureBot = 5;                % Bot that "fails" during simulation

% Initialize ROS 2 Node
ros2Node = ros2node("/swarm_node"); % ROS 2 node creation

% Define publishers and subscribers
pubs = cell(numBots, 1); % Publishers
subs = cell(numBots, 1); % Subscribers
for i = 1:numBots
    pubs{i} = ros2publisher(ros2Node, "/bot" + string(i) + "/status", "std_msgs/String"); % Publisher for status
    subs{i} = ros2subscriber(ros2Node, "/bot" + string(i) + "/task", "std_msgs/String", @taskCallback); % Subscriber for task
end


% Main Simulation Loop
timeStep = 0.1;                % Time step in seconds
maxTime = 100;                 % Simulation time in seconds
t = 0:timeStep:maxTime;
latencyData = zeros(length(t), 1);
throughputData = zeros(length(t), 1);

% Voronoi Partition Plot
figure;
hold on;
xlim(workspaceSize(1:2));
ylim(workspaceSize(3:4));
voronoiPlot = plot(voronoi(botPositions(:, 1), botPositions(:, 2)), 'k-');

while t < maxTime
    % Simulate Bot Movement
    for i = 1:numBots
        if i == failureBot && t > maxTime/2 % Simulate failure
            botPositions(i, :) = NaN; % Mark as failed
            continue;
        end
        
        % Move toward goal
        goalVec = goalPositions(i, :) - botPositions(i, :);
        botPositions(i, :) = botPositions(i, :) + 0.1 * goalVec / norm(goalVec);
    end
    
    % Update Voronoi Partition
    voronoi(botPositions(:, 1), botPositions(:, 2));
    title("Voronoi Partition with Bot Movement");

    % Role Reassignment
    if isnan(botPositions(failureBot, 1))
        % Find the nearest bot to failureBot's goal
        distances = vecnorm(botPositions - goalPositions(failureBot, :), 2, 2);
        [~, newBot] = min(distances);
        if newBot ~= failureBot
            disp("Reassigning goal " + failureBot + " to bot " + newBot);
            goalPositions(newBot, :) = goalPositions(failureBot, :);
        end
    end
    
    % Simulate ROS 2 Communication
    for i = 1:numBots
        if isnan(botPositions(i, 1)), continue; end
        msg = ros2message("std_msgs/String");
        msg.data = "Bot " + string(i) + " position: " + mat2str(botPositions(i, :));
        send(pubs{i}, msg);
    end
    
    % Measure Latency and Throughput
    latencyData(round(t / timeStep) + 1) = rand * 10; % Simulated latency (ms)
    throughputData(round(t / timeStep) + 1) = rand * 100; % Simulated throughput (kbps)
    
    pause(0.1); % Slow simulation for visualization
end

% Final Static Voronoi Partition
voronoi(botPositions(:, 1), botPositions(:, 2));
title("Final Static Voronoi Partition");

% Plot Latency and Throughput
figure;
subplot(2, 1, 1);
plot(t, latencyData);
title('Latency over Time');
xlabel('Time (s)');
ylabel('Latency (ms)');
grid on;

subplot(2, 1, 2);
plot(t, throughputData);
title('Throughput over Time');
xlabel('Time (s)');
ylabel('Throughput (kbps)');
grid on;

% QoS Plot
figure;
bar(categorical({'Bot 1', 'Bot 2', 'Bot 3', '...'}), rand(1, numBots) * 100);
title('QoS Metrics per Bot');
ylabel('QoS (%)');
grid on;

% Task Allocation Visualization
disp("Simulation Complete. Check graphs for insights.");

% Callback Function for Task Handling
function taskCallback(~, msg)
    disp("Received task: " + msg.data);
end
