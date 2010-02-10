$(call PKG_INIT_LIB, 4.8.26)
$(PKG)_LIB_VERSION:=4.8
$(PKG)_SOURCE:=$(pkg)-$($(PKG)_VERSION).tar.gz
$(PKG)_SITE:=http://download.oracle.com/berkeley-db
$(PKG)_BINARY:=$($(PKG)_DIR)/usr/local/BerkeleyDB.$($(PKG)_LIB_VERSION)/lib/libdb-$($(PKG)_LIB_VERSION).so
$(PKG)_STAGING_BINARY:=$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/libdb.so.$($(PKG)_LIB_VERSION)
$(PKG)_TARGET_BINARY:=$($(PKG)_TARGET_DIR)/libdb.so.$($(PKG)_LIB_VERSION)
$(PKG)_SOURCE_MD5:=3476bac9ec0f3c40729c8a404151d5e3

$(PKG)_CONFIGURE_OPTIONS +=--enable-shared
$(PKG)_CONFIGURE_OPTIONS +=--enable-static
$(PKG)_CONFIGURE_OPTIONS +=--disable-java
$(PKG)_CONFIGURE_OPTIONS +=--disable-cxx
# $(PKG)_CONFIGURE_OPTIONS +=--with-mutex=UNIX/fcntl   # FIXME: UNIX/fcntl no longer supported in 4.8
$(PKG)_CONFIGURE_OPTIONS +=--disable-tcl
$(PKG)_CONFIGURE_OPTIONS +=--enable-compat185
$(PKG)_CONFIGURE_OPTIONS +=--enable-smallbuild
$(PKG)_CONFIGURE_OPTIONS +=--disable-debug
$(PKG)_CONFIGURE_OPTIONS +=--enable-cryptography

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)

$($(PKG)_DIR)/.configured: $($(PKG)_DIR)/.unpacked
	( cd $(DB_DIR)/build_unix; rm -f config.{cache,status}; \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		CPPFLAGS="-I$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/include" \
		LDFLAGS="-L$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib" \
		ac_cv_prog_CC="$(GNU_TARGET_NAME)-gcc" \
		../dist/configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--program-prefix="" \
		--program-suffix="" \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libexecdir=/usr/lib \
		--datadir=/usr/share \
		--sysconfdir=/etc \
		--localstatedir=/var \
		--libdir=/usr/lib \
		--includedir=/usr/include \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		$(DISABLE_LARGEFILE) \
		$(DISABLE_NLS) \
		$(DB_CONFIGURE_OPTIONS) \
	);
	touch $@

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	PATH=$(TARGET_PATH) \
		$(MAKE) -C $(DB_DIR)/build_unix
	cp -f "$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/libdb-4.8.so" \
		"$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/libdb.so.4.8"   # FIXME: Is there a better way?

$($(PKG)_STAGING_BINARY): $($(PKG)_BINARY)
	PATH=$(TARGET_PATH) \
		$(MAKE) -C $(DB_DIR)/build_unix \
		DESTDIR="$(TARGET_TOOLCHAIN_STAGING_DIR)" \
		install

$($(PKG)_TARGET_BINARY): $($(PKG)_STAGING_BINARY)
	$(INSTALL_LIBRARY_STRIP)

$(pkg): $($(PKG)_STAGING_BINARY)

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(MAKE) DESTDIR="$(TARGET_TOOLCHAIN_STAGING_DIR)" -C $(DB_DIR)/build_unix uninstall
	-$(MAKE) -C $(DB_DIR)/build_unix clean

$(pkg)-uninstall:
	$(RM) $(DB_TARGET_DIR)/libdb*.so*

$(PKG_FINISH)
