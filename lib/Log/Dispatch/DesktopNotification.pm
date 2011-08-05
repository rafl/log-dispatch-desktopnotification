use strict;
use warnings;

package Log::Dispatch::DesktopNotification;

use Module::Load qw/load/;
use Module::Load::Conditional qw/can_load/;
use namespace::clean;

our $VERSION = '0.01';

=head1 NAME

Log::Dispatch::DesktopNotification - Send log messages to a desktop notification system

=head1 SYNOPSIS

    my $notify = Log::Dispatch::DesktopNotification->new(
        name      => 'notify',
        min_level => 'debug',
        app_name  => 'MyApp',
    );

=head1 METHODS

=head2 new

Creates a new Log::Dispatch output that can be used to graphically notify a
user on this system. Uses C<output_class> and calls C<new> on the returned
class, passing along all arguments.

=cut

sub new {
    my ($class, @args) = @_;
    return $class->output_class->new(@args);
}

=head2 output_class

Returns the name of a Log::Dispatch::Output class that's suitable to
graphically notify a user on the current system.

On MacOS X that'll be Log::Dispatch::MacGrowl. On other systems
Log::Dispatch::Gtk2::Notify will be returned if it's available and usable.
Otherwise Log::Dispatch::Null will be returned.

=cut

sub output_class {
    if ($^O eq 'darwin') {
        my $mod = 'Log::Dispatch::Growl';
        load $mod; return $mod;
    }

    if (can_load(modules => { Gtk2 => undef }) && Gtk2->init_check) {
        my $mod = 'Log::Dispatch::Gtk2::Notify';
        return $mod if can_load(modules => { $mod => undef });
    }

    my $mod = 'Log::Dispatch::Null';
    load $mod; return $mod;
}

=head1 BUGS

Currently only supports Mac OS X and systems on which notification-daemon is
available (most *N*Xes).

=head1 SEE ALSO

L<Log::Dispatch>, L<Log::Dispatch::Gtk2::Notify>, L<Log::Dispatch::MacGrowl>,
L<Log::Dispatch::Null>

=head1 AUTHOR

Florian Ragwitz E<lt>rafl@debian.orgE<gt>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Florian Ragwitz.

This is free software; you can redistribute it and/or modify it under the same
terms as perl itself.

=cut

1;
