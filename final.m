clc;
clear;
close all;

% Define the number of bots and the area
numBots = 10;                      % Number of robots
areaSize = 15;                     % Size of the square area
initialPosition = [7.5, 7.5];      % Initial position for all bots
targetPositions = rand(numBots, 2) * areaSize;  % Random target locations
timeStep = 0.1;                    % Time step for simulation
botSpeed = 0.3;                    % Speed of the bots
surveillanceRadius = 0.5;          % Radius for circular surveillance movement
surveillanceStep = 0.1;            % Step size for surveillance movement

% Initialize bot positions with a slight random perturbation
botPositions = repmat(initialPosition, numBots, 1) + rand(numBots, 2) * 0.01;
reachedTargets = false(numBots, 1);  % Flags for bots reaching their targets
theta = zeros(numBots, 1);           % Angles for surveillance movement

% Create the figure for visualization
figure;
hold on;
xlim([0, areaSize]);
ylim([0, areaSize]);
grid on;
title('Voronoi Partitioning and DDS Communication');
xlabel('X-axis');
ylabel('Y-axis');

% Main Simulation Loop
while true
    clf;  % Clear the figure for real-time updates
    
    % Plot the environment settings
    hold on;
    xlim([0, areaSize]);
    ylim([0, areaSize]);
    grid on;
    title('Swarm Simulation with Voronoi Partitioning and DDS Communication');
    xlabel('X-axis');
    ylabel('Y-axis');
    
    % Compute Voronoi partitions (always visible)
    [uniquePositions, ia] = unique(botPositions, 'rows');
    if size(uniquePositions, 1) >= 3
        [vx, vy] = voronoi(uniquePositions(:, 1), uniquePositions(:, 2));
        plot(vx, vy, 'k-', 'LineWidth', 1);  % Plot Voronoi diagram
    end
    
    % Plot target positions
    scatter(targetPositions(:, 1), targetPositions(:, 2), 100, 'rx', 'LineWidth', 1.5, 'DisplayName', 'Target Positions');
    
    % Move each bot towards its target position or perform surveillance
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
    end
    
    % Simulate DDS Communication (peer-to-peer)
    for i = 1:numBots
        for j = i+1:numBots
            line([botPositions(i, 1), botPositions(j, 1)], ...
                 [botPositions(i, 2), botPositions(j, 2)], ...
                 'Color', 'g', 'LineStyle', '--', 'LineWidth', 0.8);
        end
    end
    
    % Simulate DDS messages in the console
    fprintf('Time Step Update\n');
    for i = 1:numBots
        fprintf('Bot %d Position: (%.2f, %.2f)\n', i, botPositions(i, 1), botPositions(i, 2));
    end
    fprintf('\n');
    
    % Update the plot
    legend('show');
    drawnow;
    
    % Exit condition: All bots in surveillance mode
    if all(reachedTargets)
        disp('All bots have reached their target locations and are in surveillance mode.');
        pause(5);  % Pause to observe final state
        break;
    end
end

disp('Simulation Complete!');
