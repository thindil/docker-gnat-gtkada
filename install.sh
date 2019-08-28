#!/bin/sh

current_dir="`/bin/pwd`"

# Checks for the presence of a Gtk+ binary package in gtk-bin/
check_gtk_bin() {
   gtk_bin_dir="`pwd`/gtk-bin"
   if test ! -d "$gtk_bin_dir"; then
      echo "Gtk+ binary package not found. Aborting the installation process."
      exit
   fi
}

## Read the base directory (absolute path name)
## Sets the variable  $basedir
ask_basedir() {
   clear
   default_dir="`type gnatmake 2>/dev/null| cut -d' ' -f3`"
   default_dir="`dirname \"$default_dir\" 2>/dev/null`"

   if [ "$default_dir" != "" -a "$default_dir" != "." -a "$default_dir" != "/usr/bin" ]; then
      default_dir="`cd "$default_dir/.."; pwd`"
   else
     default_dir=/opt/gtkada
   fi

   while [ "$basedir" = "" ]; do
      if echo "$basedir" | egrep "[ ]" >/dev/null; then
         echo "GtkAda cannot be installed in a path that contains spaces."
         echo "Please enter another directory."
         basedir=""
      else
         if [ "$basedir" = "" ]; then
            basedir="$default_dir"
         fi
         if echo "$basedir" | egrep "^[/~]" >/dev/null; then
            true
         else
            basedir="`pwd`"/"$basedir"
         fi
      fi
   done

   # Suppress the final / in basedir
   basedir="`echo "$basedir" | sed -e 's/\/$//'`"

}

##################################
## Do the actual installation
##################################

install_binaries() {

  echo "Copying the Gtk+ binaries"

  cp -r "$gtk_bin_dir"/* "$basedir"

  echo "Setting up the environment"
  eval `"$basedir"/bin/gtkada-env.sh --print-only`

  echo "Compiling GtkAda"
  ./configure --prefix="$basedir" --with-GL=no && make all install 2>&1 | \
     tee install.log

  # Test for the presence of a gtkada.gpr as check that the install succeeded
  if [ ! -f "$basedir/lib/gnat/gtkada.gpr" ]; then
     echo ""
     echo "An error occurred. Please see install.log."""
     exit 1
  fi
}

## Main program

check_gtk_bin
ask_basedir
install_binaries

