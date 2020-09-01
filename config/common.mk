PRODUCT_BRAND ?= ShapeShiftOS

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    dalvik.vm.debug.alloc=0 \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.error.receiver.system.apps=com.google.android.gms \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dataroaming=false \
    ro.atrace.core.services=com.google.android.gms,com.google.android.gms.ui,com.google.android.gms.persistent \
    ro.com.android.dateformat=MM-dd-yyyy \
    persist.sys.disable_rescue=true \
    ro.setupwizard.rotation_locked=true

ifeq ($(TARGET_BUILD_VARIANT),eng)
# Disable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=0
else
# Enable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# OTA
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.ota.allow_downgrade=true
endif

# Some permissions
PRODUCT_COPY_FILES += \
    vendor/aosp/config/permissions/backup.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/backup.xml \
    vendor/aosp/config/permissions/privapp-permissions-fm.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-fm.xml \
    vendor/aosp/config/permissions/privapp-permissions-snap.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-snap.xml \
    vendor/aosp/config/permissions/privapp-permissions-camera2.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-camera2.xml \
    vendor/aosp/config/permissions/privapp-permissions-exui-product.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-exui-product.xml \
    vendor/aosp/config/permissions/privapp-permissions-google_prebuilt.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-google_prebuilt.xml

# Copy all custom init rc files
$(foreach f,$(wildcard vendor/aosp/prebuilt/common/etc/init/*.rc),\
    $(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM)/etc/init/$(notdir $f)))

# Copy over added mimetype supported in libcore.net.MimeUtils
PRODUCT_COPY_FILES += \
    vendor/aosp/prebuilt/common/lib/content-types.properties:$(TARGET_COPY_OUT_SYSTEM)/lib/content-types.properties

# Enable Android Beam on all targets
PRODUCT_COPY_FILES += \
    vendor/aosp/config/permissions/android.software.nfc.beam.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.software.nfc.beam.xml

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:$(TARGET_COPY_OUT_SYSTEM)/usr/keylayout/Vendor_045e_Product_0719.kl

# Enforce privapp-permissions whitelist
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.control_privapp_permissions=enforce

# Power whitelist
PRODUCT_COPY_FILES += \
    vendor/aosp/config/permissions/custom-power-whitelist.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/custom-power-whitelist.xml

# Do not include art debug targets
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false

PRODUCT_PROPERTY_OVERRIDES += \
    ro.boot.vendor.overlay.theme=com.potato.overlay.lawnconf

# Lawnchair Default Configuration
ifeq ($(TARGET_LAUNCHER_CHOICE),)
PRODUCT_PACKAGES += \
    LawnConf
endif

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

# Charger
PRODUCT_PACKAGES += \
    charger_res_images

# Filesystems tools
PRODUCT_PACKAGES += \
    fsck.exfat \
    fsck.ntfs \
    mke2fs \
    mkfs.exfat \
    mkfs.ntfs \
    mount.ntfs

# Storage manager
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.storage_manager.enabled=true

# Media
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    media.recorder.show_manufacturer_and_model=true

PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/aosp/overlay
DEVICE_PACKAGE_OVERLAYS += vendor/aosp/overlay/common

# TouchGestures
PRODUCT_PACKAGES += \
    TouchGestures

# PixelSetupWizard overlay
PRODUCT_PACKAGES += \
    PixelSetupWizardOverlay \
    PixelSetupWizardAodOverlay

# Dex preopt
PRODUCT_DEXPREOPT_SPEED_APPS += \
    SystemUI \
    NexusLauncherRelease

# Themed bootanimation
TARGET_MISC_BLOCK_OFFSET ?= 0
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.misc.block.offset=$(TARGET_MISC_BLOCK_OFFSET)
PRODUCT_PACKAGES += \
    misc_writer_system \
    themed_bootanimation

PRODUCT_PACKAGES += \
    BrightnessSliderOverlay

# Face Unlock
ifeq ($(CUSTOM_BUILD_TYPE), OFFICIAL)
TARGET_FACE_UNLOCK_SUPPORTED := false
ifeq ($(TARGET_GAPPS_ARCH),arm64)
ifneq ($(TARGET_DISABLE_ALTERNATIVE_FACE_UNLOCK), true)
PRODUCT_PACKAGES += \
    FaceUnlockService
TARGET_FACE_UNLOCK_SUPPORTED := true
endif
endif
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.face.moto_unlock_service=$(TARGET_FACE_UNLOCK_SUPPORTED)
endif

# Branding
include vendor/aosp/config/branding.mk

# OTA
include vendor/aosp/config/ota.mk

# Face Unlock
TARGET_FACE_UNLOCK_SUPPORTED := false
ifeq (,$(filter $(TARGET_ARCH), arm64))
ifneq ($(TARGET_DISABLE_ALTERNATIVE_FACE_UNLOCK), true)
PRODUCT_PACKAGES += \
    FaceUnlockService
TARGET_FACE_UNLOCK_SUPPORTED := true
endif
endif
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.face.moto_unlock_service=$(TARGET_FACE_UNLOCK_SUPPORTED)

# GApps
include vendor/gapps/config.mk

# Custom Packages
PRODUCT_PACKAGES += \
    StitchImage \
    ThemePicker

# Pixel Style
include vendor/pixelstyle/config.mk

# Ad-blocking
PRODUCT_COPY_FILES += \
    vendor/aosp/prebuilt/common/etc/hosts.adaway_adblock:system/etc/hosts.adaway_adblock

# PixelLiveWallpaper
ifeq ($(TARGET_PIXEL_LWP),true)
PRODUCT_PACKAGES += \
    PixelLiveWallpaperPrebuilt
endif

# Customization
include vendor/google-customization/config.mk

-include $(WORKSPACE)/build_env/image-auto-bits.mk

