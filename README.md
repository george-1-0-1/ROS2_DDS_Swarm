# ROS2_DDS_SWARM
An Experimental Approach on Voronoi-Based Task Allocation and Dynamic Role Reassignment in Swarm Robotics Using ROS 2 DDS and MATLAB Simulink for Real-Time Surveillance in Failure-Prone Environments (theorised)

Swarm robotics, inspired by natural systems, offers a compelling approach to managing large groups of simple robots for complex tasks, including surveillance and environmental monitoring. This study introduces a novel framework that enhances communication in swarm robotics using ROS 2 and MATLAB Simulink, focusing on Voronoi-based task allocation and dynamic role reassignment. The proposed method addresses existing challenges in real-time coordination, particularly in environments susceptible to robot failures. By implementing Voronoi partitioning, the framework ensures efficient coverage and minimal overlap in operational areas. Additionally, an adaptive mechanism dynamically reallocates roles among robots, maintaining operational continuity and robustness in failure-prone scenarios. The integration of MATLAB Simulink allows for comprehensive simulation of swarm behaviors, validating the system's performance and reliability. Experimental results demonstrate improved responsiveness and scalability, making this framework particularly suited for real-world applications where resilience is critical. The implications of this research extend to various fields requiring robust multi-robot coordination, highlighting the potential for enhanced efficiency in swarm robotic systems.

## Experimental Results

In this section, we present the performance analysis of our proposed swarm robotics framework using ROS 2 and MATLAB Simulink. The evaluation focuses on communication latency, task allocation efficiency, and system resilience in failure-prone environments. The results are visualized through communication latency graphs, Voronoi partitioning, and a system diagram depicting dynamic role reassignment.

![image](https://github.com/user-attachments/assets/3afd8a7e-8e79-412a-b1b3-a0415734d5b2)

Fig. 2.	Performance Analysis ROS1 AND ROS2 DDS

Figure 2 illustrates the communication latency for various data sizes between robots, using ROS 1 and ROS 2 with different middleware configurations. The performance of ROS 2 (OpenSplice and Connext DDS) demonstrates superior scalability and lower latency compared to ROS 1, particularly for larger data sizes. This result aligns with our expectations, as DDS-based communication in ROS 2 is optimized for low-latency, reliable data transmission across distributed systems. 

As observed, for data sizes beyond 256K bytes, ROS 2's local communication with reliable DDS settings shows a noticeable increase in latency, reaching up to 80 milliseconds at 1M byte data size. However, it maintains lower latency than ROS 1 in both remote and local communication scenarios, confirming the advantages of using DDS in real-time multi-robot coordination. 

![image](https://github.com/user-attachments/assets/38bb067b-8276-4d8c-806f-2cee6dfb3e90)

Fig. 3.	Voronoi Partition for Task Allocation

Figure 3 presents the Voronoi partitioning (eq. 1) for task allocation in the swarm, where robots are assigned distinct regions based on their positions. The Voronoi diagram dynamically updates as robots move, ensuring balanced coverage and minimizing overlap in operational areas. 

This method efficiently allocates tasks by dividing the environment into non-overlapping regions, each associated with a specific robot. The Voronoi vertices (V1, V2, ..., V19) represent the boundaries between robots' areas of influence, while the red points (X1, X2, ..., X15) denote the positions of the robots. The even distribution of robots across the operational area ensures that each robot can perform its task without interference, improving the overall efficiency of the swarm.

![image](https://github.com/user-attachments/assets/ad147dd5-64b7-4a95-bc30-d1db130d6936)

Fig. 4.	DDS Communication (rqt_graph) Graph between swarm bot position and ddr metrics

Figure 4 illustrates the dynamic role reassignment mechanism implemented in our framework. In the event of a robot failure, the system dynamically reallocates tasks and roles to operational robots. The communication between the swarm leader (/surveybot_position) and individual survey bots (e.g., /surveybot_1, /surveybot_2, ..., /surveybot_6) is maintained through the DDS middleware. When a failure is detected, the system promptly reassigns the task of the failed robot to its neighbors, as indicated by the green arrows in the diagram. The DDS metrics node continuously monitors system performance, ensuring that task continuity is maintained even during failure scenarios. The seamless role transition, coupled with low communication latency, ensures that the swarm remains operational, highlighting the robustness of the proposed system.
 
![image](https://github.com/user-attachments/assets/2626c00f-ce59-4009-b36c-38c8726f2f25)

Fig. 5.	DDS Communication Simulation

Figure 5 provides a high-level overview of the simulated environment where the robots' positions are dynamically updated. This simulation validates the Voronoi partitioning algorithm (eq. 1) by visually delineating task allocation regions. Each region is assigned to a robot, ensuring non-overlapping operational zones. The partitions adapt as the robots reposition, showcasing the effectiveness of Voronoi partitioning in maintaining balanced coverage and reducing task redundancies.

Figure 6 illustrates the dynamic role reassignment mechanism (eq. 2), particularly under robot failure scenarios. The figure shows how failed robots' tasks are redistributed among neighbouring robots with minimal disruption. 
 
![image](https://github.com/user-attachments/assets/026b5048-560d-4447-bf42-31ec5f48d52f)

Fig. 6.	Dynamic Role Reassignment

The reassignment ensures task continuity, as indicated by the high task completion rate and low response time metrics. This resilience is pivotal for real-time applications, as it allows the system to recover quickly and maintain operational efficiency.
 
![image](https://github.com/user-attachments/assets/2b4077d5-133b-4e9a-9967-5bd015b9941c)

Fig. 7.	Convergence of Gossip Protocol

Figure 7 visualizes the convergence process (eq. 4) of the gossip protocol (eq. 3) implemented within the swarm. Each robot updates its state iteratively based on neighbor interactions, and the figure highlights how state values converge over time. The rapid convergence observed across all simulations underlines the protocol's efficiency in achieving consensus. This characteristic is crucial for synchronizing swarm-wide operations, particularly in scenarios requiring collaborative decision-making.
 
![image](https://github.com/user-attachments/assets/4d767d93-fe5d-45ac-b2dd-ca38659e4e17)

Fig. 8.	Voronoi Partitioning with DDS Communication 

Figure 8 showcases the integration of DDS-enabled communication with Voronoi partitioning (eq. 1). The graph in this figure depicts communication latency (eq. 6), message delivery success rates (eq. 8), and task continuity (eq. 7) as functions of swarm size and task complexity. The results affirm that the DDS middleware effectively minimizes latency while maintaining high reliability, even under increased communication loads. Furthermore, the seamless interaction between DDS communication and Voronoi-based task allocation reinforces the framework's scalability and suitability for large-scale deployments.

Overall, the experimental results substantiate the framework's ability to address real-time coordination, robustness in failure-prone environments, and efficient task allocation. These outcomes position the proposed approach as a promising solution for advancing swarm robotics systems in applications such as surveillance, environmental monitoring, and search-and-rescue missions.

The experimental results demonstrate that the integration of MATLAB Simulink and ROS 2 enhances the scalability and fault tolerance of swarm robotics systems. The use of Voronoi partitioning ensures efficient task allocation, reducing the need for frequent communication between robots, while dynamic role reassignment ensures that the system remains resilient in failure-prone environments. Our framework's reliance on DDS middleware for communication has been shown to improve real-time coordination, with minimal packet loss and low latency, even as the swarm size increases.

The communication performance metrics (latency, message delivery success rate) and the task continuity rate observed during dynamic role reassignment highlight the effectiveness of our approach. Future work will focus on extending the system to handle more complex environmental conditions and increasing the number of robots in the swarm to further validate the framework's scalability.
