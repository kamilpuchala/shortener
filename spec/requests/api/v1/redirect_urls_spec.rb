# spec/requests/api/v1/redirect_urls_spec.rb
require 'swagger_helper'

RSpec.describe 'API V1 RedirectUrls', swagger_doc: 'v1/swagger.yaml', type: :request do
  # INDEX
  path '/api/v1/redirect_urls' do
    get 'Retrieves all redirect URLs' do
      tags 'RedirectUrls'
      produces 'application/json'

      response '200', 'redirect URLs found' do
        let!(:redirect_url) { create(:redirect_url) }

        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   original_url: { type: :string },
                   slug: { type: :string },
                   visits: { type: :integer },
                    expires_at: { type: :string, format: 'date-time', nullable: true }
                 },
                 required: %w[id original_url slug visits expires_at]
               }
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: {
                id: 10,
                original_url: 'https://onet.pl',
                slug: '1000010',
                visits: 0
              }
            }
          }
        end
        run_test!
      end
    end

    # CREATE
    post 'Creates a new redirect URL' do
      tags 'RedirectUrls'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :redirect_url, in: :body, schema: {
        type: :object,
        properties: {
          redirect_url: {
            type: :object,
            properties: {
              original_url: { type: :string, example: 'https://onet.pl' },
              expires_at: { type: :string, format: 'date-time', example: 1.day.from_now.iso8601 },
              custom_slug: { type: :string, example: 'custom123' }
            },
            required: %w[original_url]
          }
        },
        required: [ 'redirect_url' ]
      }

      response '201', 'redirect URL created' do
        let(:redirect_url) do
          { redirect_url: { original_url: 'https://onet.pl', expires_at: 1.day.from_now.iso8601, custom_slug: 'custom123' } }
        end

        schema type: :object,
               properties: {
                 id: { type: :integer },
                 original_url: { type: :string },
                 slug: { type: :string },
                 visits: { type: :integer }
               },
               required: %w[id original_url slug visits]

        run_test!
      end

      response '422', 'invalid request' do
        let(:redirect_url) { { redirect_url: { original_url: 'invalid' } } }

        schema type: :object,
               properties: {
                 errors: {
                   type: :array,
                   items: { type: :string }
                 }
               },
               required: %w[errors]

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: {
                errors: [ "Original url must be a valid URL" ]
              }
            }
          }
        end

        run_test!
      end
    end
  end

  # SHOW
  path '/api/v1/redirect_urls/{id}' do
    get 'Retrieves a single redirect URL' do
      tags 'RedirectUrls'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, description: 'Redirect URL ID'

      response '200', 'redirect URL found' do
        let!(:existing_record) { create(:redirect_url, original_url: 'https://onet.pl', slug: '1000009', visits: 0) }
        let(:id) { existing_record.id }

        schema type: :object,
               properties: {
                 id: { type: :integer },
                 original_url: { type: :string },
                 slug: { type: :string },
                 visits: { type: :integer },
                  expires_at: { type: :string, format: 'date-time', nullable: true }
               },
               required: %w[id original_url slug visits]
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: {
                id: 9,
                original_url: 'https://onet.pl',
                slug: '1000009',
                visits: 0
              }
            }
          }
        end


        run_test!
      end

      response '404', 'redirect URL not found' do
        let(:id) { 999_999 }

        schema type: :object,
               additionalProperties: false,
               properties: {}
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: {}
            }
          }
        end

        run_test!
      end
    end
  end
end
