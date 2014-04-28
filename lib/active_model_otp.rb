require "active_model"
require "active_support/core_ext/class/attribute_accessors"
require "cgi"
require "active_model/one_time_password"

ActiveSupport.on_load(:active_record) do
  include ActiveModel::OneTimePassword
end
