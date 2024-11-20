# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/competencies', type: :request do
  path '/api/v1/competencies' do
    get('list competencies') do
      let!(:competency) { Competency.create!(description: 'Competency for index') }

      response(200, 'successful index') do
        run_test! do
          expect(JSON(response.body)['collection'].first)
            .to include({ 'id' => competency.id, 'description' => competency.description })
        end
      end
    end

    post('create competency') do
      consumes 'application/json'

      parameter name: :request, in: :body, schema: {
        type: :object,
        properties: {
          description: { type: :string }
        }
      }

      let(:request) { { description: 'Competency for create' } }

      response(201, 'successful create') do
        run_test! do
          expect(JSON(response.body)).to include({ 'description' => 'Competency for create' })
        end
      end
    end
  end

  path '/api/v1/competencies/{id}' do
    parameter name: :id, in: :path, type: :integer

    let(:competency) { Competency.create!(description: description) }
    let(:id) { competency.id }

    get('show competency') do
      let(:description) { 'Competency for show' }

      response(200, 'successful show') do
        run_test! do
          expect(JSON(response.body)).to include({ 'description' => description })
        end
      end
    end

    patch('update competency') do
      consumes 'application/json'
      parameter name: :request, in: :body, schema: {
        type: :object,
        properties: {
          description: { type: :string }
        }
      }

      let(:description) { 'Competency for update' }
      let(:request) { { description: description } }

      response(200, 'successful update') do
        run_test! do
          expect(JSON(response.body)).to include({ 'description' => description })
        end
      end
    end

    delete('delete competency') do
      let(:description) { 'Competency for delete' }

      response(204, 'successful delete') do
        run_test! do
          expect(competency.reload.deleted_at).to be_present
        end
      end
    end
  end
end
