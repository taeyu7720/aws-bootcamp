# See http://docs.opscode.com/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "workshop"
client_key               "#{current_dir}/workshop.pem"
validation_client_name   "chef-validator"
validation_key           "#{current_dir}/chef-validator.pem"
chef_server_url          "https://chef.4synergy.nl"
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            ["#{current_dir}/../cookbooks"]
