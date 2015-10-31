require 'active_record'

require 'unread/base'
require 'unread/read_mark'
require 'unread/readable'
require 'unread/reader'
require 'unread/readable_scopes'
require 'unread/reader_scopes'
require 'unread/garbage_collector'
require 'unread/version'

ActiveRecord::Base.send :include, Unread
