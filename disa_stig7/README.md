This formula is created to enfofce the rhel/centos disa 7 stigs

Has been tested on

* RHEL 7.6
* CentOS 7.6

Required:

1. Copy the custom grains from the _grains directory into your file_root _grains directory (the default is /srv/salt/_grains)
2. Copy the custom states from the _states directory into your file_root _states directory (the default is /srv/salt/_states)
3. Sync custom grains,modules,and states before run:

```
  salt \* saltutil.sync_all
```

Example usage:

```
  salt target state.apply disa_stig7
```

Apply only cat1s:
```
  salt target state.apply disa_stig7.cat1
```
