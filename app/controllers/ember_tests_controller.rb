class EmberTestsController < ActionController::Base
  def index
    render text: test_html_with_rails_assets, layout: false
  end

  private

  def test_html_with_rails_assets
    add_rails_assets test_html_with_corrected_asset_urls
  end

  def test_html_with_corrected_asset_urls
    test_html.gsub(%r{assets/}i, "#{asset_prefix}/#{app_name}/")
  end

  def test_html
    tests_index_path.read
  end

  def tests_index_path
    app.tests_path.join("index.html")
  end

  def app
    EmberCLI[app_name]
  end

  def app_name
    params.fetch(:app_name)
  end

  def asset_prefix
    Rails.configuration.assets.prefix
  end

  def add_rails_assets(html)
    index = html.index("<base href=\"/\" />")
    html.insert(index, "<script src=\"/assets/application.js\"></script><link rel=\"stylesheet\" href=\"/assets/application.css\">")
  end
end
