
module Aruba
  class WindowsEnvironmentVars < Environment

    def fetch(name, *default)
      name = (found_key = key_ignore_case(name)) if found_key
      block_given? ? yield(name) : ignore_case_for(:fetch, name, *default)
    end

    def key?(name)
      ignore_case_for(__method__, name)
    end

    def [](name)
      ignore_case_for(__method__, name)
    end

    private

    def key_ignore_case(key)
      (found = self.keys.select { |k| k.casecmp(key) == 0 }).empty? ? false : found.first
    end

    def ignore_case_for(method, key, *other_args)
      found_key = key_ignore_case(key)
      found_key ? use_key = found_key : use_key = key
      self.class.superclass.instance_method(method).bind(self).call(use_key, *other_args) # let super raise its Exception if not found
    end

  end
end



