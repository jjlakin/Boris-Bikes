

module BikeContainer

DEFAULT_CAPACITY = 20

  def bikes
    @bikes ||= []
  end

  def broken_bikes
    @broken_bikes ||= []
  end

  def capacity
    @capacity ||= DEFAULT_CAPACITY
  end

  def capacity=(value)
    @capacity = value
  end

  def bike_count
    bikes.count
  end

  def dock(bike=nil)
    if full?
      raise "Holder is full"  
    elsif bike == nil
      raise 'Error: please specify object to be docked'
    end
    raise "there's a monkey in my rack" unless bike.class == Bike

    bikes << bike
    if self.respond_to?(:fix_bikes)
      self.fix_bikes
    end
  end

  def release(bike_type=:working, bikes_to_release = 1)
    
    if empty?
      raise 'cannot release bike, holder is empty' 
    elsif (bike_type != :working) && (bike_type != :broken)
      raise "Error: please request 'working' or 'broken bike'"
    elsif available_bikes.count == 0
      raise 'there are no working bikes' unless bike_type == :broken
    end

    if bike_type == :broken
      bikes.delete_at(bikes.index {|bike| bike.broken?})
    else
      bikes.delete_at(bikes.index {|bike| !bike.broken?})
    end
  end

  def empty?
    bike_count <= 0
  end

  def full?
    bike_count == capacity
  end

  def available_bikes
    bikes.reject {|bike| bike.broken? }
  end

end