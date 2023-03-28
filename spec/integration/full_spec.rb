# frozen_string_literal: true

require 'spec_helper'
require 'netaddr'

describe 'full example' do
  let(:component) do
    var(role: :full, name: 'component')
  end
  let(:dep_id) do
    var(role: :full, name: 'deployment_identifier')
  end

  before(:context) do
    apply(role: :full)
  end

  after(:context) do
    destroy(
      role: :full,
      only_if: -> { !ENV['FORCE_DESTROY'].nil? || ENV['SEED'].nil? }
    )
  end
end
