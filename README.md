# Project Title: Real-Time 3D Reconstruction in VR

## Overview

Welcome to our project repository! Our goal is to transform raw mono camera data captured by a TurtleBot 4 robot into a fully immersive virtual reality (VR) experience. This project combines hardware, software, and advanced algorithms to create an engaging and interactive virtual world. By leveraging ROS2 for communication, ORB-SLAM3 for real-time 3D reconstruction, and Unity for VR development, our pipeline addresses challenges prevalent in industries where physical presence is often impractical.

## Project Features

- **Mono Camera Data Transformation:** The TurtleBot 4, equipped with a mono camera, captures and processes real-time RGB images.

- **ROS2 Communication:** Utilizing ROS2 for seamless communication between the robot's components, we ensure efficient data flow and control.

- **Real-time 3D Reconstruction:** ORB-SLAM3 is employed for real-time 3D reconstruction of the environment, enhancing the robot's spatial awareness.

- **Unity VR Development:** The pipeline integrates with Unity to provide a fully immersive VR experience for users.

- **Remote Interaction:** Empowers remote users to interact with a real 3D environment, catering to industries where physical presence is challenging.

## Getting Started

1. **Requirements:**
   - TurtleBot 4 with a mono camera
   - ROS2 installation
   - ORB-SLAM3
   - Unity for VR development

2. **Installation:**
   - Clone this repository .
   - Follow setup instructions in the respective ROS, ORB-SLAM3, and Unity documentation.

3. **Usage:**
   - Launch the ROS nodes on the TurtleBot: `roslaunch turtlebot_launch turtlebot_launch_file.launch`
   - Run ORB-SLAM3 for 3D reconstruction.
   - Start Unity VR application for immersive experience.

## Workflow

1. The TurtleBot navigates its environment using SLAM techniques, capturing RGB images with the mono camera.

2. Data is transmitted over Wi-Fi to an external machine through the ROS stack.

3. The external machine performs 3D reconstruction using ORB-SLAM3.

4. Visualize the reconstructed scene in Unity, completing the minimum pipeline.

## Demo Video

Check out our demo video on [YouTube](https://www.youtube.com/embed/-YZ9yIsT3aU) to see the project in action!

## Contributions and Issues

We welcome contributions and feedback! If you encounter any issues or have suggestions for improvement, please open an issue on GitHub.

Thank you for exploring our project! Happy coding! 🚀
