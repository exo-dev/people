# Override Doorkeeper::AccessGrant
#
# Module to add the ability to add the list of devices to a model. 
# This functionality is needed to use the advanced scope system.

class Doorkeeper::AccessGrant
  field :devices, type: Array, default: []

  attr_accessible :devices

  def save_resources(resources)
    if filtered_resources? resources
      self.devices = extract(resources)
      self.save
    end
  end

  private

  def filtered_resources?(resources)
    !resources.nil? and (!resources[:devices].empty? or !resources[:locations].empty?)
  end

  def extract(resources)
    devices = extract_devices(resources) + extract_location_devices(resources)
    devices.uniq
  end

  def extract_devices(resources)
    resources[:devices]
  end

  def extract_location_devices(resources)
    list = Location.find(resources[:locations]).map(&:all_devices).flatten
  end
end
