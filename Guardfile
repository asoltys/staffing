# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'handlebars' do
  watch(/^assignments\/.+(\.html)?(\.handlebars)$/)
end

guard 'coffeescript', :input => 'assignments'

guard 'livereload' do
  watch(%r{assignments/.+\.(css|js|html)})
  watch(%r{css/.+\.(css|js|html)})
end
