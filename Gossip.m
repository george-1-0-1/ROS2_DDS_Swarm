% Parameters
num_robots = 10;        % Number of robots
iterations = 100;       % Number of gossip iterations
alpha = 0.5;            % Step size

% Initial states for each robot
x = rand(1, num_robots);    % Random initial states between 0 and 1
x_history = zeros(iterations, num_robots);  % To store states over time
x_history(1, :) = x;

% Gossip protocol iterations
for t = 2:iterations
    % Select a random pair of robots for each iteration
    i = randi(num_robots);
    j = randi(num_robots);
    
    % Update states according to the gossip protocol
    if i ~= j
        x(i) = x(i) + alpha * (x(j) - x(i));
        x(j) = x(j) + alpha * (x(i) - x(j));
    end
    
    % Store the updated states in the history for plotting
    x_history(t, :) = x;
end

% Plot the convergence of states over time
figure;
plot(1:iterations, x_history);
xlabel('Iterations');
ylabel('State Value');
title('Convergence of Robot States with Gossip Protocol');
legend('Robot 1', 'Robot 2', 'Robot 3', 'Robot 4', 'Robot 5', 'Robot 6', 'Robot 7', 'Robot 8', 'Robot 9', 'Robot 10');
grid on;
