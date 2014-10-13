#
# (c) Alex Gorbachenko <alex.gorbachenko@gmail.com>
#
# vim: set ts=2 sw=2 tw=0:
# vim: set expandtab:

package Rex::Virtualization::OVZ::option;

use strict;
use warnings;
use Carp;

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
            Rex::Logger::debug("Option \"$opt\" for 'vzctl set' was added");
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

    my $hostname = $name;

    my $command = _format_opts(%opt);

    my $ctid = i_run "vzlist -a -H -o ctid -h $hostname";

    if ( $ctid =~ /^\s*\d+?$/ ) {
        Rex::Logger::info("Seting options $command for VE $ctid");
        my $output = i_run "vzctl set $ctid --save $command";

        if ( $output =~ m/CT configuration saved/ ) {
            return $hostname;
        }
        else {
            croak("Setting options for VE $hostname ID $ctid failed with reason $output");
        }
    }

    else {
        return;
    }
}

1;

