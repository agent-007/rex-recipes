#
# (c) Alex Gorbachenko <alex.gorbachenko@gmail.com>
#
# vim: set ts=2 sw=2 tw=0:
# vim: set expandtab:

package Rex::Virtualization::OVZ::info;

use strict;
use warnings;
use Carp;

use Rex::Logger;
use Rex::Helper::Run;

sub execute {

    my ( $class, $name, %opt ) = @_;
    my $hostname = $name;

    my $ctid = i_run "vzlist -H -o ctid -h $hostname";

    $ctid =~ s/^\s+|\s+$//g;

    Rex::Logger::info("Show information about VE $hostname");

    if ( !$ctid ) {
        Rex::Logger::info(
            "No info about VE $hostname. VE was stopped or doesn't exists");
        return;
    }

    my $output = i_run "cat /proc/bc/$ctid/resources";

    return $output;

}

1;

