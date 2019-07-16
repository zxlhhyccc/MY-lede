include $(TOPDIR)/rules.mk

PKG_NAME:=brcmfmac-board-rpi
#PKG_VERSION:=2018-03-12
#PKG_RELEASE:=86e88fbf0345da49555d0ec34c80b4fbae7d0cd3
PKG_VERSION:=2018-08-20
PKG_RELEASE:=b518de45ced519e8f7a499f4778100173402ae43
PKG_FLAGS:=nonshared

include $(INCLUDE_DIR)/package.mk

BRCMFMAC434XX_SDIO_URL:=@GITHUB/RPi-Distro/firmware-nonfree/$(PKG_RELEASE)/brcm/
BRCMFMAC43430_SDIO_FILE:=brcmfmac43430-sdio-$(PKG_RELEASE)
BRCMFMAC43455_SDIO_FILE:=brcmfmac43455-sdio-$(PKG_RELEASE)

define Download/brcmfmac43430_sdio_txt
  FILE:=$(BRCMFMAC43430_SDIO_FILE).txt
  URL:=$(BRCMFMAC434XX_SDIO_URL)
  URL_FILE:=brcmfmac43430-sdio.txt
  HASH:=fc3949a4c32f07c18308e7e145c7615be314158e7d714a80e04e4791f16495f9
endef
$(eval $(call Download,brcmfmac43430_sdio_txt))

define Download/brcmfmac43455_sdio_txt
  FILE:=$(BRCMFMAC43455_SDIO_FILE).txt
  URL:=$(BRCMFMAC434XX_SDIO_URL)
  URL_FILE:=brcmfmac43455-sdio.txt
  HASH:=e971a57d928d2f2020906aca80a373565af5e4fa03357ed702a6bb5127df8b64
endef
$(eval $(call Download,brcmfmac43455_sdio_txt))

define Download/brcmfmac43455_sdio_clm_blob
  FILE:=$(BRCMFMAC43455_SDIO_FILE).clm_blob
  URL:=$(BRCMFMAC434XX_SDIO_URL)
  URL_FILE:=brcmfmac43455-sdio.clm_blob
  HASH:=8e2250518bc789e53109728c3c0a6124bc3801a75a1cb4966125753cf1f0252e
endef
$(eval $(call Download,brcmfmac43455_sdio_clm_blob))

define Package/brcmfmac-board-rpi/Default
  SECTION:=firmware
  CATEGORY:=Firmware
  URL:=https://github.com/RPi-Distro/firmware-nonfree/
  DEPENDS:=@TARGET_brcm2708
  PKGARCH:=all
endef

define Package/brcmfmac-board-rpi2
  $(call Package/brcmfmac-board-rpi/Default)
  TITLE:=BCM43430 RPi SDIO NVRAM
endef

define Package/brcmfmac-board-rpi2/description
  NVRAM for the Broadcom BCM43430 on RPi boards.
endef

define Package/brcmfmac-board-rpi3
  $(call Package/brcmfmac-board-rpi/Default)
  TITLE:=BCM43455 RPi SDIO NVRAM
endef

define Package/brcmfmac-board-rpi3/description
  NVRAM and localisations blob for the Broadcom BCM43455 on RPi boards.
endef

define Build/Prepare
	rm -rf $(PKG_BUILD_DIR)
	mkdir -p $(PKG_BUILD_DIR)
	cp $(DL_DIR)/$(BRCMFMAC43430_SDIO_FILE).txt $(PKG_BUILD_DIR)/brcmfmac43430-sdio.txt
	cp $(DL_DIR)/$(BRCMFMAC43455_SDIO_FILE).txt $(PKG_BUILD_DIR)/brcmfmac43455-sdio.txt
	cp $(DL_DIR)/$(BRCMFMAC43455_SDIO_FILE).clm_blob $(PKG_BUILD_DIR)/brcmfmac43455-sdio.clm_blob
endef

define Build/Compile
	true
endef

define Package/brcmfmac-board-rpi2/install
	$(INSTALL_DIR) $(1)/lib/firmware/brcm/
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/brcmfmac43430-sdio.txt $(1)/lib/firmware/brcm/
endef

define Package/brcmfmac-board-rpi3/install
	$(INSTALL_DIR) $(1)/lib/firmware/brcm/
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/brcmfmac43455-sdio.txt $(1)/lib/firmware/brcm/
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/brcmfmac43455-sdio.clm_blob $(1)/lib/firmware/brcm/
endef

$(eval $(call BuildPackage,brcmfmac-board-rpi2))
$(eval $(call BuildPackage,brcmfmac-board-rpi3))
