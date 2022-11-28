# frozen_string_literal: true

require 'test_helper'

class Web::Admin::BlogPostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = sign_in_as(:admin)
  end

  test 'index' do
    get admin_blog_posts_url
    assert_response :success
  end

  test 'new' do
    get new_admin_blog_post_url
    assert_response :success
  end

  test 'create' do
    lang = languages(:php)

    params = { blog_post: {
      name: 'name', language_id: lang.id, slug: 'ehu', locale: I18n.locale, body: 'body'
    } }
    post admin_blog_posts_url, params: params
    assert_response :redirect

    assert { lang.blog_posts.find_by slug: params[:blog_post][:slug] }
  end

  test 'edit' do
    blog_post = blog_posts('from-full')

    get edit_admin_blog_post_url(blog_post)
    assert_response :success
  end

  test 'update' do
    blog_post = blog_posts('from-full')

    patch admin_blog_post_url(blog_post), params: { blog_post: { slug: 'mumu' } }
    assert_response :redirect

    blog_post.reload
    assert { blog_post.slug == 'mumu' }
  end
end