require 'yaml'
require 'erb'

class ConfigurationLoader
  def self.load(yml_path)
    yaml_contents = File.open(yml_path).read
    hash = YAML.load( ERB.new(yaml_contents).result)
    sym_keys(hash)
  end

  def self.sym_keys(hash)
    hash.map do |k, v|
      if v.is_a? Hash
        [k.to_sym, sym_keys(v)]
      else
        [k.to_sym, v]
      end
    end.to_h
  end
end
