ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" if File.exist?(ENV["BUNDLE_GEMFILE"])
require "bootsnap/setup" if defined?(Bootsnap)

# Rails 7.1 + JSON 3.x compatibility patch (removes deprecated quirks_mode option)
require "json"
module JSON
  class << self
    alias_method :rails_original_generate, :generate
    def generate(obj, opts = nil)
      if opts.is_a?(Hash)
        opts = opts.dup
        opts.delete(:quirks_mode)
      end
      rails_original_generate(obj, opts)
    end

    alias_method :rails_original_pretty_generate, :pretty_generate
    def pretty_generate(obj, opts = nil)
      if opts.is_a?(Hash)
        opts = opts.dup
        opts.delete(:quirks_mode)
      end
      rails_original_pretty_generate(obj, opts)
    end

    alias_method :rails_original_parse, :parse
    def parse(source, *args, **kwargs)
      if args.first.is_a?(Hash)
        kwargs = args.first.merge(kwargs)
      end
      kwargs.delete(:quirks_mode)
      rails_original_parse(source, **kwargs)
    end
  end
end
