#!/bin/sh

set -e  # Exit script immediately if any command fails.

if [ -z "$1" ]; then
  echo "usage: $0 <input.pcb>"
  exit 2
fi

set -u  # Fail on attempted use of undefined shell variables.

pcb_file="$1"
name=$(basename "$pcb_file" | sed s/.pcb//)
build_dir="./build/$name"

export_dir="$build_dir/export"
export_prefix="$export_dir/$name"

package_dir="$build_dir/package"
package_prefix="$package_dir/$name"

drill_input_1="$export_prefix.plated-drill.cnc"
drill_input_2="$export_prefix.unplated-drill.cnc"
drill_output="$package_prefix.txt"

zip_file="$build_dir/$name.zip"

set -x  # Echo commands as they are printed.

# Run 'pcb' to export the gerber files.
# Output files are of the form ./build/motor/export/motor.top.gbr
mkdir -p "$export_dir"
rm -f "$export_dir/*"
pcb -x gerber --gerberfile "$export_prefix" "$pcb_file"

# Rename files to match DirtyPCB's naming conventions.
mkdir -p "$package_dir"
rm -f "$package_dir/*"
mv "$export_prefix.bottom.gbr" "$package_prefix.gbl"
mv "$export_prefix.bottommask.gbr" "$package_prefix.gbs"
mv "$export_prefix.bottomsilk.gbr" "$package_prefix.gbo"
#mv "$export_prefix.fab.gbr"
mv "$export_prefix.group2.gbr" "$package_prefix.g1"
mv "$export_prefix.group3.gbr" "$package_prefix.g2"
mv "$export_prefix.outline.gbr" "$package_prefix.gml"
#mv "$export_prefix.plated-drill.cnc"
mv "$export_prefix.top.gbr" "$package_prefix.gtl"
mv "$export_prefix.topmask.gbr" "$package_prefix.gts"
#mv "$export_prefix.toppaste.gbr"
mv "$export_prefix.topsilk.gbr" "$package_prefix.gto"
#mv "$export_prefix.unplated-drill.cnc"

# Merge the two drill files (for plated and unplated holes).
gerbv --export drill --output "$drill_output" "$drill_input_1" "$drill_input_2"

# Copy the README, filling in the template fields.
sed "s/<NAME>/$name/" README.template > "$package_dir/README"

# Create zip file.
zip --recurse-paths --junk-paths "$zip_file" "$package_dir"
