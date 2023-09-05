control 'packages' do
  describe package 'rsync' do
    it { should be_installed }
  end

  vim =
    case os.family
    when 'redhat', 'fedora'
      'vim-enhanced'
    else
      'vim'
    end

  describe package vim do
    it { should be_installed }
  end
end
