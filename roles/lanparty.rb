name "lanparty"
description "ermahgerd lanparty role"
run_list(
  "role[base_managed]",
  "recipe[lanparty]",
  "recipe[lanparty::urbanterror]"
)
default_attributes(
  "authorization" => {
    "sudo" => {
      "users" => [
        "games"
      ],
      "passwordless" => "true",
    }
  },
  "lanparty" => {
    "game_user_keys" => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8sU/cPksdvA8gXwsNmo8p1m3QGuzn8jLcnM1fUIpzS1fWzIUmUyh15DIbJSXvNHN00LcpTjDQUnAjBEMIGZKPTHuanoNLd3pG1m8DPamSHlbK7juJKJPLAvzkwFxugP7joeiEMWVpgtdyq/CsFPGRaNJvAh4qfljRFN8BOI49Ktr67bs++PUjsfpwxWlgiO8pAWvn6yo/UiqufXwtoWAuypCGaULcnn/0fKFajZaaRt3x6DINrrd14sfDXK4tZu1p+iE6jQTqOzIJ8Aq2CAEvYgs5HCezHW2rP+BGGdHM4dmjlDBitAEB+rYU4WFY2yDLqxIOG9RtQ1Nnh6BNpvqR',
      'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAgEAxD27fiYnaBPH+pHthbWX9xY+6B9/2Le20KYVfnQdIPMnZcQ0WLKul50HuObWtU+zpjrYcv4+gEMPLY2qCddXoN8s9NUXsjZ2axQ0taNOOVMf6tzwgEOW3KrnN3DCT2c0eteTQH5UA8WNGpEI4jUg95arSw/xYTjn0uHVgWEU4b/51sDenNadWaCnLxsy5NgMUVAPm5Zmdpk1zjspDs9x1GcCy4HxArogRx2I25na8EwDlgT2PiGvtJ3B7UDrC9/WY6FVCmRG2zQs4UNLxIqgH6aptR+grNBzzsshVpBxd+kAPEqfoiFUcBHB2EtIRjjOVvnoxN9ghCcFk+S+8ZcdENhidzl9+OiugLwCuEcz+FF1BOkKTslc2GDImdGHd6iGTzHFrQ5LYpyFVbwaX7n2Z90Hp6rTagKahWCYzjfcSRZHRCjSdkTXtrfU2GKBJ4d0JTiYDk1uItSNpffFWncxalCUWyOFWDQaplehWIH5qZ5I+fjJ91IMeBxZO6InEtzidUV2LVaAK6Mn13mXJ/WLSUCOspD8T4TgnYzKQFW3citKnRJC9m7jZJ/fYlr9w9sLow/Lpixh/lWo+uxpY2u5ziQLxWBrD6hazDG25a9cASTFdGWRwYI3UrVVgF3G4zELFTQCSTWi86uWT622oGvqOTF1v2hUm18OtBGl3Yssius= basic@manniefresh'
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDp8y3PEQFJQR0s4+3/8i6uG+bLipguiYZQTUAVXwu99cgoprJCSHGP73Mmd/xbBFjRzZYcQAL+0dlsVG6RBNxiuZynKrhFXl0kjh58UplSA5RRIn73feu8XGs0dMehwHdOTuTPPDwVlwQgUGk4YmsI4h/455E+odqlrYnsdpURYm/HWw/zaS1S/DJ5BGw2j1Xgh8mrCO2e5Pwf2byELO8wyzJXQRnaAULoF8r6FQHX1ydW2BKhSnLbt0c5NKMhDbLNoTUtIBm31gfLDGIj3h0VO6TqQj3PpiDoxRklQKNbinUgIuAw67BQvfXaik265JQyhy3aIWnA+elR1oD9gfnb/
    ]
  }
)
