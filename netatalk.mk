$(call PKG_INIT_BIN, 2.1)
$(PKG)_SOURCE:=$(pkg)-$($(PKG)_VERSION).tar.gz
$(PKG)_SITE:=@SF/netatalk
$(PKG)_BINARY:=$($(PKG)_DIR)/afpd
$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)/sbin/afpd
$(PKG)_SOURCE_MD5:=f35cd7a4ce26c780de380cd2bcae5ce6

$(PKG)_CONFIGURE_OPTIONS +=--disable-afs
$(PKG)_CONFIGURE_OPTIONS +=--enable-hfs
$(PKG)_CONFIGURE_OPTIONS +=--disable-debugging
$(PKG)_CONFIGURE_OPTIONS +=--disable-shell-check
$(PKG)_CONFIGURE_OPTIONS +=--disable-timelord
$(PKG)_CONFIGURE_OPTIONS +=--disable-a2boot
$(PKG)_CONFIGURE_OPTIONS +=--disable-cups
$(PKG)_CONFIGURE_OPTIONS +=--disable-tcp-wrappers
$(PKG)_CONFIGURE_OPTIONS +=--with-cnid-default-backend=dbd
# $(PKG)_CONFIGURE_OPTIONS +=--with-uams-path="/usr/lib/uams"
$(PKG)_CONFIGURE_OPTIONS +=--disable-admin-group

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	PATH="$(TARGET_PATH)" \
		$(MAKE) -C $(NETATALK_DIR) \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS) -I$(PWD)/$(NETATALK_DIR)/include -I$(PWD)/$(NETATALK_DIR)/sys"

$($(PKG)_TARGET_BINARY): $($(PKG)_BINARY)
	$(INSTALL_BINARY_STRIP)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	-$(MAKE) -C $(NETATALK_DIR) clean
	$(RM) $(NETATALK_DIR)/.configured

$(pkg)-uninstall:
	$(RM) $(NETATALK_TARGET_BINARY)

$(PKG_FINISH)
