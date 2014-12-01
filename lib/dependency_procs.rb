DebianDeps = Proc.new do |task|
  task.info 'Updating package lists...'
  task.execute 'apt-get', 'update'
  task.info 'Installing packages...'
  task.execute 'apt-get', 'install', '-f', '--yes', 'build-essential', 'curl', 'python', 'wget', 'unzip'
  task.info 'Adding nodejs repository...'
  task.execute 'curl', '-sL', 'https://deb.nodesource.com/setup', '|', 'bash', '-'
  task.info 'Purging conflicting packages...'
  task.execute 'apt-get', 'purge', '-f', '--yes', 'nodejs', 'nodejs-legacy', 'npm'
  task.info 'Purging packages no longer required...'
  task.execute 'apt-get', 'autoremove', '--purge', '--yes'
  task.info 'Installing nodejs...'
  task.execute 'apt-get', 'install', '-f', '--yes', 'nodejs'
  task.info 'Installing forever...'
  task.execute 'npm', 'install', '-g', 'forever'
  task.info '=> Done.'
end

RedhatDeps = Proc.new do |task|
  task.info 'Updating package lists...'
  task.execute 'yum', 'clean', 'expire-cache'
  task.info 'Installing packages...'
  task.execute 'yum', 'install', '-y', 'gcc-c++', 'make', 'curl', 'python', 'wget', 'unzip'
  task.info 'Adding nodejs repository...'
  task.execute 'curl', '-sL', 'https://rpm.nodesource.com/setup', '|', 'bash', '-'
  task.info 'Installing nodejs...'
  task.execute 'yum', 'install', '-y', 'nodejs'
  task.info 'Installing forever...'
  task.execute 'npm', 'install', '-g', 'forever'
  task.info '=> Done.'
end