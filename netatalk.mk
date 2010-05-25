$(call PKG_INIT_BIN, 2.1)
$(PKG)_SOURCE := $(pkg)-$($(PKG)_VERSION).tar.gz
$(PKG)_SOURCE_MD5 := 27d4b8dca55801fe7d194bf6b34852f4
$(PKG)_SITE := @SF/netatalk

$(PKG)_LIBS := uams_guest uams_dhx_passwd
$(PKG)_LIBS_BUILD_DIR := $(NETATALK_LIBS:%=$($(PKG)_DIR)/etc/uams/.libs/%.so)
$(PKG)_LIBS_TARGET_DIR := $(NETATALK_LIBS:%=$($(PKG)_DEST_LIBDIR)/%.so)

$(PKG)_AFPD_BINS := hash 
$(PKG)_CNID_BINS := dbd
$(PKG)_BINS_BUILD_DIR := $(NETATALK_AFPD_BINS:%=$($(PKG)_DIR)/etc/afpd/%) $(NETATALK_CNID_BINS:%=$($(PKG)_DIR)/etc/cnid_dbd/%)
$(PKG)_BINS_TARGET_DIR := $(NETATALK_AFPD_BINS:%=$($(PKG)_DEST_DIR)/usr/bin/%) $(NETATALK_CNID_BINS:%=$($(PKG)_DEST_DIR)/usr/bin/%)

$(PKG)_AFPD_SBINS := afpd 
$(PKG)_CNID_SBINS := cnid_metad cnid_dbd
$(PKG)_SBINS_BUILD_DIR := $(NETATALK_AFPD_SBINS:%=$($(PKG)_DIR)/etc/afpd/%) $(NETATALK_CNID_SBINS:%=$($(PKG)_DIR)/etc/cnid_dbd/%)
$(PKG)_SBINS_TARGET_DIR := $(NETATALK_AFPD_SBINS:%=$($(PKG)_DEST_DIR)/sbin/%) $(NETATALK_CNID_SBINS:%=$($(PKG)_DEST_DIR)/sbin/%)

$(PKG)_DEPENDS_ON := db libgcrypt openssl

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
$(PKG)_CONFIGURE_OPTIONS +=--with-includedir="$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/include"
$(PKG)_CONFIGURE_OPTIONS +=--with-libdir="$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib"
$(PKG)_CONFIGURE_OPTIONS +=--with-uams-path="/usr/lib/freetz"

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_LIBS_BUILD_DIR) $($(PKG)_BINS_BUILD_DIR) $($(PKG)_SBINS_BUILD_DIR): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(NETATALK_DIR) \
		CPPFLAGS="-I$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/include $(NETATALK_CPPFLAGS)" \
		LDFLAGS="-L$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib"

$($(PKG)_LIBS_TARGET_DIR): $($(PKG)_DEST_LIBDIR)/%: $($(PKG)_DIR)/etc/uams/.libs/%
	$(INSTALL_LIBRARY_STRIP)

$($(PKG)_BINS_TARGET_DIR): $($(PKG)_DEST_DIR)/usr/bin/%: $($(PKG)_BINS_BUILD_DIR)
	$(INSTALL_BINARY_STRIP)

$($(PKG)_SBINS_TARGET_DIR): $($(PKG)_DEST_DIR)/sbin/%: $($(PKG)_SBINS_BUILD_DIR)
	$(INSTALL_BINARY_STRIP)

$(pkg):

$(pkg)-precompiled: $($(PKG)_LIBS_TARGET_DIR) $($(PKG)_BINS_TARGET_DIR) $($(PKG)_SBINS_TARGET_DIR)

$(pkg)-clean:
	-$(SUBMAKE) -C $(NETATALK_DIR) clean
	$(RM) $(NETATALK_FREETZ_CONFIG_FILE)

$(pkg)-uninstall:
	$(RM) $($(PKG)_LIBS_TARGET_DIR) $($(PKG)_BINS_TARGET_DIR) $($(PKG)_SBINS_TARGET_DIR)

$(PKG_FINISH)
