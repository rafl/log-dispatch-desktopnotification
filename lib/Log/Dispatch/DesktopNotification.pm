use strict;
use warnings;

package Log::Dispatch::DesktopNotification;

use Module::Load qw/load/;
use Module::Load::Conditional qw/can_load/;
use namespace::clean;

sub new {
    my ($class, @args) = @_;
    return $class->output_class->new(@args);
}

sub output_class {
    if ($^O eq 'darwin') {
        my $mod = 'Log::Dispatch::MacGrowl';
        load $mod; return $mod;
    }

    if (can_load(modules => { Gtk2 => undef }) && Gtk2->init_check) {
        my $mod = 'Log::Dispatch::Gtk2::Notify';
        return $mod if can_load(modules => { $mod => undef });
    }

    my $mod = 'Log::Dispatch::Null';
    load $mod; return $mod;
}

1;
