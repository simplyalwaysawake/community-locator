# frozen_string_literal: true

# ActiveAdmin's stylesheet is built with the Tailwind v4 CLI (see package.json),
# separate from the app's own Tailwind v3 pipeline. Hook its build into
# assets:precompile so deploys ship a compiled app/assets/builds/active_admin.css.
namespace :active_admin do
  desc 'Build the ActiveAdmin Tailwind stylesheet'
  task build_css: :environment do
    system('npm run build:css:admin', exception: true)
  end
end

Rake::Task['assets:precompile'].enhance(['active_admin:build_css']) if Rake::Task.task_defined?('assets:precompile')

# Build the stylesheet before tests too, so views that link it render (mirrors
# how tailwindcss-rails auto-builds its own bundle before the test task).
if Rake::Task.task_defined?('test:prepare')
  Rake::Task['test:prepare'].enhance(['active_admin:build_css'])
elsif Rake::Task.task_defined?('db:test:prepare')
  Rake::Task['db:test:prepare'].enhance(['active_admin:build_css'])
end
