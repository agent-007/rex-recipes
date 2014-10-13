#
# (c) Alex Gorbachenko <alex.gorbachenko@gmail.com>
#
# vim: set ts=2 sw=2 tw=0:
# vim: set expandtab:

package Rex::Virtualization::OVZ::list;

use strict;
use warnings;

use Rex::Logger;
use Rex::Helper::Run;

sub execute {

    my @domains;

    Rex::Logger::debug("Getting OVZ container list by vzlist");

    my ( $class, $arg1 ) = @_;

    if ( $arg1 eq "all" ) {
        @domains = i_run "vzlist -a -H";
        if ( $? != 0 ) {
            die("Error running vzlist -a -H");
        }
    }
    elsif ( $arg1 eq "running" ) {
        @domains = i_run "vzlist -H";
        if ( $? != 0 ) {
            die("Error running vzlist -H");
        }
    }
    elsif ( $arg1 eq "stopped" ) {
        @domains = i_run "vzlist -S -H";
        if ( $? != 0 ) {
            die("Error running vzlist -S -H");
        }
    }
    else {
        return;
    }

    return \@domains;

}

1;

