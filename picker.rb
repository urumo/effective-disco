# frozen_string_literal: true

require 'logger'

# class Picker starts the brute force of the locker
class Picker
  def self.from(count, value) = Array.new(count).fill(value)

  attr_reader :disk_count,
              :from,
              :to,
              :skip,
              :logger,
              :result,
              :up_to

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

    result << from

    pick!(-1) until from == to

    # result.uniq!
    logger.info "Result: #{result}"
    nil
  end

  private

  def pick!(index = -1)
    return if index < @from.count * -1 || @from == to

    dup_lock = @from.dup

    dup_lock[index] = (dup_lock[index] % up_to) + 1 if dup_lock[index] < to[index]

    unless skip.include?(dup_lock)
      result << dup_lock unless result.include?(dup_lock)

      @from = dup_lock
    end

    pick!(index - 1)

    nil
  end
end
