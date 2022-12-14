# -*- encoding: utf-8 -*-
# stub: blind_index 2.3.1 ruby lib

Gem::Specification.new do |s|
  s.name = "blind_index".freeze
  s.version = "2.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Andrew Kane".freeze]
  s.date = "2022-09-06"
  s.email = "andrew@ankane.org".freeze
  s.homepage = "https://github.com/ankane/blind_index".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.6".freeze)
  s.rubygems_version = "3.3.3".freeze
  s.summary = "Securely search encrypted database fields".freeze

  s.installed_by_version = "3.3.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<activesupport>.freeze, [">= 5.2"])
    s.add_runtime_dependency(%q<argon2-kdf>.freeze, [">= 0.1.1"])
  else
    s.add_dependency(%q<activesupport>.freeze, [">= 5.2"])
    s.add_dependency(%q<argon2-kdf>.freeze, [">= 0.1.1"])
  end
end
