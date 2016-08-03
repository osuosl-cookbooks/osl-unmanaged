%w(osl-root osl-osuadmin).each do |u|
  r = resources(user_account: u)
  r.ssh_keys = [
    'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC4w+aCeJg1QVcBmxqfZRn/nVutL/pA8VdD' \
    'G//Cp+vY/enJ6TjemOxvmLt0n17yx51k70vlED2PwFTgPKARswh2gkT0Qo+cn3Ose4VFB110' \
    'p3BGLKB3dabZVZ6VGyPmF1KHFwUXz9lBqIxFnlg4JxvVfMn3QMPAypygftbCquF6vbrdqx7H' \
    'Ixz5PFIn/sek5BR5LoEQtrrYCzpgtf6PW7G32MvKG4WpE+QHHNiIUOpqKm7TfgTK1ADQ0sqY' \
    'qdsDP5wPEueoLMwRmYQWnOAJFWImtjEMq8kgwn5fO5TV9hostEKqf94RpRBsym9MumVuMuSd' \
    '0Rsw9keWgvbz1n1omHBi4/82zDabsKFcAnMTxt//KzTbaQxDmULNT5XE3vcM7xJ815koujus' \
    'rwQbbABJw0g9Iu9Gg30REKJofVoKEkfxikALi5lKTY0uoPfyx7XuiewVkZcLXkoez4iYCIPZ' \
    'gdBQwb/tpRgIk3J8A83PHpp0lvEZRWcSGjqMoRpS9ekC7nXPtjfPKX0wYDkaWy2Uv6Lis0fH' \
    'aDpDnaE8Ucw5UWBePyCg6qCD3Z3sGnXJlaD3B1MqhYQBWxZvlKCKpyPx7w9cPHqmwvFUYB0f' \
    'by9lG/7kg6uYf09wyp6QT8kZTybM68UIHu681rZQE8dZiVHMqBU255zH09kDI8bR8ix4KdFb' \
    'Kw== bootstrap'
  ]
end
