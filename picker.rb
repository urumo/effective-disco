# frozen_string_literal: true

require 'logger'

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
    @result = []
  end

  def pick
    logger.info("Picking from #{from} to #{to} skipping #{skip}")

    result << from # push initial value of the locker to the results array

    pick!(-1) until from == to

    # result.uniq!
    logger.info "Result: #{result}"
    nil
  end

  private

  def pick!(index = -1)
    return if index < @from.count * -1 || @from == to

    dup_lock = @from.dup # duplicate the locker in case we need to revert the changes

    dup_lock[index] = (dup_lock[index] % up_to) + 1 if dup_lock[index] < to[index] # increment the value of the wheel
    # until maximum value is reached, then just roll to 0

    unless skip.include?(dup_lock)
      result << dup_lock unless result.include?(dup_lock)

      @from = dup_lock # if the new value is not in the skip list, then we can assign it to the locker
    end

    pick!(index - 1) # recursively call the method until we reach the end of the locker

    nil
  end
end
