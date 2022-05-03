cat << EOF | sudo debconf-set-selections
postfix postfix/mailname        string  drjda.cf
postfix postfix/relayhost       string
postfix postfix/tlsmgr_upgrade_warning  boolean
postfix postfix/newaliases      boolean false
postfix postfix/sqlite_warning  boolean
postfix postfix/mydomain_warning        boolean
postfix postfix/not_configured  error
postfix postfix/bad_recipient_delimiter error
postfix postfix/mynetworks      string  127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128
postfix postfix/rfc1035_violation       boolean false
postfix postfix/mailbox_limit   string  0
postfix postfix/recipient_delim string  +
postfix postfix/compat_conversion_warning       boolean true
postfix postfix/procmail        boolean false
postfix postfix/relay_restrictions_warning      boolean
postfix postfix/destinations    string  $myhostname, drjda.cf, ubuntucloud01, localhost.localdomain, localhost
postfix postfix/chattr  boolean false
postfix postfix/dynamicmaps_conversion_warning  boolean
postfix postfix/main_cf_conversion_warning      boolean true
postfix postfix/protocols       select  all
postfix postfix/kernel_version_warning  boolean
postfix postfix/main_mailer_type        select  Internet Site
postfix postfix/retry_upgrade_warning   boolean
postfix postfix/root_address    string
postfix postfix/lmtp_retired_warning    boolean true
EOF
