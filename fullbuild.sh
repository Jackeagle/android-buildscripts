
#! /bin/sh
#this script copies the patches from the patch folder to the rom folder 
# just replace the ~/patch to ur folder name where the patches exist and change ~/aicp to the path of the rom 



#these copy normal patches reqd to boot the device and core functions to work
cp -r ~/patch/audiovideo.diff ~/aicp/frameworks/av
cp -r ~/patch/bluetooth.diff ~/aicp/hardware/broadcom/libbt
cp -r ~/patch/hwc.diff ~/aicp/frameworks/native
cp -r ~/patch/webview.diff ~/aicp/external/chromium_org
cp -r ~/patch/ril.diff ~/aicp/system/core



echo -e " patches copied ... pleaser review to check for any errors "
read -p " PRESS ENTER TO START APPLYING THE PATCHES "

echo -e ""
echo -e " Applying Patches for Galaxy Grand Duos "
echo -e ""

# Bluetooth Patch
echo -e ""
echo -e " APPLYING BLUETOOTH PATCH "
echo -e ""

cd aicp/hardware/broadcom/libbt
git checkout .
patch -p1 < bluetooth.diff
cd ../../../../
echo -e " BLUETOOTH PATCH APPLIED SUCCESSFULLY "
echo -e ""

# HW Composer Patch 
echo -e ""
echo -e " APPLYING HWC PATCH "
cd aicp/frameworks/native
git checkout .
patch -p1 < hwc.diff
cd ../../../
echo -e ""
echo -e " HWC PATCHES APPLIED SUCCESSFULLY"
echo -e ""

# AUDIO/VIDEO PATCHES 
echo -e ""
echo -e " APPLYING A/V PATCHES"
echo -e ""
cd aicp/frameworks/av
git checkout .
patch -p1 < audiovideo.diff 
cd ../../../
echo -e ""
echo -e " AUDIO/VIDEO PATCHES APPLIED SUCCESSFULLY "
echo -e ""

# WEBVIEW PATCHES 
echo -e ""
echo -e " APPLYING WEBVIEW PATCH "
echo -e ""
cd aicp/external/chromium_org
git checkout .
patch -p1 < webview.diff
cd ../../
echo -e ""
echo -e " WEBVIEW PATCHES APPLIED SUCCESSFULLY"
echo -e ""

# ACTUAL BUILD 
echo -e ""
echo -e " ALL PATCHES APPLIED SUCCESSFULLY AND NOW BUILD STARTING "
echo -e ""

#checking if msim exists

if [ -d "frameworks/opt/telephony-msim" ]
then
    echo "MSIM SUPPORTED ."
   
#now copying msim patches ... change the path aicp to any other rom you are compiling

cp -r ~/patch/msim/msim_frameworks_base.diff ~/aicp/frameworks/base
cp -r ~/patch/msim/msim_frameworks_opt_telephony-msim.patch ~/aicp/frameworks/opt/telephony-msim
cp -r ~/patch/msim/msim_packages_apps_Setting.diff ~/aicp/packages/apps/Settings
cp -r ~/patch/msim/msim_packages_services_Telephony.diff ~/aicp/packages/services/Telephony

echo -e ""
echo -e "MSIM PATCHES COPIED ! PLEASE REVIEW FOR ANY ERRORS"
read -p "PRESS ENTER TO APPLY PATCHES"


#frameworks/base patch 
echo -e " PATCHING FRAMEWORKS/BASE "
echo -e ""

cd frameworks/base 
git checkout .
patch -p1 < msim_frameworks_base.diff
rm -rf packages/SystemUI/res/layout/status_bar_expanded.xml.orig

echo -e " frameworks/base patched successfully "
echo -e ""

# applying frameworks/opt/telephony-msim patch 
echo -e " applying  telephony-msim patch"
echo -e ""
cd ../opt/telephony-msim
git checkout .
patch -p1 < msim_frameworks_opt_telephony-msim.patch

echo -e " telephony-msim patched successfully"
echo -e ""

# applying settings patch 

echo -e " applying settings patch "
echo -e ""
cd ../../../
cd packages/apps/Settings
git checkout .
patch -p1 < msim_packages_apps_Setting.diff
echo -e ""
echo -e " settings patch applied successfully"
echo -e ""

# applying services/telephony patch 
echo -e ""
echo -e " applying telephony patch "
echo -e ""
cd ../../services/Telephony
git checkout .
patch -p1 < msim_packages_services_Telephony.diff
echo -e ""
echo -e " telephony patches successfully"
echo -e ""
cd ../../../

echo -e ""
echo -e " all msim patches applied ..pl review fr any errors "
read -p " PRESS ENTER TO START BUILDING "

. build/envsetup.sh && brunch i9082 -j4
    
else
    echo "MSIM NOT SUPPORTED."
    read -p " PRESS ENTER TO START THE BUILD"
. build/envsetup.sh && brunch i9082
 
fi



 
