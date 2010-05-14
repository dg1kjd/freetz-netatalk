$(call PKG_INIT_BIN, 2.1)
$(PKG)_SOURCE:=$(pkg)-$($(PKG)_VERSION).tar.gz
$(PKG)_SITE:=@SF/netatalk
$(PKG)_BINARY:=$($(PKG)_DIR)/afpd
$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)/sbin/afpd
$(PKG)_SOURCE_MD5:=27d4b8dca55801fe7d194bf6b34852f4

$(PKG)_CONFIGURE_OPTIONS +=--disable-afs
$(PKG)_CONFIGURE_OPTIONS +=--enable-hfs
$(PKG)_CONFIGURE_OPTIONS +=--disable-debugging
$(PKG)_CONFIGURE_OPTIONS +=--disable-shell-check
$(PKG)_CONFIGURE_OPTIONS +=--disable-timelord
$(PKG)_CONFIGURE_OPTIONS +=--disable-a2boot
$(PKG)_CONFIGURE_OPTIONS +=--disable-cups
$(PKG)_CONFIGURE_OPTIONS +=--disable-tcp-wrappers
$(PKG)_CONFIGURE_OPTIONS +=--with-cnid-default-backend=dbd
$(PKG)_CONFIGURE_OPTIONS +=--with-includedir="$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/include"
$(PKG)_CONFIGURE_OPTIONS +=--with-libdir="$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib"
$(PKG)_CONFIGURE_OPTIONS +=--with-uams-path="/usr/lib/uams"
$(PKG)_CONFIGURE_OPTIONS +=--disable-admin-group
$(PKG)_CONFIGURE_OPTIONS +=--disable-srvloc

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(NETATALK_DIR) \
		$(NETATALK_MAKE_OPTIONS) CPPFLAGS="$(NETATALK_CPPFLAGS)"

$($(PKG)_TARGET_BINARY): $($(PKG)_BINARY)
	$(INSTALL_BINARY_STRIP)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	-$(SUBMAKE) -C $(NETATALK_DIR) clean
	$(RM) $(NETATALK_FREETZ_CONFIG_FILE)

$(pkg)-uninstall:
	$(RM) $(NETATALK_TARGET_BINARY)

$(PKG_FINISH)
