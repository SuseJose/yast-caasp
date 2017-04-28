#! /usr/bin/env rspec

require_relative "test_helper"

require "y2caasp/widgets/system_role"

describe ::Y2Caasp::Widgets::ControllerNode do
  let(:worker_role) { ::Installation::SystemRole.new(id: "worker_role") }

  before do
    allow(subject).to receive(:role).and_return(worker_role)
  end

  it "has label" do
    expect(subject.label).to_not be_empty
  end

  describe "#init" do
    it "is initialized with the previously stored value if present" do
      worker_role["controller_node"] = "previous_location"

      expect(subject).to receive(:value=).with("previous_location")

      subject.init
    end
  end

  describe "#store" do
    before do
      allow(subject).to receive(:value).and_return("value_to_store")
    end

    it "stores current value" do
      expect(worker_role).to receive("[]=").with("controller_node", "value_to_store")
      subject.store
    end
  end

  describe "#validate" do
    it "reports an error if the current value is not a valid IP or FQDN and returns false" do
      allow(Yast::IP).to receive(:Check).and_return(false)
      allow(Yast::Hostname).to receive(:CheckFQ).and_return(false)
      expect(Yast::Popup).to receive(:Error)

      expect(subject.validate).to eql(false)
    end

    it "returns true if the current value is a valid IP" do
      allow(Yast::IP).to receive(:Check).and_return(true)
      allow(Yast::Hostname).to receive(:CheckFQ).and_return(false)

      expect(subject.validate).to eql(true)
    end

    it "returns true if the current value is a valid FQDN" do
      allow(Yast::IP).to receive(:Check).and_return(false)
      allow(Yast::Hostname).to receive(:CheckFQ).and_return(true)

      expect(subject.validate).to eql(true)
    end
  end
end
