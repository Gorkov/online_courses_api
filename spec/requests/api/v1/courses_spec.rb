# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/courses', type: :request do
  let(:competency_a) { Competency.create!(description: 'Skill A') }
  let(:competency_b) { Competency.create!(description: 'Skill B') }
  let(:author) { Author.create!(name: 'Author for index') }

  path '/api/v1/courses' do
    get('list courses') do
      let!(:course) do
        Course.create!(title: 'Course for index', description: 'Course for index description', author: author)
      end

      response(200, 'successful index') do
        run_test! do
          expect(Course.count).to eq(1)
          expect(JSON(response.body)['collection'].first)
            .to include({ 'id' => course.id, 'title' => course.title, 'description' => course.description })
          expect(JSON(response.body)['collection'].first['author'])
            .to include({ 'id' => author.id, 'name' => author.name })
        end
      end

      context 'when course has competencies' do
        response(200, 'successful index') do
          before do
            course.competencies << [competency_a, competency_b]
          end

          run_test! do
            expect(JSON(response.body)['collection'].first['competencies'])
              .to include({ 'id' => competency_a.id, 'description' => competency_a.description },
                          { 'id' => competency_b.id, 'description' => competency_b.description })
          end
        end
      end
    end

    post('create courses') do
      consumes 'application/json'

      parameter name: :request, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          description: { type: :string },
          author_id: { type: :integer },
          competency_ids: {
            type: :array,
            items: {
              type: :integer
            }
          }
        }
      }

      let(:request) do
        {
          title: 'title for create',
          description: 'description for create',
          author_id: author.id,
          competency_ids: [competency_a.id, competency_b.id]
        }
      end

      response(201, 'successful create') do
        run_test! do
          expect(JSON(response.body))
            .to include({ 'title' => 'title for create', 'description' => 'description for create' })
          expect(JSON(response.body)['author']).to include({ 'id' => author.id, 'name' => author.name })
          expect(JSON(response.body)['competencies'])
            .to include({ 'id' => competency_a.id, 'description' => competency_a.description },
                        { 'id' => competency_b.id, 'description' => competency_b.description })
        end
      end
    end
  end

  path '/api/v1/courses/{course_id}' do
    parameter name: :course_id, in: :path, type: :integer

    let(:course_id) { course.id }
    let(:course) { Course.create!(title: title, description: description, author: author) }

    get('show course') do
      before do
        course.competencies << [competency_a, competency_b]
      end

      let(:title) { 'title for show' }
      let(:description) { 'description for show' }

      response(200, 'successful show') do
        run_test! do
          expect(JSON(response.body))
            .to include({ 'title' => title, 'description' => description })
          expect(JSON(response.body)['author']).to include({ 'id' => author.id, 'name' => author.name })
          expect(JSON(response.body)['competencies'])
            .to include({ 'id' => competency_a.id, 'description' => competency_a.description },
                        { 'id' => competency_b.id, 'description' => competency_b.description })
        end
      end
    end

    patch('update course') do
      consumes 'application/json'
      parameter name: :request, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          description: { type: :string },
          author_id: { type: :integer },
          competency_ids: {
            type: :array,
            items: {
              type: :integer
            }
          }
        }
      }

      let(:title) { 'title for update' }
      let(:description) { 'description for update' }
      let(:another_author) { Author.create!(name: 'Author for update') }
      let(:request) do
        {
          title: 'title after update',
          description: 'description after update',
          author_id: another_author.id,
          competency_ids: [competency_a.id]
        }
      end

      response(200, 'successful update') do
        run_test! do
          expect(JSON(response.body))
            .to include({ 'title' => request[:title], 'description' => request[:description] })
          expect(JSON(response.body)['author']).to include({ 'id' => another_author.id, 'name' => another_author.name })
          expect(JSON(response.body)['competencies'])
            .to include({ 'id' => competency_a.id, 'description' => competency_a.description })
        end
      end
    end

    delete('delete courses') do
      let(:title) { 'title for delete' }
      let(:description) { 'description for delete' }

      response(204, 'successful delete') do
        run_test! do
          expect(author.competencies).to be_blank
          expect(course.reload.deleted_at).to be_present
        end
      end
    end
  end
end
