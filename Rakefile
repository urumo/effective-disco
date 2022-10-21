# frozen_string_literal: true

require_relative 'config'
require_relative 'picker'
require 'benchmark'

task :run do
  picker = Picker.new(
    disk_count: Config::DISK_COUNT,
    from: Config::FROM,
    to: Config::TO,
    skip: Config::SKIP,
    up_to: Config::WHEEL_MAX
  )

  Benchmark.bm do |x|
    x.report { picker.pick }
  end
end
