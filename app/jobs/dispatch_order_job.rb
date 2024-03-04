class DispatchOrderJob < ApplicationJob
  queue_as :default

  rescue_from Exception do |exception|
    puts "Error while updating status of the order: #{exception.message}"
  end

  def perform(*args)
    order = args.first
    event_to_call = args.second

    order.send(event_to_call)
    order.save!
  end
end
