# 
# Do NOT Edit the Auto-generated Part!
# Generated by: spectacle version 0.26
# 

Name:       FacebookForSOCAM

# >> macros
# << macros

Summary:    Facebook client for SOCAM
Version:    1.2.3
Release:    1
Group:      Applications/Internet
License:    TBD
URL:        https://github.com/socam/facebookforsocam
Source0:    %{name}-%{version}.tar.bz2
#Requires:  pkgconfig(QtCore) >= 4.7.0
#Requires:  pkgconfig(QtGui)
#Requires:  pkgconfig(QtWebKit)
#Requires:  pkgconfig(QtOpenGL)
#BuildRequires:  pkgconfig(QtCore) >= 4.7.0
#BuildRequires:  pkgconfig(QtGui)
#BuildRequires:  pkgconfig(QtWebKit)
#BuildRequires:  pkgconfig(QtOpenGL)
Provides:   facebookforsocam = 1.2.3

%description
Facebook client for SOCAM

%prep
%setup -q -n %{name}-%{version}

# >> setup
# << setup

%build
# >> build pre
# << build pre

qmake FacebookForSOCAM.pro

make %{?jobs:-j%jobs}

# >> build post
# << build post

%install
rm -rf %{buildroot}
# >> install pre
# << install pre
#%qmake_install
make install INSTALL_ROOT=%{buildroot}

# >> install post
# << install post

#desktop-file-install --delete-original       \
#  --dir %{buildroot}%{_datadir}/applications             \
#   %{buildroot}%{_datadir}/applications/*.desktop

%post
# >> post

# << post

%files
%defattr(-,root,root,-)
%{_datadir}/applications/FacebookForSOCAM.desktop
/opt/FacebookForSOCAM


# >> files
# << files