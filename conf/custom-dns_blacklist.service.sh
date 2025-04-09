SERVICE='[Unit]
Description=Custom script to refresh blocked domain addresses in DNS 

[Service]
Type=simple
ExecStart='$FOLDER'

[Install]
WantedBy=timers.target'
