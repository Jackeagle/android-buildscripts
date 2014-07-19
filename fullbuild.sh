#this script copies the patches from the patch folder to the rom folder 

# just replace the ~/patch to ur folder name where the patches exist and change ~/axxion to the path of the rom 



#these copy normal patches reqd to boot the device and core functions to work
cp -r ~/patch/audiovideo.diff ~/axxion/frameworks/av
cp -r ~/patch/bluetooth.diff ~/axxion/hardware/broadcom/libbt
cp -r ~/patch/hwc.diff ~/axxion/frameworks/native
cp -r ~/patch/webview.diff ~/axxion/external/chromium_org
cp -r ~/patch/ril.diff ~/axxion/system/core



echo -e " patches copied ... pleaser review to check for any errors "
read -p " PRESS ENTER TO START APPLYING THE PATCHES "

echo -e ""
echo -e " Applying Patches for Galaxy Grand Duos "
echo -e ""

# Bluetooth Patch
echo -e ""
echo -e " APPLYING BLUETOOTH PATCH "
echo -e ""
cd hardware/broadcom/libbt
git checkout .
patch -p1 < bluetooth.diff
cd ../../../
echo -e " BLUETOOTH PATCH APPLIED SUCCESSFULLY "
echo -e ""

# HW Composer Patch 
echo -e ""
echo -e " APPLYING HWC PATCH "
cd frameworks/native
git checkout .
patch -p1 < hwc.diff
git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_native refs/changes/62/53162/6 && git format-patch -1 --stdout FETCH_HEAD

echo -e ""
echo -e " HWC PATCHES APPLIED SUCCESSFULLY"
echo -e ""

# AUDIO/VIDEO PATCHES 
echo -e ""
echo -e " APPLYING A/V PATCHES"
echo -e ""
cd ../av
git checkout .
patch -p1 < audiovideo.diff 
echo -e ""
echo -e " AUDIO/VIDEO PATCHES APPLIED SUCCESSFULLY "

# WEBVIEW PATCHES 
echo -e ""
echo -e " APPLYING WEBVIEW PATCH "
echo -e ""
cd ../../
cd external/chromium_org
git checkout .
patch -p1 < webview.diff
echo -e ""
echo -e " WEBVIEW PATCHES APPLIED SUCCESSFULLY"

# ACTUAL BUILD 
echo -e ""
echo -e " ALL PATCHES APPLIED SUCCESSFULLY AND NOW BUILD STARTING "
echo -e ""
cd ../../

#checking if msim exists

if [ -d "frameworks/opt/telephony-msim" ]
then
    echo "MSIM SUPPORTED ."
   
#now copying msim patches ... change the path axxion to any other rom you are compiling

cp -r ~/patch/msim/msim_frameworks_base.diff ~/axxion/frameworks/base
cp -r ~/patch/msim/msim_frameworks_opt_telephony-msim.patch ~/axxion/frameworks/opt/telephony-msim
cp -r ~/patch/msim/msim_packages_apps_Setting.diff ~/axxion/packages/apps/Settings
cp -r ~/patch/msim/msim_packages_services_Telephony.diff ~/axxion/packages/services/Telephony
#frameworks/base patch 
echo -e " PATCHING FRAMEWORKS/BASE "
echo -e ""

cd frameworks/base 
git checkout .
patch -p1 < msim_frameworks_base.diff
rm -rf /res/layout/status_bar_expanded.xml.orig

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



 
