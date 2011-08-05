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
    requires 'Log::Dispatch::Growl';

    if (!(can_use('Cocoa::Growl') ||
          can_use('Growl::GNTP') ||
          can_use('Growl::NotifySend') ||
          can_use('Mac::Growl') ||
          can_use('Net::Growl') ||
          can_use('Net::GrowlClient'))) {
        if (prompt("It looks like you don't have a low-level module installed for Growl.\n" .
                  'Cocoa::Growl is usually a good one. Should I install Cocoa::Growl?', 'yes') =~ /^y/i) {
            requires 'Cocoa::Growl';
        }
    }
}
else {
    if (!can_use('Log::Dispatch::Gtk2::Notify')
     && prompt('support GTK+ notifications?', 'yes') =~ /^y/i) {
        requires 'Log::Dispatch::Gtk2::Notify';
    }
}

extra_tests;

WriteAll;
