require 'rails_helper'

RSpec.describe DispatchOrderJob, type: :job do
  let(:order) { create(:order) }

  it "process the order" do
    DispatchOrderJob.perform_now(order, :process_order)
    expect(order.status).to eq("Processing")
  end
end
