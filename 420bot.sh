#!/usr/bin/env bash
nohup bundle exec ruby 420bot.rb > logfile.txt 2>&1 & echo $! > run.pid

