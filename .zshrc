# PYENV
ARCH=`arch`
if [[ "${ARCH}"  == "arm64" ]]; then
    export PYENV_ROOT="${HOME}/.pyenv/arm64"
else
    export PYENV_ROOT="${HOME}/.pyenv/rosetta"
fi
PYENV_BIN="$PYENV_ROOT/bin"
export PYENV_SHELL=zsh
export PYENV_ROOT=$(pyenv root)
export PYENV_VERSION=$(pyenv version-name)
export PYTHONPATH=$PYENV_ROOT/shims


SDK_PATH="$(xcrun --show-sdk-path)"
export CPATH="${SDK_PATH}/usr/include"
export CFLAGS="-I${SDK_PATH}/usr/include/sasl $CFLAGS"
export CFLAGS="-I${SDK_PATH}/usr/include $CFLAGS"
export LDFLAGS="-L${SDK_PATH}/usr/lib $LDFLAGS"

if [[ "${ARCH}"  == "arm64" ]]; then
    PREFIX="/opt/homebrew/opt"
	eval $(/opt/homebrew/bin/brew shellenv);
else
    PREFIX="/usr/local/opt"
	eval $(/usr/local/bin/brew shellenv);
fi

ZLIB="${PREFIX}/zlib"
BZIP2="${PREFIX}/bzip2"
READLINE="${PREFIX}/readline"
SQLITE="${PREFIX}/sqlite"    
OPENSSL="${PREFIX}/openssl@1.1"
TCLTK="${PREFIX}/tcl-tk"
PGSQL="${PREFIX}/postgresql@10"
LIBS=('ZLIB' 'BZIP2' 'READLINE' 'SQLITE' 'OPENSSL' 'PGSQL' 'TCLTK')

for LIB in $LIBS; do

	BINDIR="${(P)LIB}/bin"
	if [ -d "${BINDIR}" ]; then
		export PATH="${BINDIR}:$PATH"
	fi

	LIBDIR="${(P)LIB}/lib"
	if [ -d "${LIBDIR}" ]; then
		export LDFLAGS="-L${LIBDIR} $LDFLAGS"
		export DYLD_LIBRARY_PATH="${LIBDIR}:$DYLD_LIBRARY_PATH"
		PKGCFGDIR="${LIBDIR}/pkgconfig"
		if [ -d "${PKGCFGDIR}" ]; then
			export PKG_CONFIG_PATH="${PKGCFGDIR} $PKG_CONFIG_PATH"
		fi
	fi

	INCDIR="${(P)LIB}/include"
	if [ -d "${INCDIR}" ]; then
		export CFLAGS="-I${INCDIR} $CFLAGS" 
	fi

done

export CPPFLAGS="${CFLAGS}"
export CXXFLAGS="${CFLAGS}"

export PYTHON_CONFIGURE_OPTS="--enable-framework"
export PYTHON_CONFIGURE_OPTS="--with-openssl=$(brew --prefix openssl) ${PYTHON_CONFIGURE_OPTS}"
export PYTHON_CONFIGURE_OPTS="--with-tcltk-includes='-I$(brew --prefix tcl-tk)/include' ${PYTHON_CONFIGURE_OPTS}"
export PYTHON_CONFIGURE_OPTS="--with-tcltk-libs='-L$(brew --prefix tcl-tk)/lib -ltcl8.6 -ltk8.6' ${PYTHON_CONFIGURE_OPTS}"


eval "$(pyenv init -)"
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
