  ssh-keygen -t ed25519 -C "gitlab"
  cat /home/ubuntu/.ssh/id_ed25519
  ls
  locale  # check for UTF-8
  sudo apt update && sudo apt install locales
  sudo locale-gen en_US en_US.UTF-8
  sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
  export LANG=en_US.UTF-8
  locale  # verify settings
  sudo apt update && sudo apt install curl gnupg2 lsb-release
  sudo apt update && sudo apt install curl gnupg2 lsb-release -y
  sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key  -o /usr/share/keyrings/ros-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
  sudo apt update
  sudo apt install ros-foxy-desktop
  sudo apt update
  sudo apt upgrade
  sudo apt update
  sudo apt install ros-foxy-desktop
  source /opt/ros/foxy/setup.bash
  ros2 run demo_nodes_cpp talker
  sudo apt install python3-rosdep
  sudo apt install python3-rosdep -y
  sudo rosdep init
  rosdep update
  sudo apt update
  sudo apt install -y wget
  sudo sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
  wget https://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -
  sudo apt update && sudo apt install   git cmake python3-vcstool curl   qt5-default   python3-shapely python3-yaml python3-requests   -y
  sudo apt-get install python3-colcon*
  cat /home/ubuntu/.ssh/id_ed25519.pub
  mkdir -p ~/rmf_demos_ws/src
  cd ~/rmf_demos_ws
  curl --header "PRIVATE-TOKEN: 8Zw4Efdbp-EWJCrMkEer" "https://gitlab.com/api/v4/projects/24095027/repository/files/vama_demo%2erepos/raw?ref=vama_rmf" -o vama_demo.repos
  vcs import src < vama_demo.repos
  cd ~/rmf_demos_ws
  rosdep install --from-paths src --ignore-src --rosdistro foxy -yr
  cd ~/rmf_demos_ws
  source /opt/ros/foxy/setup.bash
  source ~/rmf_demos_ws/install/setup.bash
  colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release --packages-ignore su_obstacle_manager su_manager