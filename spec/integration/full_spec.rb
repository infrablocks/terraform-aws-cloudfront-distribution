# frozen_string_literal: true

require 'spec_helper'

describe 'full example' do
  let(:component) do
    var(role: :full, name: 'component')
  end
  let(:dep_id) do
    var(role: :full, name: 'deployment_identifier')
  end
  let(:distribution_id) do
    output(role: :full, name: 'distribution_id')
  end
  let(:output_origin_bucket_names) do
    output(role: :full, name: 'origin_bucket_names')
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

  describe 'distribution' do
    it 'creates a cloudfront distribution' do
      expect(cloudfront_distribution(distribution_id)).to(exist)
    end

    it 'outputs the origin bucket names' do
      expect(output_origin_bucket_names).to(
        eq([
             "website-content-#{component}-#{dep_id}",
             "website-images-#{component}-#{dep_id}"
           ])
      )
    end
  end
end
