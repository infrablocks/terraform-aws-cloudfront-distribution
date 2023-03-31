# frozen_string_literal: true

require 'spec_helper'

describe 'distribution' do
  let(:component) do
    var(role: :root, name: 'component')
  end
  let(:deployment_identifier) do
    var(role: :root, name: 'deployment_identifier')
  end

  describe 'by default' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.distribution_origins = [
          {
            id: 'origin',
            type: 's3',
            bucket_name_prefix: 'website-content'
          }
        ]
        vars.distribution_default_cache_behavior = {
          target_origin_id: 'origin'
        }
        vars.distribution_viewer_certificate = {
          acm_certificate_arn:
            output(role: :prerequisites, name: 'certificate_arn')
        }
      end
    end

    it 'creates a distribution' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_cloudfront_distribution')
              .once)
    end
  end
end
