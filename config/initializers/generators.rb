# frozen_string_literal: true

Rails.application.config.generators do |g|
  g.helper(false)
  g.test_framework(:rspec, fixture: false)

  g.controller_specs(false)
  g.helper_specs(false)
  g.system_specs(false)
  g.view_specs(false)
end
