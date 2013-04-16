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
default['lanparty']['urbanterror']['full_game_dir'] = "#{node['lanparty']['game_dir']}/#{node['lanparty']['urbanterror']['game_dir']}"

# Game configuration settings
default['lanparty']['urbanterror']['admin_name']    = "#{node['lanparty']['game_user']}"
default['lanparty']['urbanterror']['admin_email']   = node.has_key?(:domain) ? "#{node['lanparty']['game_user']}@#{domain}" : "#{node['lanparty']['game_user']}" 
default['lanparty']['urbanterror']['sv_hostname']   = node.has_key?(:domain) ? "#{domain} Urban Terror" : "#{node['lanparty']['game_user']} Urban Terror Server" 
default['lanparty']['urbanterror']['sv_maxclients'] = "12"
# g_gametype 
# 0=FreeForAll, 1=Last Man Standing, 3=TeamDeathMatch, 4=Team Survivor,
# 5=Follow the Leader, 6=Capture and Hold, 7=Capture The Flag, 8=Bombmode
default['lanparty']['urbanterror']['g_gametype']    = "7"
default['lanparty']['urbanterror']['rconpassword']  = nil
default['lanparty']['urbanterror']['g_password']    = nil
default['lanparty']['urbanterror']['timelimit']     = "20"
default['lanparty']['urbanterror']['fraglimit']     = "10"
default['lanparty']['urbanterror']['capturelimit']  = "4"
default['lanparty']['urbanterror']['g_warmup']      = "15"


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
