# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/authors', type: :request do
  let(:competency_a) { Competency.create!(description: 'Skill A') }
  let(:competency_b) { Competency.create!(description: 'Skill B') }

  path '/api/v1/authors' do
    get('list authors') do
      let!(:author) { Author.create!(name: 'Author for index') }

      response(200, 'successful index') do
        run_test! do
          expect(Author.count).to eq(1)
          expect(JSON(response.body)['collection'].first).to include({ 'id' => author.id, 'name' => author.name })
        end
      end

      context 'when author has competencies' do
        response(200, 'successful index') do
          before do
            author.competencies << [competency_a, competency_b]
          end

          run_test! do
            expect(JSON(response.body)['collection'].first['competencies'])
              .to include({ 'id' => competency_a.id, 'description' => competency_a.description },
                          { 'id' => competency_b.id, 'description' => competency_b.description })
          end
        end
      end
    end

    post('create author') do
      consumes 'application/json'

      parameter name: :request, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          competency_ids: {
            type: :array,
            items: {
              type: :integer
            }
          }
        }
      }

      let(:request) { { name: 'Author for create', competency_ids: [competency_a.id, competency_b.id] } }

      response(201, 'successful create') do
        run_test! do
          expect(JSON(response.body)).to include({ 'name' => 'Author for create' })
          expect(JSON(response.body)['competencies'])
            .to include({ 'id' => competency_a.id, 'description' => competency_a.description },
                        { 'id' => competency_b.id, 'description' => competency_b.description })
        end
      end
    end
  end

  path '/api/v1/authors/{author_id}' do
    parameter name: :author_id, in: :path, type: :integer

    let(:author_id) { author.id }
    let(:author) { Author.create!(name: name) }

    get('show author') do
      before do
        author.competencies << [competency_a, competency_b]
      end

      let(:name) { 'Author for show' }

      response(200, 'successful show') do
        run_test! do
          expect(JSON(response.body)).to include({ 'name' => name })
          expect(JSON(response.body)['competencies'])
            .to include({ 'id' => competency_a.id, 'description' => competency_a.description },
                        { 'id' => competency_b.id, 'description' => competency_b.description })
        end
      end
    end

    patch('update author') do
      consumes 'application/json'
      parameter name: :request, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          competency_ids: {
            type: :array,
            items: {
              type: :integer
            }
          }
        }
      }

      let(:name) { 'Author for update' }
      let(:request) { { name: 'Author after update', competency_ids: [competency_b.id] } }

      response(200, 'successful update') do
        run_test! do
          expect(JSON(response.body)).to include({ 'name' => request[:name] })
          expect(JSON(response.body)['competencies'])
            .to include({ 'id' => competency_b.id, 'description' => competency_b.description })
        end
      end
    end

    delete('delete author') do
      let!(:competency) { Competency.create!(description: 'Skill A') }
      let!(:author_with_best_match_by_competency) { Author.create!(name: 'Author with best match by competency') }
      let!(:course) { Course.create!(title: 'Course title', description: 'Course description', author_id: author_id) }

      before do
        course.competencies << competency
        author.competencies << competency
        author_with_best_match_by_competency.competencies << [competency, Competency.create!(description: 'Skill B')]
        author_with_same_competency = Author.create!(name: 'Author with same competency')
        author_with_same_competency.competencies << competency
      end

      let(:name) { 'Author for delete' }

      response(204, 'successful delete') do
        run_test! do
          expect(author.reload.deleted_at).to be_present
          expect(author.competencies).to be_blank
          expect(course.reload.author_id).to eq(author_with_best_match_by_competency.id)
        end
      end
    end
  end
end
