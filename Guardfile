# Build if anything in src/ changes.
#
# Run from project root directory:
#
#     $ bundle exec guard

guard :bundler do
  watch('Gemfile')
end

guard :shell do
  watch(/^src\//) do |f|
    puts "Rebuilding on: #{f}"
    `./build.sh`
  end
end