# Checking whether opencv has been downloaded
if [[ ! -f "opencv.zip" ]]
then
   wget -O opencv.zip https://github.com/opencv/opencv/archive/4.2.0.zip
fi

# Checking whether opencv_contrib has been downloaded
if [[ ! -f "opencv_contrib.zip" ]]
then
   wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.2.0.zip
fi

# Checking whether yolov4 weights have been downloaded
if [[ ! -f "yolov4.weights" ]]
then
   echo "Please download yolov4 weights from https://drive.google.com/open?id=1cewMfusmPjYWbrnuJRuKhPMwRe_b9PaT"
fi

if [ -d "darknet" ]
then
   cd darknet
   git stash
   git fetch --all
   git reset --hard origin/master
   cd ..
else 
   git clone git@github.com:AlexeyAB/darknet.git darknet
fi

cp commands.txt ./darknet/commands.txt 

if [[ -f "yolov4.weights" ]]
then
   cp yolov4.weights ./darknet/yolov4.weights 
fi

cp Makefile ./darknet/Makefile
echo "Done."
echo "Docker build started..."
NAME=$USER:darknet-$(date +'%Y-%m-%d')
docker build . -t $NAME
docker save -o $NAME.tar $NAME
echo "Docker build created successfully."