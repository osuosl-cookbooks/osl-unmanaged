#
# Cookbook Name:: lanparty
# Attributes:: urbanterror
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

# Game install settings
default['lanparty']['urbanterror']['version']       = 'UrbanTerror42_full_009.zip'
default['lanparty']['urbanterror']['base_url']      = 'http://staff.osuosl.org/~basic'
default['lanparty']['urbanterror']['game_dir']      = 'UrbanTerror42'

# Game configuration settings
default['lanparty']['urbanterror']['admin_name']    = "#{node['lanparty']['game_user']}"
default['lanparty']['urbanterror']['admin_email']   = node.has_key?(:domain) ? "urt-admin@#{domain}" : 'urt-admin'
default['lanparty']['urbanterror']['rconpassword']  = nil
default['lanparty']['urbanterror']['g_password']    = nil
#set timelimit "20" //time in minutes before map is over, 0=never
#set fraglimit "10" //amount of points to be scored before map is over, 0=never
#set capturelimit "4" //amount of flagcaps before map is over, 0=never
#set g_warmup "15" //time in seconds before game starts when changed to a new map. Gives slower computers time to load before game starts


# Map list becomes an array that can be easily overridden.
default['lanparty']['urbanterror']['mapcycle']      = [
  'ut4_casa',
  'ut4_bohemia',
  'ut4_kingdom',
  'ut4_turnpike',
  'ut4_abbey',
  'ut4_cascade',
  'ut4_prague',
  'ut4_mandolin',
  'ut4_uptown',
  'ut4_algiers',
  'ut4_austria',
  'ut4_kingpin',
  'ut4_maya',
  'ut4_tombs',
  'ut4_elgin',
  'ut4_oildepot',
  'ut4_swim',
  'ut4_harbortown',
  'ut4_ramelle',
  'ut4_raiders',
  'ut4_toxic',
  'ut4_sanc',
  'ut4_riyadh',
  'ut4_ambush',
  'ut4_eagle',
  'ut4_suburbs',
  'ut4_crossing',
  'ut4_subway',
  'ut4_tunis',
  'ut4_thingley'
  ]
