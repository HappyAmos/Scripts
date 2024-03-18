echo Compile and flash firmware to F0
echo ./fbt flash_usb_full
echo
echo Build fap for F0
echo ./fbt fap_[flipper_app]
echo 
echo COMPILE ISTRUCTIONS:
echo 
echo Clean the code and remove old binaries/compilation artefact 
echo ./fbt -c fap_test_app
echo Compile FAP
echo ./fbt fap_test_app
echo Run application directly inside the Flip.x0
echo ./fbt launch_app APPSRC=test_app

