# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit meson python-any-r1 xdg

DESCRIPTION="Graphical console client for connecting to virtual machines"
HOMEPAGE="https://virt-manager.org/ https://gitlab.com/virt-viewer/virt-viewer"
if [[ ${PV} == *_p* ]] ; then
	GIT_HASH="f0cc7103becccbce95bdf0c80151178af2bace5a"
	SRC_URI="https://gitlab.com/${PN}/${PN}/-/archive/${GIT_HASH}/${PN}-${GIT_HASH}.tar.bz2 -> ${P}.tar.bz2"
	S="${WORKDIR}/${PN}-${GIT_HASH}"
else
	SRC_URI="https://virt-manager.org/download/sources/${PN}/${P}.tar.xz"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+libvirt sasl +spice +vnc vte"

RDEPEND="dev-libs/glib:2
	>=dev-libs/libxml2-2.6
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/pango
	libvirt? (
		>=app-emulation/libvirt-0.10.0:=[sasl?]
		app-emulation/libvirt-glib
	)
	spice? ( >=net-misc/spice-gtk-0.35[sasl?,gtk3] )
	vte? ( x11-libs/vte:2.91 )
	vnc? ( >=net-libs/gtk-vnc-0.5.0[sasl?,gtk3(+)] )"
DEPEND="${RDEPEND}
	spice? ( >=app-emulation/spice-protocol-0.12.10 )"
BDEPEND="${PYTHON_DEPS}
	dev-lang/perl
	virtual/pkgconfig"

REQUIRED_USE="|| ( spice vnc )"

PATCHES=(
	"${FILESDIR}"/${PN}-10.0_p20210730-meson-0.61.patch
)

src_prepare() {
	default

	# Fix python shebangs for python-exec[-native-symlinks], #811408
	local shebangs=($(grep -rl "#!/usr/bin/env python3" || die))
	python_fix_shebang -q ${shebangs[*]}
}

src_configure() {
	local emesonargs=(
		$(meson_feature libvirt)
		$(meson_feature vte)
		$(meson_feature vnc)
		$(meson_feature spice)

		-Dgit_werror=disabled
	)

	meson_src_configure
}
