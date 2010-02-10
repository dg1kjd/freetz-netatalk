$(call PKG_INIT_LIB, 4.8.26)
$(PKG)_LIB_VERSION:=4.8
$(PKG)_SOURCE:=$(pkg)-$($(PKG)_VERSION).tar.gz
$(PKG)_SITE:=http://download.oracle.com/berkeley-db
$(PKG)_BINARY:=$($(PKG)_DIR)/usr/local/BerkeleyDB.$($(PKG)_LIB_VERSION)/lib/libdb-$($(PKG)_LIB_VERSION).so
$(PKG)_STAGING_BINARY:=$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/libdb.so.$($(PKG)_LIB_VERSION)
$(PKG)_TARGET_BINARY:=$($(PKG)_TARGET_DIR)/libdb.so.$($(PKG)_LIB_VERSION)
$(PKG)_SOURCE_MD5:=3476bac9ec0f3c40729c8a404151d5e3

$(PKG)_CONFIGURE_PRE_CMDS += cd build_unix; ../dist/configure;

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	PATH=$(TARGET_PATH) \
		$(MAKE) -C $(DB_DIR)/build_unix
	cp -f "$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/local/BerkeleyDB.4.8/lib/libdb-4.8.so" \
		"$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/libdb.so.4.8"
	cp -f "$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/local/BerkeleyDB.4.8/include/db_cxx.h" \
		"$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/include"
	cp -f "$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/local/BerkeleyDB.4.8/include/db.h" \
		"$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/include"

$($(PKG)_STAGING_BINARY): $($(PKG)_BINARY)
	PATH=$(TARGET_PATH) \
		$(MAKE) -C $(DB_DIR)/build_unix \
		DESTDIR="$(TARGET_TOOLCHAIN_STAGING_DIR)" \
		install

$($(PKG)_TARGET_BINARY): $($(PKG)_STAGING_BINARY)
#	$(INSTALL_LIBRARY_STRIP)	# TODO: stripping doesn't work
	$(INSTALL_LIBRARY)

$(pkg): $($(PKG)_STAGING_BINARY)

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(MAKE) DESTDIR="$(TARGET_TOOLCHAIN_STAGING_DIR)" -C $(DB_DIR)/build_unix uninstall
	-$(MAKE) -C $(DB_DIR)/build_unix clean

$(pkg)-uninstall:
	$(RM) $(DB_TARGET_DIR)/libdb*.so*

$(PKG_FINISH)
