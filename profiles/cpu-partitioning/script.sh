#!/bin/sh

. /usr/lib/tuned/functions

start() {
    python /usr/libexec/tuned/defirqaffinity.py "remove" "$TUNED_isolated_cores_expanded" &&
    tuna -c "$TUNED_isolated_cores_expanded" -i
    sed -i '/^IRQBALANCE_BANNED_CPUS=/d' /etc/sysconfig/irqbalance
    echo "IRQBALANCE_BANNED_CPUS=$TUNED_isolated_cpumask" >>/etc/sysconfig/irqbalance
    return "$?"
}

stop() {
    tuna -c "$TUNED_isolated_cores_expanded" -I &&
    python /usr/libexec/tuned/defirqaffinity.py "add" "$TUNED_isolated_cores_expanded"
    if [ "$1" = "profile_switch" ]
    then
        sed -i '/^IRQBALANCE_BANNED_CPUS=/d' /etc/sysconfig/irqbalance
    fi
    return "$?"
}

verify() {
    python /usr/libexec/tuned/defirqaffinity.py "verify" "$TUNED_isolated_cores_expanded"
    return "$?"
}

process $@
