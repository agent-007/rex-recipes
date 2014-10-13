#
# (c) Alex Gorbachenko <alex.gorbachenko@gmail.com>
#
# vim: set ts=2 sw=2 tw=0:
# vim: set expandtab:

=head1 NAME

Rex::Virtualization::OVZ - OVZ Virtualization Module

=head1 DESCRIPTION

With this module you can manage OVZ.

=head1 SYNOPSIS

 use Rex::Commands::Virtualization;
   
 set virtualization => "OVZ";
   
 use Data::Dumper;  
  
 print Dumper vm list => "all";
 print Dumper vm list => "running";
 
 print Dumper vm info => "vm01";
   
 vm destroy => "vm01";
   
 vm delete => "vm01"; 
    
 vm start => "vm01";
   
 vm shutdown => "vm01";
   
 vm reboot => "vm01";
   
 # creating a vm 
 my $id = vm create => "vm01.domain.tld",
    ctid => '01',
    config => "my.ovz.conf",
    template => "centos6",
    diskspace => "1G",
    ip => "10.0.0.1",

=cut

package Rex::Virtualization::OVZ;
{
    $Rex::Virtualization::OVZ::VERSION = '0.53.1';
}

use strict;
use warnings;

use Rex -base;

use Rex::Virtualization::Base;
use base qw(Rex::Virtualization::Base);

sub new {
    my $that  = shift;
    my $proto = ref($that) || $that;
    my $self  = {@_};

    bless( $self, $proto );

    return $self;
}

Rex::Virtualization->register_vm_provider( OVZ => __PACKAGE__ );

1;
