export JAVA_HOME="/usr/java/jdk1.7.0_03"
export JAVA_LIB="$JAVA_HOME/lib"
export JRE_HOME="$JAVA_HOME/jre"
export JRE_LIB="$JRE_HOME/lib"
export PATH="/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/sbin:/opt/openoffice.org3/program:$JAVA_HOME/bin:$PATH"
export CLASSPATH=".:./*:$JAVA_LIB:$JAVA_LIB/*:$JRE_LIB:$JRE_LIB/*:/usr/lib64/java/lib:/usr/lib64/java/lib/*"
export PKG_CONFIG_PATH="/usr/lib64/pkgconfig:/usr/local/lib64/pkgconfig:/usr/local/lib/pkgconfig:/usr/share/pkgconfig:/usr/lib/pkgconfig:$PKG_CONFIG_PATH"
export ORACLE_HOME="/usr/local/lib/instantclient"
export LD_LIBRARY_PATH="$ORACLE_HOME:$LD_LIBRARY_PATH"
