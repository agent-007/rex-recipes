#
# (c) Alex Gorbachenko <alex.gorbachenko@gmail.com>
#
# vim: set ts=2 sw=2 tw=0:
# vim: set expandtab:

package Rex::Virtualization::OVZ::list;

use strict;
use warnings;
use Carp;

use Rex::Logger;
use Rex::Helper::Run;

sub execute {

    my ( $class, $arg1 ) = @_;
    
    my @domains = ();

    Rex::Logger::debug("Getting OVZ container list by vzlist");

    if ( $arg1 eq "all" ) {
        @domains = i_run "vzlist -a -H";
    }
    
    elsif ( $arg1 eq "running" ) {
        @domains = i_run "vzlist -H";
    }
    
    elsif ( $arg1 eq "stopped" ) {
        @domains = i_run "vzlist -S -H";
    }
    
    else {
        croak("Unknown option $arg1. Valid options: all, running, stopped");
    }
        
    if ( $? != 0 ) {
        croak("Error running vzlist. Reason: @domains");
    }

    return \@domains;

}

1;

