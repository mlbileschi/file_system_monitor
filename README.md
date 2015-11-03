## file_system_monitor ##
TL;DR Command-line tool to run a command (and stop the old one) every time there's a filesystem change.

Take a command and a path, and run that command whenever there are any changes to those files. It kills previous invocations. It's like guard for anything. You never have to think "oh, I should run this," because what's running is always the latest thing. 

It works especially well with IntelliJ's auto-save after x idle seconds (cmd + , then search for "save idle"), or any other auto-save IDE setting.

### Give me that! ###

```
brew tap mlbileschi/tap
brew install mlbileschi/tap/file_system_monitor
file_system_monitor --help
```

### Examples ###

Continuously run `mvn test`, excluding any maven generated files 
```
ruby file_system_monitor.rb -i "." -e "target" -c "mvn test"
```

Continuously run `pants test`, excluding  
```
ruby file_system_monitor.rb \
    -i "." \
    -e ".git"
    -e ".pants.d" \
    -c "./pants test src/tests/java/com/mbileschi:fun_ml"
```

### Feedback ###

Please let me know what you think!
`mlbileschi [at] gmail.com`

Issues very welcome; pull requests even more welcome.
