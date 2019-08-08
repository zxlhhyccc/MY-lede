#
# Copyright (C) 2015-2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v3.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=smartdns
PKG_VERSION:=2019.06.21
PKG_RELEASE:=2337
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME).1.$(PKG_VERSION)-$(PKG_RELEASE)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=net
	CATEGORY:=Network
	TITLE:=smartdns
	DEPENDS:=+libopenssl 
	URL:=
endef


define Package/$(PKG_NAME)/description
smartdns
endef

ifeq ($(ARCH),x86_64)
	PKG_ARCH_SMARTDNS:=amd64
endif
ifeq ($(ARCH),mipsel)
	PKG_ARCH_SMARTDNS:=mipsle
endif
ifeq ($(ARCH),mips)
	PKG_ARCH_SMARTDNS:=mips
endif
ifeq ($(ARCH),i386)
	PKG_ARCH_SMARTDNS:=x86
endif
ifeq ($(ARCH),arm)
	PKG_ARCH_SMARTDNS:=arm
endif
ifeq ($(ARCH),aarch64)
	PKG_ARCH_SMARTDNS:=arm64
endif

ifeq ($(BOARD),bcm53xx)
	PKG_ARCH_SMARTDNS:=bcm53xx
endif

        SMARTDNS_BIN:=smartdns

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) ./files/$(PKG_ARCH_SMARTDNS)/$(SMARTDNS_BIN) $(1)/usr/sbin/smartdns
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/etc/config/smartdns $(1)/etc/config/smartdns
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/smartdns $(1)/etc/init.d/smartdns
	$(INSTALL_DIR) $(1)/etc/smartdns
	$(INSTALL_CONF) ./files/etc/smartdns/address.conf $(1)/etc/smartdns/address.conf
	$(INSTALL_CONF) ./files/etc/smartdns/blacklist-ip.conf $(1)/etc/smartdns/blacklist-ip.conf
	$(INSTALL_CONF) ./files/etc/smartdns/custom.conf $(1)/etc/smartdns/custom.conf
	$(INSTALL_CONF) ./files/etc/smartdns/smartdns.conf $(1)/etc/smartdns/smartdns.conf
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
