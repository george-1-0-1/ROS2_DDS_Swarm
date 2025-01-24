clc;
clear;
close all;

% Define the number of bots and the area
numBots = 6;                       % Number of robots
areaSize = 10;                     % Size of the square area
initialPosition = [5, 5];          % Initial position for all bots
targetPositions = rand(numBots, 2) * areaSize;  % Random target locations
timeStep = 0.1;                    % Time step for simulation
totalTime = 20;                    % Total simulation time
botSpeed = 0.2;                    % Speed of the bots
surveillanceRadius = 0.5;          % Radius for circular surveillance movement
surveillanceStep = 0.1;            % Step size for surveillance movement

% Initialize bot positions with a slight random perturbation
botPositions = repmat(initialPosition, numBots, 1) + rand(numBots, 2) * 0.01;
reachedTargets = false(numBots, 1);  % Flags for bots reaching their targets
theta = zeros(numBots, 1);           % Angles for surveillance movement

% Plot the environment
figure;
hold on;
xlim([0, areaSize]);
ylim([0, areaSize]);
grid on;
title('Voronoi Partitioning and DDS Communication');
xlabel('X-axis');
ylabel('Y-axis');

% Main Simulation Loop
for t = 0:timeStep:totalTime
    clf;  % Clear the figure for real-time updates
    
    % Plot the environment settings
    hold on;
    xlim([0, areaSize]);
    ylim([0, areaSize]);
    grid on;
    title(sprintf('Swarm Simulation with DDS Communication (Time: %.1f)', t));
    xlabel('X-axis');
    ylabel('Y-axis');
    
    % Check for unique positions before computing Voronoi
    [uniquePositions, ia] = unique(botPositions, 'rows');
    if size(uniquePositions, 1) >= 3 && ~all(reachedTargets)
        % Compute Voronoi partitions
        [vx, vy] = voronoi(uniquePositions(:, 1), uniquePositions(:, 2));
        plot(vx, vy, 'k-', 'LineWidth', 1);  % Plot Voronoi diagram
    elseif all(reachedTargets)
        title('Surveillance Phase: Voronoi Partition Finalized');
    end
    
    % Plot target positions
    scatter(targetPositions(:,1), targetPositions(:,2), 100, 'rx', 'LineWidth', 1.5, 'DisplayName', 'Target Positions');
    
    % Move each bot towards its target position
    for i = 1:numBots
        if ~reachedTargets(i)
            % Calculate direction to the target
            direction = targetPositions(i, :) - botPositions(i, :);
            if norm(direction) > 0.1  % Check if the bot is near its target
                botPositions(i, :) = botPositions(i, :) + direction / norm(direction) * botSpeed;  % Update position
            else
                reachedTargets(i) = true;  % Mark as reached
            end
        else
            % Surveillance movement (circle around target)
            theta(i) = theta(i) + surveillanceStep;
            botPositions(i, :) = targetPositions(i, :) + surveillanceRadius * [cos(theta(i)), sin(theta(i))];
        end
        
        % Plot bot position
        scatter(botPositions(i, 1), botPositions(i, 2), 50, 'bo', 'filled', 'DisplayName', ['Bot ', num2str(i)]);
        text(botPositions(i, 1), botPositions(i, 2), sprintf('B%d', i), 'HorizontalAlignment', 'right');
        
        % DDS Communication Simulation
        line([botPositions(i, 1), areaSize/2], [botPositions(i, 2), areaSize/2], 'Color', 'g', 'LineStyle', '--', 'LineWidth', 1.5);
    end
    
    % Simulate DDS communication in the console
    fprintf('Time: %.1f\n', t);
    for i = 1:numBots
        fprintf('Bot %d Position: (%.2f, %.2f)\n', i, botPositions(i, 1), botPositions(i, 2));
    end
    fprintf('\n');
    
    % Stop simulation if all bots are in surveillance mode
    if all(reachedTargets)
        disp('All bots have reached their target locations. Transitioning to surveillance phase.');
    end
    
    % Update the plot
    legend('show');
    drawnow;
    
    % Pause for visualization
    pause(timeStep);
end

disp('Simulation Complete!');
