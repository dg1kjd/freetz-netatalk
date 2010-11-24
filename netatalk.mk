$(call PKG_INIT_BIN, 2.1.4)
$(PKG)_SOURCE := $(pkg)-$($(PKG)_VERSION).tar.gz
$(PKG)_SOURCE_MD5 := d5c9262896338cc1402a49c0f8ca2157
$(PKG)_SITE := @SF/netatalk

$(PKG)_LIBS := uams_guest uams_dhx2_passwd
$(PKG)_LIBS_BUILD_DIR := $($(PKG)_LIBS:%=$($(PKG)_DIR)/etc/uams/.libs/%.so)
$(PKG)_LIBS_TARGET_DIR := $($(PKG)_LIBS:%=$($(PKG)_DEST_LIBDIR)/%.so)

$(PKG)_BINS_AFPD := afpd hash
$(PKG)_BINS_AFPD_BUILD_DIR := $($(PKG)_BINS_AFPD:%=$($(PKG)_DIR)/etc/afpd/%)
$(PKG)_BINS_AFPD_TARGET_DIR := $($(PKG)_BINS_AFPD:%=$($(PKG)_DEST_DIR)/sbin/%)

$(PKG)_BINS_DBD := cnid_dbd cnid_metad dbd
$(PKG)_BINS_DBD_BUILD_DIR := $($(PKG)_BINS_DBD:%=$($(PKG)_DIR)/etc/cnid_dbd/%)
$(PKG)_BINS_DBD_TARGET_DIR := $($(PKG)_BINS_DBD:%=$($(PKG)_DEST_DIR)/sbin/%)

$(PKG)_BINS_AFPPASSWD := afppasswd
$(PKG)_BINS_AFPPASSWD_BUILD_DIR := $($(PKG)_BINS_AFPPASSWD:%=$($(PKG)_DIR)/bin/afppasswd/%)
$(PKG)_BINS_AFPPASSWD_TARGET_DIR := $($(PKG)_BINS_AFPPASSWD:%=$($(PKG)_DEST_DIR)/sbin/%)

$(PKG)_DEPENDS_ON := db libgcrypt

$(PKG)_CONFIGURE_OPTIONS +=--disable-afs
$(PKG)_CONFIGURE_OPTIONS +=--enable-hfs
$(PKG)_CONFIGURE_OPTIONS +=--disable-debugging
$(PKG)_CONFIGURE_OPTIONS +=--disable-shell-check
$(PKG)_CONFIGURE_OPTIONS +=--disable-timelord
$(PKG)_CONFIGURE_OPTIONS +=--disable-a2boot
$(PKG)_CONFIGURE_OPTIONS +=--disable-cups
$(PKG)_CONFIGURE_OPTIONS +=--disable-tcp-wrappers
$(PKG)_CONFIGURE_OPTIONS +=--disable-admin-group
$(PKG)_CONFIGURE_OPTIONS +=--disable-srvloc
$(PKG)_CONFIGURE_OPTIONS +=--with-cnid-default-backend=dbd
$(PKG)_CONFIGURE_OPTIONS +=--with-bdb="$(TARGET_TOOLCHAIN_STAGING_DIR)/usr"
$(PKG)_CONFIGURE_OPTIONS +=--with-libgcrypt-dir="$(TARGET_TOOLCHAIN_STAGING_DIR)/usr"
$(PKG)_CONFIGURE_OPTIONS +=--with-uams-path="/usr/lib/freetz"
$(PKG)_CONFIGURE_OPTIONS +=--with-libdir="$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib"
$(PKG)_CONFIGURE_OPTIONS +=--with-includedir="$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/include"
$(PKG)_CONFIGURE_OPTIONS +=--sysconfdir="/mod/etc"

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_LIBS_BUILD_DIR) $($(PKG)_BINS_AFPD_BUILD_DIR) $($(PKG)_BINS_DBD_BUILD_DIR) $($(PKG)_BINS_AFPPASSWD_BUILD_DIR): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(NETATALK_DIR) \
		CPPFLAGS="-I$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/include $(NETATALK_CPPFLAGS)" \
		LDFLAGS="-L$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib"

$($(PKG)_LIBS_TARGET_DIR): $($(PKG)_DEST_LIBDIR)/%: $($(PKG)_DIR)/etc/uams/.libs/%
	$(INSTALL_LIBRARY_STRIP)

$($(PKG)_BINS_AFPD_TARGET_DIR): $($(PKG)_DEST_DIR)/sbin/%: $($(PKG)_DIR)/etc/afpd/%
	$(INSTALL_BINARY_STRIP)

$($(PKG)_BINS_DBD_TARGET_DIR): $($(PKG)_DEST_DIR)/sbin/%: $($(PKG)_DIR)/etc/cnid_dbd/%
	$(INSTALL_BINARY_STRIP)

$($(PKG)_BINS_AFPPASSWD_TARGET_DIR): $($(PKG)_DEST_DIR)/sbin/%: $($(PKG)_DIR)/bin/afppasswd/%
	$(INSTALL_BINARY_STRIP)

$(pkg):

$(pkg)-precompiled: $($(PKG)_LIBS_TARGET_DIR) $($(PKG)_BINS_AFPD_TARGET_DIR) $($(PKG)_BINS_DBD_TARGET_DIR) $($(PKG)_BINS_AFPPASSWD_TARGET_DIR)

$(pkg)-clean:
	-$(SUBMAKE) -C $(NETATALK_DIR) clean
	$(RM) $(NETATALK_FREETZ_CONFIG_FILE)

$(pkg)-uninstall:
	$(RM) $($(PKG)_LIBS_TARGET_DIR) $($(PKG)_BINS_AFPD_TARGET_DIR) $($(PKG)_BINS_DBD_TARGET_DIR) $($(PKG)_BINS_AFPPASSWD_TARGET_DIR)

$(PKG_FINISH)
