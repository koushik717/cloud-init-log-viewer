const String appTitle = 'cloud-init Log Viewer';
const String pasteHint = 'Paste your cloud-init log here...';
const String sampleLogButtonLabel = 'Load sample log';
const String parseButtonLabel = 'Analyze log';
const String resetButtonLabel = 'Reset';
const Duration chartAnimationDuration = Duration(milliseconds: 400);

const String sampleLog = '''
2024-01-15 10:23:40,100 - cloudinit.sources - INFO - cloud-init v. 23.4 running init-local at Mon, 15 Jan 2024
2024-01-15 10:23:40,200 - cloudinit.stages - INFO - running init-local
2024-01-15 10:23:40,300 - cloudinit.stages - INFO - Running module local-hostname
2024-01-15 10:23:40,450 - cloudinit.modules.cc_hostname - DEBUG - Setting hostname to ubuntu-server
2024-01-15 10:23:40,500 - cloudinit.stages - INFO - Running module ssh
2024-01-15 10:23:40,800 - cloudinit.modules.cc_ssh - DEBUG - Generating SSH keys
2024-01-15 10:23:41,100 - cloudinit.modules.cc_ssh - WARNING - SSH key already exists, skipping
2024-01-15 10:23:41,200 - cloudinit.stages - INFO - running 'init'
2024-01-15 10:23:41,300 - cloudinit.stages - INFO - Running module users-groups
2024-01-15 10:23:41,500 - cloudinit.modules.cc_users_groups - DEBUG - Adding user ubuntu
2024-01-15 10:23:41,700 - cloudinit.modules.cc_users_groups - DEBUG - Adding user to sudo group
2024-01-15 10:23:41,900 - cloudinit.stages - INFO - Running module write-files
2024-01-15 10:23:42,000 - cloudinit.modules.cc_write_files - DEBUG - Writing /etc/docker/daemon.json
2024-01-15 10:23:42,100 - cloudinit.stages - INFO - running 'modules:config'
2024-01-15 10:23:42,200 - cloudinit.stages - INFO - Running module timezone
2024-01-15 10:23:42,300 - cloudinit.modules.cc_timezone - DEBUG - Setting timezone to UTC
2024-01-15 10:23:42,400 - cloudinit.stages - INFO - Running module ntp
2024-01-15 10:23:42,500 - cloudinit.modules.cc_ntp - DEBUG - Configuring NTP servers
2024-01-15 10:23:42,700 - cloudinit.stages - INFO - Running module packages
2024-01-15 10:23:43,000 - cloudinit.modules.cc_packages - ERROR - Failed to install docker.io: connection refused
2024-01-15 10:23:43,100 - cloudinit.stages - INFO - running 'modules:final'
2024-01-15 10:23:43,200 - cloudinit.stages - INFO - Running module final-message
2024-01-15 10:23:43,300 - cloudinit.modules.cc_final_message - INFO - Boot complete
2024-01-15 10:23:43,400 - cloudinit.stages - INFO - Running module runcmd
2024-01-15 10:23:43,600 - cloudinit.modules.cc_runcmd - DEBUG - Running: systemctl enable docker
2024-01-15 10:23:43,900 - cloudinit.modules.cc_runcmd - DEBUG - Running: systemctl start docker
2024-01-15 10:23:44,200 - cloudinit.modules.cc_runcmd - INFO - All commands completed successfully
''';
