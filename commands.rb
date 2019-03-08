# Require N commands each of which should be their own class.

project_root = File.dirname(File.absolute_path(__FILE__))
Dir.glob(project_root + '/commands/*') {|file| require file}