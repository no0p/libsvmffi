#!/bin/sh
sudo gem uninstall libsvmffi
gem build libsvmffi.gemspec
sudo gem install $(ls libsvmffi*.gem|tail -n 1)
