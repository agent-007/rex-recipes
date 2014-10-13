#
# (c) Alex Gorbachenko <alex.gorbachenko@gmail.com>
#
# vim: set ts=2 sw=2 tw=0:
# vim: set expandtab:

package Rex::Virtualization::OVZ::start;

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
        Rex::Logger::info("Starting VE $ctid with hostname $hostname");
        my $output = i_run "vzctl start $ctid";

        if ( $output =~ m/start in progress/ or $output =~ m/already running/ )
        {
            return $hostname;
        }
        elsif ( $output =~ m/Error:/ ) {
            croak("VE $hostname ID $ctid start failed with reason $output");
        }
    }
    else {
        return;
    }
}

1;

