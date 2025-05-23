# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2009-2013 OpenWrt.org
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=xtables-addons
PKG_VERSION:=3.26
PKG_RELEASE:=1
PKG_HASH:=0b52df2117bacf2e32d1d3f98d09dbf88b274390733d3955699b108acaf9f2a6

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=https://inai.de/files/xtables-addons/
PKG_BUILD_DEPENDS:=iptables

PKG_MAINTAINER:=Jo-Philipp Wich <jo@mein.io>
PKG_LICENSE:=GPL-2.0
PKG_LICENSE_FILES:=COPYING

PKG_ASLR_PIE:=0

include $(INCLUDE_DIR)/package.mk

define Package/xtables-addons
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Firewall
  TITLE:=Extensions not distributed in the main Xtables
  URL:=https://inai.de/projects/xtables-addons/
endef

define Build/Compile
	$(KERNEL_MAKE) $(PKG_JOBS) -C $(LINUX_DIR) \
		$(KERNEL_MAKE_FLAGS) \
		M="$(PKG_BUILD_DIR)/extensions" \
		modules
endef

# 1: extension/module suffix used in package name
# 2: extension/module display name used in package title/description
# 3: list of extensions to package
# 4: list of modules to package
# 5: module load priority
# 6: module depends
define BuildTemplate

 ifneq ($(4),)
  define KernelPackage/ipt-$(1)
    SUBMENU:=Netfilter Extensions
    TITLE:=$(2) netfilter module
    DEPENDS:=+kmod-ipt-core $(5)
    FILES:=$(foreach mod,$(4),$(PKG_BUILD_DIR)/extensions/$(mod).$(LINUX_KMOD_SUFFIX))
    AUTOLOAD:=$(call AutoProbe,$(notdir $(4)))
  endef

  $$(eval $$(call KernelPackage,ipt-$(1)))
 endif

endef


#$(eval $(call BuildTemplate,SUFFIX,DESCRIPTION,EXTENSION,MODULE,PRIORITY,DEPENDS))

$(eval $(call BuildTemplate,compat-xtables,API compatibilty layer,,compat_xtables,+IPV6:kmod-ip6tables))
$(eval $(call BuildTemplate,nathelper-rtsp,RTSP Conntrack and NAT,,rtsp/nf_conntrack_rtsp rtsp/nf_nat_rtsp,+kmod-ipt-conntrack-extra +kmod-ipt-nat))

$(eval $(call BuildTemplate,account,ACCOUNT,xt_ACCOUNT,ACCOUNT/xt_ACCOUNT,+kmod-ipt-compat-xtables))
$(eval $(call BuildTemplate,asn,asn,xt_asn,xt_asn,))
$(eval $(call BuildTemplate,chaos,CHAOS,xt_CHAOS,xt_CHAOS,+kmod-ipt-compat-xtables +kmod-ipt-delude +kmod-ipt-tarpit))
$(eval $(call BuildTemplate,condition,Condition,xt_condition,xt_condition,))
$(eval $(call BuildTemplate,delude,DELUDE,xt_DELUDE,xt_DELUDE,+kmod-ipt-compat-xtables))
$(eval $(call BuildTemplate,dhcpmac,DHCPMAC,xt_DHCPMAC,xt_DHCPMAC,+kmod-ipt-compat-xtables))
$(eval $(call BuildTemplate,dnetmap,DNETMAP,xt_DNETMAP,xt_DNETMAP,+kmod-ipt-compat-xtables +kmod-ipt-nat))
$(eval $(call BuildTemplate,fuzzy,fuzzy,xt_fuzzy,xt_fuzzy,))
$(eval $(call BuildTemplate,geoip,geoip,xt_geoip,xt_geoip,))
$(eval $(call BuildTemplate,iface,iface,xt_iface,xt_iface,))
$(eval $(call BuildTemplate,ipmark,IPMARK,xt_IPMARK,xt_IPMARK,+kmod-ipt-compat-xtables))
$(eval $(call BuildTemplate,ipp2p,IPP2P,xt_ipp2p,xt_ipp2p,+kmod-ipt-compat-xtables))
$(eval $(call BuildTemplate,ipv4options,ipv4options,xt_ipv4options,xt_ipv4options,))
$(eval $(call BuildTemplate,length2,length2,xt_length2,xt_length2,+kmod-ipt-compat-xtables))
$(eval $(call BuildTemplate,logmark,LOGMARK,xt_LOGMARK,xt_LOGMARK,+kmod-ipt-compat-xtables))
$(eval $(call BuildTemplate,lscan,lscan,xt_lscan,xt_lscan,))
$(eval $(call BuildTemplate,lua,Lua PacketScript,xt_LUA,LUA/xt_LUA,+kmod-ipt-conntrack-extra))
$(eval $(call BuildTemplate,proto,PROTO,xt_PROTO,xt_PROTO,))
$(eval $(call BuildTemplate,psd,psd,xt_psd,xt_psd,))
$(eval $(call BuildTemplate,quota2,quota2,xt_quota2,xt_quota2,))
$(eval $(call BuildTemplate,sysrq,SYSRQ,xt_SYSRQ,xt_SYSRQ,+kmod-ipt-compat-xtables +kmod-crypto-hash))
$(eval $(call BuildTemplate,tarpit,TARPIT,xt_TARPIT,xt_TARPIT,+kmod-ipt-compat-xtables))
