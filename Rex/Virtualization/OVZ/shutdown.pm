#
# (c) Alex Gorbachenko <alex.gorbachenko@gmail.com>
#
# vim: set ts=2 sw=2 tw=0:
# vim: set expandtab:

package Rex::Virtualization::OVZ::shutdown;

use strict;
use warnings;
use Carp;

use Rex::Logger;
use Rex::Helper::Run;

sub execute {

    my ( $class, $name, %opt ) = @_;
    my $hostname = $name;

    my $ctid = i_run "vzlist -a -H -o ctid -h $hostname";

    if ( $ctid =~ /^\s*\d+?$/ ) {
        Rex::Logger::info("Stopping VE $ctid with hostname $hostname");
        my $output = i_run "vzctl stop $ctid";

        if (   $output =~ m/Container was stopped/
            or $output =~ m/container is not running/ )
        {
            return $hostname;
        }
        elsif ($output) {
            croak("VE $hostname ID $ctid shutdown failed with reason $output");
        }
    }
    else {
        return;
    }
}

1;

