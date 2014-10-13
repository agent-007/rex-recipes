#
# (c) Alex Gorbachenko <alex.gorbachenko@gmail.com>
#
# vim: set ts=2 sw=2 tw=0:
# vim: set expandtab:

package Rex::Virtualization::OVZ::create;

use Socket;
use Carp;

use Rex -base;
use strict;
use warnings;

use Rex::Logger;
use Rex::Helper::Run;

my $FUNC_MAP = {
    template => 'ostemplate',
    ip       => 'ipadd',
    conf     => 'config',
    space    => 'diskspace',
    memory   => 'ram',
    inodes   => 'diskinodes',
};

sub _format_opts {

    my %opt = @_;

    my ( $func, $cline );

    for my $opt ( keys %opt ) {
        my $val = $opt{$opt};

        # map function to command-line option
        unless ( exists $FUNC_MAP->{$opt} ) {
            Rex::Logger::debug("Option \"$opt\" for 'vzctl create' was added");
            $func = $opt;
        }
        else {
            $func = $FUNC_MAP->{$opt};
        }

        # build command string
        $cline .= '--' . $func . ' ' . $val . ' ';
    }
    return $cline;
}

sub execute {

    my ( $class, $name, %opt ) = @_;
    my $ctid     = delete $opt{ctid};
    my $hostname = $name;
    my $ip;

    # resolve ip for hostname if ip isn't set on task
    $ip = delete $opt{ip} if ( exists $opt{ip} );
    $ip = inet_ntoa( inet_aton("$hostname") ) unless ( exists $opt{ip} );

    my $command = _format_opts(%opt);

    my $id = i_run "vzlist -a -o ctid -H $ctid";

    if ( $id =~ m/not found/ ) {
        my $output =
          i_run "vzctl create $ctid $command --hostname $hostname --ipadd $ip";

        if ( $output =~ m/$ctid.conf/ ) {
            Rex::Logger::info("CTID $ctid with hostname $hostname was created");

            # return hostname as id
            return $hostname;

        }
        else {
            croak("VE $hostname ID $ctid creation failed with reason $output");
        }
    }
    elsif ( $id == $ctid ) {
        croak( 'CTID ' . $ctid . ' exists' );
    }
    else {
        return;
    }
}

1;

