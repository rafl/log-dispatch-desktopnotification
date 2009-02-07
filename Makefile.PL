use strict;
use warnings;
use inc::Module::Install;

name 'Log-Dispatch-DesktopNotification';
all_from 'lib/Log/Dispatch/DesktopNotification.pm';

requires 'Log::Dispatch';
requires 'Module::Load';
requires 'Module::Load::Conditional';
requires 'namespace::clean';

if ($^O eq 'darwin') {
    requires 'Log::Dispatch::MacGrowl';
}
else {
    if (!can_use('Log::Dispatch::Gtk2::Notify')
     && prompt('support GTK+ notifications?', 'yes') =~ /^y/i) {
        requires 'Log::Dispatch::Gtk2::Notify';
    }
}

WriteAll;
