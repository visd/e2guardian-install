/var/log/e2guardian/access.log {
    compress
    size 25M
    rotate 15
    prerotate
        /etc/init.d/e2guardian stop > /dev/null 2>&1 || true
    endscript
    postrotate
        /etc/init.d/e2guardian start > /dev/null 2>&1
    endscript
}
