add_python_extension(array SOURCES arraymodule.c)
add_python_extension(audioop SOURCES audioop.c)
add_python_extension(_bisect SOURCES _bisectmodule.c)
add_python_extension(cmath SOURCES _math.c cmathmodule.c )##LIBRARIES m)
add_python_extension(_codecs_cn SOURCES cjkcodecs/_codecs_cn.c)
add_python_extension(_codecs_hk SOURCES cjkcodecs/_codecs_hk.c)
add_python_extension(_codecs_iso2022 SOURCES cjkcodecs/_codecs_iso2022.c)
add_python_extension(_codecs_jp SOURCES cjkcodecs/_codecs_jp.c)
add_python_extension(_codecs_kr SOURCES cjkcodecs/_codecs_kr.c)
add_python_extension(_codecs_tw SOURCES cjkcodecs/_codecs_tw.c)
add_python_extension(_collections SOURCES _collectionsmodule.c)
add_python_extension(cPickle SOURCES cPickle.c)
add_python_extension(crypt SOURCES cryptmodule.c LIBRARIES crypt)
add_python_extension(cStringIO SOURCES cStringIO.c)
add_python_extension(_csv SOURCES _csv.c)
add_python_extension(_ctypes_test SOURCES _ctypes/_ctypes_test.c)
#add_python_extension(datetime SOURCES datetimemodule.c timemodule.c LIBRARIES m)
add_python_extension(_functools SOURCES _functoolsmodule.c)
add_python_extension(future_builtins SOURCES future_builtins.c)
add_python_extension(_heapq SOURCES _heapqmodule.c)
add_python_extension(_hotshot SOURCES _hotshot.c)
add_python_extension(_io BUILTIN SOURCES
    _io/_iomodule.c
    _io/bufferedio.c
    _io/bytesio.c
    _io/fileio.c
    _io/iobase.c
    _io/stringio.c
    _io/textio.c
)
add_python_extension(itertools SOURCES itertoolsmodule.c)
add_python_extension(_json SOURCES _json.c)
add_python_extension(_locale SOURCES _localemodule.c)
add_python_extension(_lsprof SOURCES _lsprof.c rotatingtree.c)
add_python_extension(math SOURCES _math.c mathmodule.c)
add_python_extension(mmap SOURCES mmapmodule.c)
add_python_extension(_multibytecodec SOURCES cjkcodecs/multibytecodec.c)
add_python_extension(operator SOURCES operator.c)
add_python_extension(parser SOURCES parsermodule.c)
add_python_extension(_random SOURCES _randommodule.c)
add_python_extension(strop SOURCES stropmodule.c)
add_python_extension(_struct SOURCES _struct.c)
add_python_extension(_testcapi SOURCES _testcapimodule.c)
#add_python_extension(time SOURCES timemodule.c LIBRARIES m)
add_python_extension(unicodedata SOURCES unicodedata.c)

# UNIX-only extensions
add_python_extension(fcntl REQUIRES UNIX SOURCES fcntlmodule.c)
add_python_extension(grp REQUIRES UNIX SOURCES grpmodule.c)
add_python_extension(nis REQUIRES UNIX SOURCES nismodule.c LIBRARIES nsl)
add_python_extension(posix REQUIRES UNIX BUILTIN SOURCES posixmodule.c)
add_python_extension(pwd REQUIRES UNIX BUILTIN SOURCES pwdmodule.c)
add_python_extension(resource REQUIRES UNIX SOURCES resource.c)
add_python_extension(spwd REQUIRES UNIX SOURCES spwdmodule.c)
add_python_extension(syslog REQUIRES UNIX SOURCES syslogmodule.c)
add_python_extension(termios REQUIRES UNIX SOURCES termios.c)

# Linux-only extensions
add_python_extension(linuxaudiodev REQUIRES LINUX SOURCES linuxaudiodev.c)
add_python_extension(ossaudiodev REQUIRES LINUX SOURCES ossaudiodev.c)

# Windows-only extensions
add_python_extension(nt REQUIRES WIN32 BUILTIN SOURCES posixmodule.c)
add_python_extension(winsound REQUIRES WIN32 SOURCES ../PC/winsound.c LIBRARIES winmm
)

# Multiprocessing is different on unix and windows
if(UNIX)
    add_python_extension(_multiprocessing
        SOURCES _multiprocessing/multiprocessing.c
                _multiprocessing/semaphore.c
                _multiprocessing/socket_connection.c
    )
elseif(WIN32)
    add_python_extension(_multiprocessing
        SOURCES _multiprocessing/multiprocessing.c
                _multiprocessing/semaphore.c
                _multiprocessing/pipe_connection.c
                _multiprocessing/socket_connection.c
                _multiprocessing/win32_functions.c
        LIBRARIES ws2_32
    )
endif(UNIX)

# Select needs winsock on Windows
if(WIN32)
    add_python_extension(select SOURCES selectmodule.c LIBRARIES ws2_32)
else(WIN32)
    add_python_extension(select SOURCES selectmodule.c)
endif(WIN32)

# Socket is different on Windows
if(WIN32)
    add_python_extension(_socket
        SOURCES socketmodule.c
        DEFINITIONS EAI_ADDRFAMILY
                    HAVE_SOCKADDR_STORAGE
                    HAVE_ADDRINFO
        LIBRARIES ws2_32
    )
else(WIN32)
    add_python_extension(_socket SOURCES socketmodule.c)
endif(WIN32)

# ctypes is different on Windows
if(WIN32)
    if(CMAKE_CL_64)
        set(FFIMSVC_WIN_SRC win64.asm)
    else(CMAKE_CL_64)
        set(FFIMSVC_WIN_SRC win32.c)
    endif(CMAKE_CL_64)
    add_python_extension(_ctypes
        SOURCES _ctypes/_ctypes.c
                _ctypes/callbacks.c
                _ctypes/callproc.c
                _ctypes/cfield.c
                _ctypes/libffi_msvc/ffi.c
                _ctypes/malloc_closure.c
                _ctypes/libffi_msvc/prep_cif.c
                _ctypes/stgdict.c
                _ctypes/libffi_msvc/${FFIMSVC_WIN_SRC}
        INCLUDEDIRS ${CMAKE_SOURCE_DIR}/Modules/_ctypes/libffi_msvc
                    ${CMAKE_SOURCE_DIR}/Modules/_ctypes/
    )
else(WIN32)
    add_python_extension(_ctypes
        SOURCES _ctypes/_ctypes.c
                _ctypes/callbacks.c
                _ctypes/callproc.c
                _ctypes/cfield.c
                _ctypes/libffi/src/closures.c
                _ctypes/libffi/src/dlmalloc.c
                _ctypes/libffi/src/x86/ffi.c
                _ctypes/libffi/src/x86/ffi64.c
                _ctypes/libffi/src/prep_cif.c
                _ctypes/stgdict.c
                _ctypes/libffi/src/x86/sysv.S
                _ctypes/libffi/src/x86/unix64.S
        INCLUDEDIRS ${CMAKE_SOURCE_DIR}/Modules/_ctypes/libffi/src/x86
                    ${CMAKE_SOURCE_DIR}/Modules/_ctypes/libffi/include
    )
endif(WIN32)


# Build expat using the system expat if it's installed, otherwise use the
# builtin version.
if(EXPAT_FOUND)
    add_python_extension(pyexpat
        SOURCES pyexpat.c
        LIBRARIES ${EXPAT_LIBRARIES}
        INCLUDEDIRS ${EXPAT_INCLUDE_DIRS}
    )
    add_python_extension(_elementtree
        SOURCES _elementtree.c
        LIBRARIES ${EXPAT_LIBRARIES}
        INCLUDEDIRS ${EXPAT_INCLUDE_DIRS}
    )
else(EXPAT_FOUND)
    add_python_extension(pyexpat
        SOURCES pyexpat.c
                expat/xmlparse.c
                expat/xmlrole.c
                expat/xmltok.c
        DEFINITIONS HAVE_EXPAT_CONFIG_H=1
        INCLUDEDIRS ${CMAKE_SOURCE_DIR}/Modules/expat
    )
    add_python_extension(_elementtree
        SOURCES _elementtree.c
        DEFINITIONS HAVE_EXPAT_CONFIG_H=1 USE_PYEXPAT_CAPI
        INCLUDEDIRS ${CMAKE_SOURCE_DIR}/Modules/expat
    )
endif(EXPAT_FOUND)

# If openssl is NOT available then build some other hash implementations
if(OPENSSL_FOUND)
    set(OPENSSL_NOT_FOUND OFF)
else(OPENSSL_FOUND)
    set(OPENSSL_NOT_FOUND ON)
endif(OPENSSL_FOUND)

add_python_extension(_md5 REQUIRES OPENSSL_NOT_FOUND SOURCES md5.c md5module.c)
add_python_extension(_sha REQUIRES OPENSSL_NOT_FOUND SOURCES shamodule.c)
add_python_extension(_sha256 REQUIRES OPENSSL_NOT_FOUND SOURCES sha256module.c)
add_python_extension(_sha512 REQUIRES OPENSSL_NOT_FOUND SOURCES sha512module.c)

# Extensions that depend on other libraries
add_python_extension(binascii
    REQUIRES ZLIB_FOUND
    SOURCES binascii.c
    DEFINITIONS USE_ZLIB_CRC32
    LIBRARIES ${ZLIB_LIBRARIES}
    INCLUDEDIRS ${ZLIB_INCLUDE_DIRS}
)
add_python_extension(_bsddb
    REQUIRES DB_INCLUDE_PATH DB_LIBRARIES
    SOURCES _bsddb.c
    LIBRARIES ${DB_LIBRARIES}
    INCLUDEDIRS ${DB_INCLUDE_PATH}
)
add_python_extension(bz2
    REQUIRES BZIP2_FOUND
    SOURCES bz2module.c
    LIBRARIES ${BZIP2_LIBRARIES}
)
add_python_extension(_curses_panel
    REQUIRES CURSES_FOUND
    SOURCES _curses_panel.c
    LIBRARIES ${CURSES_LIBRARIES}
)
add_python_extension(_curses
    REQUIRES CURSES_FOUND
    SOURCES _cursesmodule.c
    LIBRARIES ${CURSES_LIBRARIES}
)
add_python_extension(dbm
    REQUIRES GDBM_INCLUDE_PATH GDBM_LIBRARY GDBM_COMPAT_LIBRARY
    SOURCES dbmmodule.c
    DEFINITIONS HAVE_GDBM_DASH_NDBM_H
    LIBRARIES ${GDBM_LIBRARY} ${GDBM_COMPAT_LIBRARY}
    INCLUDEDIRS ${GDBM_INCLUDE_PATH}
)
add_python_extension(gdbm
    REQUIRES GDBM_INCLUDE_PATH GDBM_LIBRARY GDBM_COMPAT_LIBRARY
    SOURCES gdbmmodule.c
    DEFINITIONS HAVE_GDBM_DASH_NDBM_H
    LIBRARIES ${GDBM_LIBRARY}
    INCLUDEDIRS ${GDBM_INCLUDE_PATH}
)
add_python_extension(_hashlib
    REQUIRES OPENSSL_FOUND
    SOURCES _hashopenssl.c
    LIBRARIES ${OPENSSL_LIBRARIES}
)
add_python_extension(readline
    REQUIRES READLINE_INCLUDE_PATH READLINE_LIBRARY CURSES_FOUND
    SOURCES readline.c
    LIBRARIES ${READLINE_LIBRARY} ${CURSES_LIBRARIES}
    INCLUDEDIRS ${READLINE_INCLUDE_PATH}
)
add_python_extension(_sqlite3
    REQUIRES SQLITE3_INCLUDE_PATH SQLITE3_LIBRARY
    SOURCES _sqlite/cache.c
            _sqlite/connection.c
            _sqlite/cursor.c
            _sqlite/microprotocols.c
            _sqlite/module.c
            _sqlite/prepare_protocol.c
            _sqlite/row.c
            _sqlite/statement.c
            _sqlite/util.c
    DEFINITIONS MODULE_NAME="sqlite3"
    INCLUDEDIRS ${SQLITE3_INCLUDE_PATH}
    LIBRARIES ${SQLITE3_LIBRARY}
)
add_python_extension(_ssl
    REQUIRES OPENSSL_FOUND
    SOURCES _ssl.c
    LIBRARIES ${OPENSSL_LIBRARIES}
)
add_python_extension(_tkinter
    REQUIRES TK_FOUND TCL_FOUND
    SOURCES _tkinter.c tkappinit.c
    DEFINITIONS WITH_APPINIT=1
    LIBRARIES ${TCL_LIBRARY} ${TK_LIBRARY}
    INCLUDEDIRS ${TCL_INCLUDE_PATH} ${TK_INCLUDE_PATH}
)
add_python_extension(zlib
    REQUIRES ZLIB_FOUND
    SOURCES zlibmodule.c
    LIBRARIES ${ZLIB_LIBRARIES}
)
