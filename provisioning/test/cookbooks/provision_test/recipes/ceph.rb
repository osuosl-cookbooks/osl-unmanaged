# Format wal and blk devices
('c'..'d').to_a.each do |i|
  execute "create /dev/sd#{i}" do
    command <<-EOF
      parted --script /dev/sd#{i} \
        mklabel gpt \
        mkpart primary 1MiB 30GB \
        mkpart primary 30GB 60GB \
        mkpart primary 60GB 90GB \
        mkpart primary 90GB 120GB \
        mkpart primary 120GB 150GB \
        mkpart primary 150GB 180GB \
        mkpart primary 180GB 210GB \
        mkpart primary 210GB 240GB
    EOF
    creates "/dev/sd#{i}1"
  end
end

# Create OSD devices
('e'..'l').to_a.each do |i|
  execute "create sd#{i}" do
    command <<-EOF
      parted --script /dev/sd#{i} \
        mklabel gpt \
        mkpart primary 1 100%
    EOF
    creates "/dev/sd#{i}1"
  end
end
