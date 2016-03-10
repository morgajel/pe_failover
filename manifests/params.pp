class pe_failover::params {
  $rsync_user                    = 'pe-transfer'
  $rsync_user_home               = "/home/${rsync_user}"
  $rsync_user_ssh_id             = "${rsync_user_home}/.ssh/pe_failover_id_rsa"
  $rsync_ssl_dir                 = '/etc/puppetlabs/puppet/ssl/'
  $rsync_command                 = 'rsync -au --delete'
  $pe_failover_directory         = '/opt/pe_failover'
  $script_directory              = "${pe_failover_directory}/scripts"
  $pg_bin_directory              = '/opt/puppetlabs/server/bin'
  $dump_path                     = "${pe_failover_directory}/dumps"
  $nc_dump_path                  = "${pe_failover_directory}/nc_dumps"
  $cert_dump_path                = "${pe_failover_directory}/cert_dumps"
  $incron_ssl_condition          = '/etc/puppetlabs/puppet/ssl/ca/signed IN_CLOSE_WRITE,IN_DELETE'
  $incron_passive_ssl_condition  = "${cert_dump_path}/latest/ca/signed IN_CLOSE_WRITE,IN_DELETE"
  $pg_dump_command               = "${pg_bin_directory}/pg_dump"
  $timestamp_command             = '`/bin/date +"%Y-%m-%d-%H%M"`'
  $md5sum_command                = 'md5sum'
  $pe_bkup_dbs                   = ['pe-rbac']
  $hour                          = '*'
  $minute                        = '10'
  $monthday                      = '*'
  $restore_hour                  = '*'
  $restore_db_minute             = '3'
  $restore_nc_minute             = '0'
  $restore_monthday              = '*'

  $pe_users = {
    'pe-postgres'               =>
        {
          'description' => 'Puppet Enterprise PostgreSQL Server',
          'home'        => '/opt/puppetlabs/server/data/postgresql',
          'shell'       => '/sbin/nologin',
        },
    'pe-orchestration-services' =>
        {
          'description' => 'pe-orchestration-services daemon',
          'home'        => '/opt/puppetlabs/server/data/orchestration-services',
          'shell'       => '/sbin/nologin',
        },
    'pe-console-services'       =>
        {
          'description' => 'pe-console-services daemon',
          'home'        => '/opt/puppetlabs/server/data/console-services',
          'shell'       => '/sbin/nologin',
        },
    'pe-puppetdb'               =>
        {
          'description' => 'pe-puppetdb daemon',
          'home'        => '/opt/puppetlabs/server/data/puppetdb',
          'shell'       => '/sbin/nologin',
        },
    'pe-puppet'                =>
        {
          'description' => 'pe-puppetserver daemon',
          'home'        => '/opt/puppetlabs/server/data/puppetserver',
          'shell'       => '/sbin/nologin',
        },
    'pe-webserver'             =>
        {
          'description' => 'Puppet Enterprise Webserver User',
          'home'        => '/var/cache/puppetlabs/nginx',
          'shell'       => '/sbin/nologin',
        },
    'pe-activemq'              =>
        {
          'description' => 'Puppet Enterprise Apache Activemq',
          'home'        => '/opt/puppetlabs/server/data/activemq',
          'shell'       => '/sbin/nologin',
        },
    }
}
