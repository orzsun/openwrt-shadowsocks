#
# Copyright (C) 2016 Jian Chang <aa65535@live.com>
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=shadowsocksR-libev
PKG_VERSION:=2.5.6
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/orzsun/shadowsocks-libev.git
PKG_SOURCE_VERSION:=ccecb762b5943769ca10676f8bda478f4d5beb7f

PKG_SOURCE_PROTO:=git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)

PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=Max Lv <max.c.lv@gmail.com>

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)/$(BUILD_VARIANT)/$(PKG_NAME)-$(PKG_VERSION)

PKG_INSTALL:=1
PKG_FIXUP:=autoreconf
PKG_USE_MIPS16:=0
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/shadowsocksR-libev/Default
	SECTION:=net
	CATEGORY:=Network
	TITLE:=Lightweight Secured Socks5 Proxy $(2)
	URL:=https://github.com/shadowsocks/shadowsocksR-libev
	VARIANT:=$(1)
	DEPENDS:=$(3) +libpthread +libsodium +libev +ipset +ip +iptables-mod-tproxy +libpcre
endef

Package/shadowsocksR-libev = $(call Package/shadowsocksR-libev/Default,openssl,(OpenSSL),+libopenssl +zlib)
Package/shadowsocksR-libev-server = $(Package/shadowsocksR-libev)
Package/shadowsocksR-libev-mbedtls = $(call Package/shadowsocksR-libev/Default,mbedtls,(mbedTLS),+libmbedtls)
Package/shadowsocksR-libev-server-mbedtls = $(Package/shadowsocksR-libev-mbedtls)
Package/shadowsocksR-libev-polarssl = $(call Package/shadowsocksR-libev/Default,polarssl,(PolarSSL),+libpolarssl)
Package/shadowsocksR-libev-server-polarssl = $(Package/shadowsocksR-libev-polarssl)

define Package/shadowsocksR-libev/description
shadowsocksR-libev is a lightweight secured socks5 proxy for embedded devices and low end boxes.
endef

Package/shadowsocksR-libev-server/description = $(Package/shadowsocksR-libev/description)
Package/shadowsocksR-libev-mbedtls/description = $(Package/shadowsocksR-libev/description)
Package/shadowsocksR-libev-server-mbedtls/description = $(Package/shadowsocksR-libev/description)
Package/shadowsocksR-libev-polarssl/description = $(Package/shadowsocksR-libev/description)
Package/shadowsocksR-libev-server-polarssl/description = $(Package/shadowsocksR-libev/description)

CONFIGURE_ARGS += --disable-ssp --disable-documentation --disable-assert

ifeq ($(BUILD_VARIANT),mbedtls)
	CONFIGURE_ARGS += --with-crypto-library=mbedtls
endif

ifeq ($(BUILD_VARIANT),polarssl)
	CONFIGURE_ARGS += --with-crypto-library=polarssl
endif

define Package/shadowsocksR-libev/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-{local,redir,tunnel} $(1)/usr/bin
endef

Package/shadowsocksR-libev-mbedtls/install = $(Package/shadowsocksR-libev/install)
Package/shadowsocksR-libev-polarssl/install = $(Package/shadowsocksR-libev/install)

define Package/shadowsocksR-libev-server/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-server $(1)/usr/bin
endef

Package/shadowsocksR-libev-server-mbedtls/install = $(Package/shadowsocksR-libev-server/install)
Package/shadowsocksR-libev-server-polarssl/install = $(Package/shadowsocksR-libev-server/install)

$(eval $(call BuildPackage,shadowsocksR-libev))
$(eval $(call BuildPackage,shadowsocksR-libev-server))
$(eval $(call BuildPackage,shadowsocksR-libev-mbedtls))
$(eval $(call BuildPackage,shadowsocksR-libev-server-mbedtls))
$(eval $(call BuildPackage,shadowsocksR-libev-polarssl))
$(eval $(call BuildPackage,shadowsocksR-libev-server-polarssl))
