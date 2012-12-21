#
# Copyright (C) 2012 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

COMMON_PATH := device/samsung/n1-common

DEVICE_PACKAGE_OVERLAYS += $(COMMON_PATH)/overlay

# Charger
PRODUCT_PACKAGES += \
    charger \
    charger_res_images

# HAL
PRODUCT_PACKAGES += \
    sensors.n1 \
    lights.n1 \
    gps.tegra \
    camera.tegra \
    gralloc.tegra \
    hwcomposer.tegra \
    audio.primary.n1 \
    audio_policy.n1 \
    audio.a2dp.default

# Init-scripts
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/lpm.rc:root/lpm.rc \
    $(COMMON_PATH)/init.n1.rc:root/init.n1.rc \
    $(COMMON_PATH)/init.n1.usb.rc:root/init.n1.usb.rc \
    $(COMMON_PATH)/ueventd.n1.rc:root/ueventd.n1.rc

# Vold and Storage
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/configs/vold.fstab:system/etc/vold.fstab

# Wifi
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/configs/wpa_supplicant.conf:system/etc/wifi/wpa_supplicant.conf

PRODUCT_PROPERTY_OVERRIDES += \
    wifi.interface=wlan0 \
    wifi.supplicant_scan_interval=15

$(call inherit-product-if-exists, hardware/broadcom/wlan/bcmdhd/firmware/bcm4330/device-bcm.mk)

# GPS
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/configs/gps.conf:system/etc/gps.conf \
    $(COMMON_PATH)/configs/sirfgps.conf:system/etc/sirfgps.conf

# Media
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/configs/media_profiles.xml:system/etc/media_profiles.xml \
    $(COMMON_PATH)/configs/media_codecs.xml:system/etc/media_codecs.xml

# Audio
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/configs/audio_policy.conf:system/etc/audio_policy.conf

# OMX
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/configs/somxreg.conf:system/etc/somxreg.conf

# Camera
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/configs/nvcamera.conf:system/etc/nvcamera.conf

# Keychars
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/usr/keychars/Generic.kcm:system/usr/keychars/Generic.kcm \
    $(COMMON_PATH)/usr/keychars/qwerty.kcm:system/usr/keychars/qwerty.kcm \
    $(COMMON_PATH)/usr/keychars/qwerty2.kcm:system/usr/keychars/qwerty2.kcm \
    $(COMMON_PATH)/usr/keychars/Virtual.kcm:system/usr/keychars/Virtual.kcm

# Keylayout
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/usr/keylayout/AVRCP.kl:system/usr/keylayout/AVRCP.kl \
    $(COMMON_PATH)/usr/keylayout/Bluetooth_00_06_66_42.kl:system/usr/keylayout/Bluetooth_00_06_66_42.kl \
    $(COMMON_PATH)/usr/keylayout/Generic.kl:system/usr/keylayout/Generic.kl \
    $(COMMON_PATH)/usr/keylayout/qwerty.kl:system/usr/keylayout/qwerty.kl \
    $(COMMON_PATH)/usr/keylayout/sec_jack.kl:system/usr/keylayout/sec_jack.kl \
    $(COMMON_PATH)/usr/keylayout/sec_key.kl:system/usr/keylayout/sec_key.kl \
    $(COMMON_PATH)/usr/keylayout/sec_touchscreen.kl:system/usr/keylayout/sec_touchscreen.kl \
    $(COMMON_PATH)/usr/keylayout/Vendor_04e8_Product_7021.kl:system/usr/keylayout/Vendor_04e8_Product_7021.kl \
    $(COMMON_PATH)/usr/keylayout/Vendor_05ac_Product_0239.kl:system/usr/keylayout/Vendor_05ac_Product_0239.kl \
    $(COMMON_PATH)/usr/keylayout/Vendor_22b8_Product_093d.kl:system/usr/keylayout/Vendor_22b8_Product_093d.kl \
    $(COMMON_PATH)/usr/keylayout/Vendor_044f_Product_d007.kl:system/usr/keylayout/Vendor_044f_Product_d007.kl \
    $(COMMON_PATH)/usr/keylayout/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_028e.kl \
    $(COMMON_PATH)/usr/keylayout/Vendor_045e_Product_0719.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl \
    $(COMMON_PATH)/usr/keylayout/Vendor_046d_Product_c21d.kl:system/usr/keylayout/Vendor_046d_Product_c21d.kl \
    $(COMMON_PATH)/usr/keylayout/Vendor_046d_Product_c21f.kl:system/usr/keylayout/Vendor_046d_Product_c21f.kl \
    $(COMMON_PATH)/usr/keylayout/Vendor_046d_Product_c216.kl:system/usr/keylayout/Vendor_046d_Product_c216.kl \
    $(COMMON_PATH)/usr/keylayout/Vendor_046d_Product_c294.kl:system/usr/keylayout/Vendor_046d_Product_c294.kl \
    $(COMMON_PATH)/usr/keylayout/Vendor_046d_Product_c299.kl:system/usr/keylayout/Vendor_046d_Product_c299.kl \
    $(COMMON_PATH)/usr/keylayout/Vendor_046d_Product_c532.kl:system/usr/keylayout/Vendor_046d_Product_c532.kl \
    $(COMMON_PATH)/usr/keylayout/Vendor_054c_Product_0268.kl:system/usr/keylayout/Vendor_054c_Product_0268.kl \
    $(COMMON_PATH)/usr/keylayout/Vendor_057e_Product_0306.kl:system/usr/keylayout/Vendor_057e_Product_0306.kl \
    $(COMMON_PATH)/usr/keylayout/Vendor_2378_Product_100a.kl:system/usr/keylayout/Vendor_2378_Product_100a.kl

# IDC files
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/usr/idc/sec_touchscreen.idc:system/usr/idc/sec_touchscreen.idc \
    $(COMMON_PATH)/usr/idc/qwerty.idc:system/usr/idc/qwerty.idc \
    $(COMMON_PATH)/usr/idc/qwerty2.idc:system/usr/idc/qwerty2.idc

# Install the features available on this device.
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:system/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.hardware.camera.xml:system/etc/permissions/android.hardware.camera.xml \
    frameworks/native/data/etc/android.hardware.camera.autofocus.xml:system/etc/permissions/android.hardware.camera.autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:system/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.location.xml:system/etc/permissions/android.hardware.location.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:system/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml \
    frameworks/native/data/etc/android.software.sip.xml:system/etc/permissions/android.software.sip.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.telephony.cdma.xml:system/etc/permissions/android.hardware.telephony.cdma.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.xml:system/etc/permissions/android.hardware.touchscreen.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml

# Feature live wallpaper
PRODUCT_COPY_FILES += \
    packages/wallpapers/LivePicker/android.software.live_wallpaper.xml:system/etc/permissions/android.software.live_wallpaper.xml

# RIL
PRODUCT_PROPERTY_OVERRIDES += \
    ro.telephony.ril_class=Smdk4210RIL \
    mobiledata.interfaces=pdp0,wlan0,gprs,ppp0 \
    ro.ril.hsxpa=1 \
    ro.ril.gprsclass=10

# Filesystem management tools
PRODUCT_PACKAGES += \
    static_busybox \
    make_ext4fs \
    setup_fs

# The OpenGL ES API level that is natively supported by this device.
# This is a 16.16 fixed point number
PRODUCT_PROPERTY_OVERRIDES += \
    ro.opengles.version=131072

PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density=240

PRODUCT_PROPERTY_OVERRIDES += \
    ro.media.dec.jpeg.memcap=20000000 \
    media.stagefright.enable-player=true \
    media.stagefright.enable-meta=true \
    media.stagefright.enable-scan=true \
    media.stagefright.enable-http=true \
    media.stagefright.enable-rtsp=true \
    ro.flash.resolution=1080

# we have enough storage space to hold precise GC data
PRODUCT_TAGS += dalvik.gc.type-precise

# Set default USB interface
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    persist.sys.usb.config=mtp

$(call inherit-product, frameworks/native/build/phone-hdpi-512-dalvik-heap.mk)

# Use the non-open-source parts, if they're present
-include vendor/samsung/n1-common/common-vendor.mk
