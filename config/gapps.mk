ifeq ($(TARGET_GAPPS_ARCH),)
$(error "GAPPS: TARGET_GAPPS_ARCH is undefined")
endif

ifneq ($(TARGET_GAPPS_ARCH),arm)
ifneq ($(TARGET_GAPPS_ARCH),arm64)
$(error "GAPPS: Only arm and arm64 are allowed")
endif
endif

$(call inherit-product, vendor/gapps/common-blobs.mk)

# framework
PRODUCT_PACKAGES += \
    com.google.android.maps

ifeq ($(IS_PHONE),true)
PRODUCT_PACKAGES += \
    com.google.android.dialer.support
endif

# app
ifeq ($(IS_PHONE),true)
PRODUCT_PACKAGES += \
    PrebuiltBugle
endif

ifeq ($(TARGET_INCLUDE_STOCK_ARCORE),true)
PRODUCT_PACKAGES += \
    arcore
endif

# System app
PRODUCT_PACKAGES += \
    GoogleExtShared \
    GooglePrintRecommendationService

# System priv-app
PRODUCT_PACKAGES += \
    GoogleExtServicesPrebuilt

# Product app
PRODUCT_PACKAGES += \
    Chrome \
    GoogleContacts \
    GoogleContactsSyncAdapter \
    GoogleTTS \
    LatinIMEGooglePrebuilt \
    LocationHistoryPrebuilt \
    MarkupGoogle \
    SoundPickerPrebuilt \
    WebViewGoogle

# Product priv-app
PRODUCT_PACKAGES += \
    AndroidMigratePrebuilt \
    CarrierServices \
    ConfigUpdater \
    ConnMetrics \
    GoogleFeedback \
    GoogleOneTimeInitializer \
    GooglePartnerSetup \
    GoogleServicesFramework \
    Phonesky \
    PixelSetupWizard \
    PrebuiltGmsCoreQt \
    SetupWizardPrebuilt \
    TurboPrebuilt \
    WellbeingPrebuilt

ifeq ($(IS_PHONE),true)
PRODUCT_PACKAGES += \
    GoogleDialer
endif

# Debloat
ifneq ($(TARGET_MINIMAL_APPS),true)
PRODUCT_PACKAGES += \
    CalculatorGooglePrebuilt \
    CalendarGooglePrebuilt \
    Photos \
    Velvet \
    talkback \
    PrebuiltDeskClockGoogle 
endif

# Recorder
ifeq ($(TARGET_SUPPORTS_GOOGLE_RECORDER), true)
PRODUCT_PACKAGES += \
    RecorderPrebuilt
endif
