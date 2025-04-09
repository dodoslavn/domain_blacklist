TIMER='[Unit]
Description=Run script to refresh blacklists for DNS

[Timer]
OnCalendar=hourly
Persistent=true

[Install]
WantedBy=timers.target'
