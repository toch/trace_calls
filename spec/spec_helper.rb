# encoding: UTF-8
gem 'minitest'
require 'minitest/autorun'

$LOAD_PATH << File.expand_path('../lib', File.dirname(__FILE__))
require_relative '../lib/trace_calls'
