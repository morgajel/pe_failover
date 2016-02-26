class pe_failover::passive (
  String $auth_key,
  String $rsync_user            = $pe_failover::params::rsync_user,
  Hash $pe_users                = $pe_failover::params::pe_users,
  String $pe_failover_directory = $pe_failover::params::pe_failover_directory,
  String $script_directory      = $pe_failover::params::script_directory,
  String $dump_path             = $pe_failover::params::dump_path,
  String $nc_dump_path          = $pe_failover::params::nc_dump_path,
  String $restore_nc_minute     = $pe_failover::params::restore_nc_minute,
  String $restore_db_minute     = $pe_failover::params::restore_db_minute,
  String $restore_hour          = $pe_failover::params::restore_hour,
  String $restore_monthday      = $pe_failover::params::restore_monthday,
) inherits pe_failover::params{

  include ::pe_failover

  # Setup PE Users
  $pe_users.keys.each |$pe_user| {
    user{$pe_user:
      comment    => $pe_users[$pe_user]['description'],
      home       => $pe_users[$pe_user]['home'],
      managehome => false,
      shell      => $pe_users[$pe_user]['shell'],
    }
  }

  # Setup auth keys
  if $auth_key != '' {
    ssh_authorized_key{"${rsync_user}@primary":
      user => $rsync_user,
      type => 'ssh-rsa',
      key  => $auth_key,
    }
  }else{
    fail('There is no value for auth_key parameter!')
  }

  # Create Required CA directories
  $pe_dirs = [
    '/etc/puppetlabs',
    '/etc/puppetlabs/puppet',
  ]

  file{$pe_dirs:
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => '0755',
  }

  # Create DB Restore Script
  file { 'db_rest_script':
    ensure  => file,
    path    => "${script_directory}/rest_dbs.sh",
    mode    => '0755',
    content => template('pe_failover/rest_dbs.sh.erb'),
  }

  # Create the cron job to rest all present db dumps 
  cron { 'rest_dbs_cron':
    ensure   => present,
    command  => "${script_directory}/rest_dbs.sh",
    user     => 'root',
    minute   => $restore_db_minute,
    hour     => $restore_hour,
    monthday => $restore_monthday,
  }

  # Create NC Restore Script
  file { 'nc_rest_script':
    ensure  => file,
    path    => "${script_directory}/nc_rest.sh",
    mode    => '0755',
    content => template('pe_failover/nc_rest.sh.erb'),
  }

  # Create the cron job to rest all present db dumps 
  cron { 'rest_nc_cron':
    ensure   => present,
    command  => "${script_directory}/nc_rest.sh",
    user     => 'root',
    minute   => $restore_nc_minute,
    hour     => $restore_hour,
    monthday => $restore_monthday,
  }

}
