require './lib/bike_container'

class ContainerHolder; include BikeContainer; end

describe ContainerHolder do 

let(:bike) { double(:bike,  :class => Bike, :broken? => false)}
let(:broken_bike) { double(:broken_bike, :broken? => true, :class => Bike )}
let(:holder) { ContainerHolder.new }

  def fill_holder(holder)
    20.times { holder.dock(bike) }
  end

  describe "dock" do

    it "should accept a bike" do
      expect(holder.bike_count).to eq(0)
      holder.dock(bike)
      expect(holder.bike_count).to eq(1)
    end

    it "should not accept anything that is not a bike" do
      holder.dock(bike)
      expect(lambda{holder.dock("monkey") }).to raise_error(RuntimeError, "there's a monkey in my rack")
    end

    it "should know when it's full" do
      expect(holder).not_to be_full
      fill_holder holder
      expect(holder).to be_full
    end

    it "should raise an error if no argument is passed" do
      holder.dock(bike)
      expect(lambda{ holder.dock() }).to raise_error(RuntimeError, 'Error: please specify object to be docked')
    end
  end

  describe "release" do

    it "should release a bike" do
      holder.dock(bike)
      holder.release
      expect(holder.bike_count).to eq(0)
    end

    it "should not cause a fault and return an error message if there are no bikes to delete" do
      expect(lambda{ holder.release }).to raise_error(RuntimeError, 'cannot release bike, holder is empty' )
    end

    it "should raise an error if something other than a bike is passed to release method" do
      holder.dock(bike)
      expect(lambda {holder.release(:monkey) }).to raise_error(RuntimeError, "Error: please request 'working' or 'broken bike'")
    end

    it "should only release one bike" do
      2.times { holder.dock(bike) }
      holder.release
      expect(holder.bike_count).to eq(1)
    end

    it "should raise an error when there are no working bikes" do
      holder.dock(broken_bike)
      expect(lambda {holder.release }).to raise_error(RuntimeError, "there are no working bikes")
    end
  end

  it "should not accept a bike if its full" do
    fill_holder holder
    expect(lambda{holder.dock(bike) }).to raise_error(RuntimeError, 'Holder is full')
  end

  it "should provide the list of available bikes" do
    holder.dock(bike)
    holder.dock(broken_bike)
    expect(holder.available_bikes).to eq([bike])
  end

  it "empty? should return true when docking station is empty" do
      expect(holder).to be_empty
    end
  


end