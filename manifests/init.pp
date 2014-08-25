# Class: Drupal
#
# Installs Drupal
class drupal (
  $install_location,
  $tag          = '7.23',
  $account_mail = 'admin@example.com',
  $account_name = 'admin',
  $account_pass = 'test123',
  $clean_url    = 1,
  $db_type      = 'mysql',
  $db_su        = false,
  $db_su_pw     = false,
  $db_prefix    = false,
  $db_user,
  $db_pass,
  $db_host      = 'localhost',
  $db_port      = '3306',
  $db_name      = 'drupal',
  $locale       = 'en-US',
  $site_mail    = 'admin@example.com',
  $site_name    = 'Site-Install',
  $sites_subdir = 'default'
) {

  # Clone Drupal
  vcsrepo { $install_location:
    ensure   => present,
    provider => git,
    source   => 'https://github.com/drupal/drupal.git',
    revision => $tag,
  }

  # Clone Drush
  vcsrepo { '/home/vagrant/drush':
    ensure   => present,
    provider => git,
    source   => 'http://git.drupal.org/project/drush.git',
    revision => '8.x-6.x',
    require  => Vcsrepo[$install_location],
  }

  # Make Drush executable
  file { '/home/vagrant/drush/drush.php':
    ensure  => 'present',
    mode    => 'a+X,ug+w',
    require => Vcsrepo['/home/vagrant/drush'],
  }

  # Make Drush system-wide
  file { '/usr/local/bin/drush':
    ensure  => 'link',
    target  => '/home/vagrant/drush/drush.php',
    require => File['/home/vagrant/drush/drush.php'],
  }
}
