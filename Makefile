
include $(TOPDIR)/rules.mk

PKG_BRANCH:=trunk
PKG_SOURCE_URL:=https://svn.ntop.org/svn/ntop/trunk/n2n/n2n_v2
PKG_REV:=9015

PKG_NAME:=n2n
PKG_VERSION:=2.1_svn$(PKG_REV)
PKG_RELEASE:=12
PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE

PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_SOURCE_SUBDIR).tar.gz
PKG_SOURCE_PROTO:=svn
PKG_SOURCE_VERSION:=$(PKG_REV)

include $(INCLUDE_DIR)/package.mk

define Package/n2n/Default
  SECTION:=net
  CATEGORY:=Network
  TITLE:=N2N VPN tunneling daemon(V2)
  URL:=http://www.ntop.org/n2n/
  SUBMENU:=VPN
  DEPENDS:=+libpthread +kmod-tun +libopenssl +resolveip
endef

define Package/n2n-edge
$(call Package/n2n/Default)
  VARIANT:=edge
endef

define Package/n2n-supernode
$(call Package/n2n/Default)
  VARIANT:=supernode
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		INSTALL_PROG=":"
endef

define Package/n2n-edge/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/edge $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/lib/netifd/proto
	$(INSTALL_BIN) ./files/n2n.sh $(1)/lib/netifd/proto
endef

define Package/n2n-supernode/conffiles
/etc/config/n2n
endef

define Package/n2n-supernode/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/supernode $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/n2n.init $(1)/etc/init.d/n2n
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) ./files/n2n.config $(1)/etc/config/n2n
endef

$(eval $(call BuildPackage,n2n-edge))
$(eval $(call BuildPackage,n2n-supernode))
