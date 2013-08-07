#
# Cookbook Name:: osl-postgresql
# Recipe:: legacy
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

hba_data = [
  node.default['postgresql']['pg_hba'],
  {:type => 'host', :db => 'fsslgy_redmine', :user => 'fsslgy_redmine', :addr => '140.211.15.250/32', :method => 'md5'},
  {:type => 'host', :db => 'nagios', :user => 'nagios', :addr => '140.211.166.139/32', :method => 'md5'},
  {:type => 'host', :db => 'all', :user => 'backup', :addr => '140.211.15.32/32', :method => 'md5'},
  {:type => 'host', :db => 'template1', :user => 'all', :addr => '140.211.166.148/32', :method => 'md5'},
  {:type => 'host', :db => 'sameuser', :user => 'all', :addr => '140.211.166.148/32', :method => 'md5'},
  {:type => 'host', :db => 'all', :user => '+admins', :addr => '140.211.166.148/32', :method => 'md5'},
  {:type => 'host', :db => 'orvsd_mahara', :user => 'orvsd_mahara_rw', :addr => '140.211.167.134/32', :method => 'md5'},
  {:type => 'host', :db => '@dblist/bigleaf_rw', :user => 'bigleaf_rw', :addr => '140.211.166.56/32', :method => 'md5'},
  {:type => 'host', :db => 'libre_trac', :user => 'libre_rw', :addr => '140.211.166.56/32', :method => 'md5'},
  {:type => 'host', :db => 'eese_trac', :user => 'eese_rw', :addr => '140.211.166.56/32', :method => 'md5'},
  {:type => 'host', :db => 'replicant_trac', :user => 'replicant_rw', :addr => '140.211.166.56/32', :method => 'md5'},
  {:type => 'host', :db => 'deluge_trac', :user => 'deluge_rw', :addr => '140.211.166.66/32', :method => 'md5'},
  {:type => 'host', :db => 'openmrs_trac', :user => 'openmrs_rw', :addr => '140.211.167.208/32', :method => 'md5'},
  {:type => 'host', :db => 'openmrs_trac', :user => 'openmrs_rw', :addr => '140.211.167.227/32', :method => 'md5'},
  {:type => 'host', :db => 'openmrs_trac', :user => 'openmrs_rw', :addr => '140.211.167.237/32', :method => 'md5'},
  {:type => 'host', :db => 'parrot_languages_trac', :user => 'parrotvm_rw', :addr => '140.211.167.206/32', :method => 'md5'},
  {:type => 'host', :db => 'parrot_trac', :user => 'parrotvm_rw', :addr => '140.211.167.206/32', :method => 'md5'},
  {:type => 'host', :db => 'parrot_test_trac', :user => 'parrotvm_rw', :addr => '140.211.167.206/32', :method => 'md5'},
  {:type => 'host', :db => 'efs_trac', :user => 'efs_rw', :addr => '140.211.167.249/32', :method => 'md5'},
  {:type => 'host', :db => 'topaz_trac', :user => 'topaz_rw', :addr => '140.211.15.51/32', :method => 'md5'},
  {:type => 'host', :db => 'mulgara_trac', :user => 'mulgara_rw', :addr => '140.211.15.51/32', :method => 'md5'},
  {:type => 'host', :db => 'opensis', :user => 'opensis', :addr => '140.211.15.31/32', :method => 'md5'},
  {:type => 'host', :db => 'bacula', :user => 'bacula', :addr => '140.211.15.32/32', :method => 'md5'},
  {:type => 'host', :db => 'plone_trac', :user => 'plone_trac_rw', :addr => '140.211.15.105/32', :method => 'md5'},
  {:type => 'host', :db => 'plone_trac', :user => 'plone_trac_rw', :addr => '140.211.166.62/32', :method => 'md5'},
  {:type => 'host', :db => 'plone_jira', :user => 'plone_jira', :addr => '140.211.15.105/32', :method => 'md5'},
  {:type => 'host', :db => 'plone_confluence', :user => 'plone_confluence', :addr => '140.211.15.105/32', :method => 'md5'},
  {:type => 'host', :db => 'plone_crowd', :user => 'plone_crowd', :addr => '140.211.15.105/32', :method => 'md5'},
  {:type => 'host', :db => 'freedroid_rb', :user => 'freedroid_rb', :addr => '140.211.15.124/32', :method => 'md5'},
  {:type => 'host', :db => 'jenkins_mirrorbrain', :user => 'jenkins_mirrorbrain', :addr => '140.211.15.121/32', :method => 'md5'},
  {:type => 'host', :db => 'fossology_v2', :user => 'fossology_v2', :addr => '14.211.15.87/32', :method => 'md5'},
  {:type => 'host', :db => 'fossology_gold', :user => 'fossology_gold', :addr => '14.211.15.87/32', :method => 'md5'},
  {:type => 'host', :db => 'sahana', :user => 'sahana', :addr => '140.211.15.167/32', :method => 'md5'},
  {:type => 'host', :db => 'fosstranslation1', :user => 'fosstranslation', :addr => '140.211.15.60/32', :method => 'md5'},
  {:type => 'host', :db => 'fosstranslation2', :user => 'fosstranslation', :addr => '140.211.15.60/32', :method => 'md5'},
  {:type => 'host', :db => 'boost_trac', :user => 'boost_trac', :addr => '140.211.15.166/32', :method => 'md5'},
  {:type => 'host', :db => 'boost_redmine', :user => 'boost_redmine', :addr => '140.211.15.166/32', :method => 'md5'},
  {:type => 'host', :db => 'psf_buildbot', :user => 'psf_buildbot', :addr => '140.211.10.64/26', :method => 'md5'},
  {:type => 'host', :db => 'psf_pypi', :user => 'psf_pypi', :addr => '140.211.10.64/26', :method => 'md5'},
  {:type => 'host', :db => 'psf_rpi', :user => 'psf_rpi', :addr => '140.211.10.64/26', :method => 'md5'},
  {:type => 'host', :db => 'psf_testpypi', :user => 'psf_testpypi', :addr => '140.211.10.64/26', :method => 'md5'},
  {:type => 'host', :db => 'psf-redesign-staging', :user => 'psf-redesign-staging', :addr => '140.211.10.64/26', :method => 'md5'},
  {:type => 'host', :db => 'psf_pypy_codespeed', :user => 'psf_pypy_codespeed', :addr => '140.211.10.64/26', :method => 'md5'},
  {:type => 'host', :db => 'psf_pyramid_community', :user => 'psf_pyramid_community', :addr => '140.211.10.64/26', :method => 'md5'},
  {:type => 'host', :db => 'psf_pycon_2014', :user => 'psf_pycon_2014', :addr => '140.211.10.64/26', :method => 'md5'},
  {:type => 'host', :db => 'psf-evote', :user => 'psf-evote', :addr => '140.211.10.64/26', :method => 'md5'},
  {:type => 'host', :db => 'psf-pycon-2014-staging', :user => 'psf-pycon-2014-staging', :addr => '140.211.10.64/26', :method => 'md5'},
  {:type => 'host', :db => 'musicbrainz_db', :user => 'musicbrainz', :addr => '140.211.15.122/32', :method => 'md5'},
  {:type => 'host', :db => 'systers_prod', :user => 'systers_prod', :addr => '140.211.10.210/32', :method => 'md5'},
  {:type => 'host', :db => 'systers_dev', :user => 'systers_dev', :addr => '140.211.10.211/32', :method => 'md5'},
  {:type => 'host', :db => 'openfcoe_patchwork', :user => 'openfcoe_patchwork', :addr => '140.211.15.205/32', :method => 'md5'},
  {:type => 'host', :db => 'openfcoe_patchwork', :user => 'openfcoe_patchwork', :addr => '140.211.15.215/32', :method => 'md5'},
  {:type => 'host', :db => 'summit_linuxplumbersconf', :user => 'summit_linuxplumbersconf', :addr => '140.211.15.222/32', :method => 'md5'},
  {:type => 'host', :db => 'midnight_trac', :user => 'midnight_trac', :addr => '140.211.15.12/32', :method => 'md5'}
].flatten

node.set["postgresql"]["pg_hba"] = hba_data
