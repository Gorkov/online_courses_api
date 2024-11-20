# frozen_string_literal: true

module Transactionable
  private

  def transaction(lock_name: nil, lock_timeout: nil, **options)
    ActiveRecord::Base.transaction(**options) do
      lock_name ? advisory_lock(lock_name, timeout: lock_timeout) { yield } : yield
    end
  end

  def advisory_lock(name, timeout: nil)
    ActiveRecord::Base.with_advisory_lock(name, transaction: true, timeout_seconds: timeout) { yield }
  end
end
