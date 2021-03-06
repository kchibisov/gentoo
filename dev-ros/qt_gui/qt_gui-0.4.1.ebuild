# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ROS_REPO_URI="https://github.com/ros-visualization/qt_gui_core"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="ROS infrastructure for an integrated graphical user interface based on Qt"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-python/rospkg[${PYTHON_USEDEP}]
	>=dev-ros/python_qt_binding-0.3.0[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
