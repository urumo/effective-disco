# frozen_string_literal: true

require 'logger'
require 'set'

# class Picker starts the brute force of the locker
class Picker
  def self.from(count, value) = Array.new(count).fill(value)

  attr_reader :disk_count, # Count of the locker disks
              :from, # initial position of the locker
              :to, # position to open the locker
              :skip, # skip specified positions
              :logger, # just a plain old logger
              :result, # an array of arrays of integers, where we store all the positions we've been through
              :up_to # max value of the wheel

  def initialize(
    disk_count: 6,
    from: Picker.from(disk_count, 0),
    to: [1, 2, 3],
    skip: [[0, 0, 1], [1, 0, 0]],
    up_to: 9
  )
    @disk_count = disk_count
    @from = from
    @to = to
    @skip = skip
    @logger = Logger.new($stdout)
    @up_to = up_to
    @result = Set[]
    raise ArgumentError, 'Invalid opening position, already included in skip list' if skip.include?(to)
  end

  def pick
    logger.info("Picking from #{from} to #{to} skipping #{skip}")

    result << from # push initial value of the locker to the results array

    until from == to
      from_dup = from.dup # make a copy of the current position of the locker

      pick!(-1)

      next unless from_dup == from # increment the current position of the locker if no changes were made

      @from = from.map { |i| (i + 1) % up_to }

      result << @from unless skip.include?(@from)
    end

    logger.info "Result: #{result}"
    nil
  end

  private

  def pick!(index = -1)
    return if index < @from.count * -1 || @from == to

    dup_lock = @from.dup # duplicate the locker in case we need to revert the changes

    dup_lock[index] = (dup_lock[index] + 1) % up_to unless dup_lock[index] == to[index]
    # increment the value of the wheel
    # until maximum value is reached, then just roll to 0
    # since the program wasn't intended to find the shortest route to the opening sequence
    # we just increment until we find it

    unless skip.include?(dup_lock)
      result << dup_lock

      @from = dup_lock # if the new value is not in the skip list, then we can assign it to the locker
    end

    pick!(index - 1) # recursively call the method until we reach the end of the locker

    nil
  end
end
